/* Targeted FP16 -> FP32 WMMA evidence harness.
 * Interface and row-major A / column-major B,C layout follow the v0.5 source
 * recorded in provenance.json. Inputs populate ALL 16 k positions of A row 0
 * and B column 0; C(0,0) carries the supplied accumulator. Other cells start at
 * +0. No float conversion is applied to any input bits. One complete warp
 * executes one mma_sync. The raw output includes all 256 column-major cells;
 * the model comparison concerns cell (0,0).
 * Build/run through run.py to preserve compiler flags, PTX, SASS and metadata.
 */
#include <cuda_runtime.h>
#include <cuda_fp16.h>
#include <mma.h>
#include <cstdint>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <stdexcept>
#include <string>

static void checked(cudaError_t err) {
  if (err != cudaSuccess) throw std::runtime_error(cudaGetErrorString(err));
}

__global__ void targeted_wmma(const __half *a, const __half *b, float *c) {
  nvcuda::wmma::fragment<nvcuda::wmma::matrix_a, 16, 16, 16, __half,
                         nvcuda::wmma::row_major> af;
  nvcuda::wmma::fragment<nvcuda::wmma::matrix_b, 16, 16, 16, __half,
                         nvcuda::wmma::col_major> bf;
  nvcuda::wmma::fragment<nvcuda::wmma::accumulator, 16, 16, 16, float> cf;
  nvcuda::wmma::load_matrix_sync(af, a, 16);
  nvcuda::wmma::load_matrix_sync(bf, b, 16);
  nvcuda::wmma::load_matrix_sync(cf, c, 16, nvcuda::wmma::mem_col_major);
  nvcuda::wmma::mma_sync(cf, af, bf, cf, false);
  nvcuda::wmma::store_matrix_sync(c, cf, 16, nvcuda::wmma::mem_col_major);
}

static uint32_t word(const std::string &s, unsigned width) {
  if (s.empty() || s.find_first_not_of("0123456789abcdef") != std::string::npos)
    throw std::runtime_error("Invalid hex word");
  size_t end = 0;
  auto n = std::stoull(s, &end, 16);
  if (end != s.size() || n >= (uint64_t(1) << width))
    throw std::runtime_error("Word outside format width");
  return static_cast<uint32_t>(n);
}

int main() {
  try {
    static_assert(sizeof(__half) == 2 && sizeof(float) == 4, "Unexpected format widths");
    int device = 0, driver = 0, runtime = 0;
    checked(cudaGetDevice(&device));
    cudaDeviceProp prop{};
    checked(cudaGetDeviceProperties(&prop, device));
    checked(cudaDriverGetVersion(&driver));
    checked(cudaRuntimeGetVersion(&runtime));
    std::cout << "{\"device\":" << std::quoted(prop.name)
              << ",\"major\":" << prop.major << ",\"minor\":" << prop.minor
              << ",\"driver\":" << driver << ",\"runtime\":" << runtime
              << ",\"device_ordinal\":" << device << "}\n";
    __half *da = nullptr, *db = nullptr;
    float *dc = nullptr;
    checked(cudaMalloc(reinterpret_cast<void **>(&da), 256 * sizeof(__half)));
    checked(cudaMalloc(reinterpret_cast<void **>(&db), 256 * sizeof(__half)));
    checked(cudaMalloc(reinterpret_cast<void **>(&dc), 256 * sizeof(float)));
    std::string line;
    while (std::getline(std::cin, line)) {
      if (line.empty()) continue;
      std::istringstream row(line);
      std::string id, s;
      if (!(row >> id) || id.find_first_not_of("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/_") != std::string::npos)
        throw std::runtime_error("Invalid vector id");
      uint16_t a[256]{}, b[256]{};
      uint32_t c[256]{};
      for (int k = 0; k < 16; ++k) {
        if (!(row >> s)) throw std::runtime_error("Missing A word");
        a[k] = static_cast<uint16_t>(word(s, 16));
        if (!(row >> s)) throw std::runtime_error("Missing B word");
        b[k] = static_cast<uint16_t>(word(s, 16));
      }
      if (!(row >> s)) throw std::runtime_error("Missing accumulator");
      c[0] = word(s, 32);
      if (row >> s) throw std::runtime_error("Trailing input");
      checked(cudaMemcpy(da, a, sizeof(a), cudaMemcpyHostToDevice));
      checked(cudaMemcpy(db, b, sizeof(b), cudaMemcpyHostToDevice));
      checked(cudaMemcpy(dc, c, sizeof(c), cudaMemcpyHostToDevice));
      targeted_wmma<<<1, 32>>>(da, db, dc);
      checked(cudaGetLastError());
      checked(cudaDeviceSynchronize());
      checked(cudaMemcpy(c, dc, sizeof(c), cudaMemcpyDeviceToHost));
      std::cout << "{\"id\":" << std::quoted(id) << ",\"outputs\":[";
      for (int i = 0; i < 256; ++i) {
        if (i) std::cout << ',';
        std::cout << '"' << std::hex << std::setw(8) << std::setfill('0') << c[i] << '"';
      }
      std::cout << "]}\n" << std::dec;
    }
    checked(cudaFree(da)); checked(cudaFree(db)); checked(cudaFree(dc));
    return 0;
  } catch (const std::exception &e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
