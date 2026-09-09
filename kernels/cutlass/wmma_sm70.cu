// Reviewer fixture for CUTLASS v3.5.1, f7b19de32c5d1f3cedfc735c2849f12b537522ee.
// Build against a full checkout at that revision (the vendored review headers
// are deliberately not a complete CUTLASS installation). See the root README.
#include <cuda_runtime.h>
#include <cutlass/gemm/device/gemm.h>
#include <cutlass/epilogue/thread/linear_combination.h>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

using Output = cutlass::epilogue::thread::LinearCombination<
    float, 1, float, float, cutlass::epilogue::thread::ScaleType::Nothing>;
using Gemm = cutlass::gemm::device::Gemm<
    cutlass::half_t, cutlass::layout::RowMajor,
    cutlass::half_t, cutlass::layout::ColumnMajor,
    float, cutlass::layout::RowMajor, float,
    cutlass::arch::OpClassWmmaTensorOp, cutlass::arch::Sm70,
    cutlass::gemm::GemmShape<64, 64, 16>,
    cutlass::gemm::GemmShape<32, 32, 16>,
    cutlass::gemm::GemmShape<16, 16, 16>, Output,
    cutlass::gemm::threadblock::GemmIdentityThreadblockSwizzle<1>,
    1, 1, 1, false, cutlass::arch::OpMultiplyAdd>;

static_assert(Gemm::GemmKernel::Mma::Shape::kM == 64);
static_assert(Gemm::GemmKernel::Mma::Shape::kN == 64);
static_assert(Gemm::GemmKernel::Mma::Shape::kK == 16);
static_assert(Gemm::GemmKernel::kThreadCount == 128);
// Each shared-memory operand tile covers all 128 threads' 128-bit accesses.
static_assert(Gemm::ThreadblockShape::kM * Gemm::ThreadblockShape::kK >=
              Gemm::GemmKernel::kThreadCount * 8);
static_assert(Gemm::ThreadblockShape::kN * Gemm::ThreadblockShape::kK >=
              Gemm::GemmKernel::kThreadCount * 8);
static_assert(Gemm::kStages == 1);
static_assert(!Gemm::kSplitKSerial);

static void checked(cudaError_t result) {
  if (result != cudaSuccess) {
    std::fprintf(stderr, "%s\n", cudaGetErrorString(result));
    std::exit(1);
  }
}

// This launcher enforces the source-proof shape restriction. Applications must
// additionally supply valid disjoint allocations, matching strides, and the
// pinned device semantics; the Lean arithmetic projection does not prove memory.
static cutlass::Status launch(int m, int n, int k, cutlass::half_t const *a,
                             cutlass::half_t const *b, float *d) {
  if (m <= 0 || n <= 0 || k <= 0 || k % 16 != 0)
    return cutlass::Status::kErrorInvalidProblem;
  Gemm::Arguments args({m, n, k}, {a, k}, {b, k}, {d, n}, {d, n}, {1.0f, 0.0f}, 1);
  Gemm op;
  auto status = op.can_implement(args);
  if (status != cutlass::Status::kSuccess) return status;
  return op(args);
}

int main() {
  cudaDeviceProp device;
  checked(cudaGetDeviceProperties(&device, 0));
  if (device.major != 7 || device.minor != 0 || std::strstr(device.name, "V100") == nullptr) {
    std::fprintf(stderr, "This pinned fixture requires a V100; found %s\n", device.name);
    return 1;
  }
  std::fprintf(stderr, "GPU: %s; CUDA runtime: %d\n", device.name, CUDART_VERSION);
  constexpr int m = 65, n = 67, k = 32;
  std::vector<cutlass::half_t> a(m * k), b(k * n);
  std::vector<float> d(m * n);
  const float values[] = {0.0f, 1.0f, -1.0f, 0.5f, -0.5f};
  for (int i = 0; i < m; ++i)
    for (int l = 0; l < k; ++l) a[i * k + l] = cutlass::half_t(values[(i + l) % 5]);
  for (int j = 0; j < n; ++j)
    for (int l = 0; l < k; ++l) b[j * k + l] = cutlass::half_t(values[(l + 3 * j) % 5]);
  cutlass::half_t *da, *db;
  float *dd;
  checked(cudaMalloc(&da, a.size() * sizeof(a[0])));
  checked(cudaMalloc(&db, b.size() * sizeof(b[0])));
  checked(cudaMalloc(&dd, d.size() * sizeof(d[0])));
  checked(cudaMemcpy(da, a.data(), a.size() * sizeof(a[0]), cudaMemcpyHostToDevice));
  checked(cudaMemcpy(db, b.data(), b.size() * sizeof(b[0]), cudaMemcpyHostToDevice));
  checked(cudaMemset(dd, 0, d.size() * sizeof(d[0])));
  auto status = launch(m, n, k, da, db, dd);
  if (status != cutlass::Status::kSuccess) {
    std::fprintf(stderr, "%s\n", cutlassGetStatusString(status));
    return 1;
  }
  checked(cudaDeviceSynchronize());
  checked(cudaMemcpy(d.data(), dd, d.size() * sizeof(d[0]), cudaMemcpyDeviceToHost));
  std::printf("{\"m\":65,\"n\":67,\"k\":32,\"bits\":[");
  for (size_t i = 0; i < d.size(); ++i) {
    std::uint32_t bits;
    std::memcpy(&bits, &d[i], sizeof bits);
    std::printf("%s%u", i ? "," : "", bits);
  }
  std::printf("]}\n");
  checked(cudaFree(da)); checked(cudaFree(db)); checked(cudaFree(dd));
}
