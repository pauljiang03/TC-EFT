function r = bitshift(a, n)
% MATLAB semantics for integer bitshift: shifting by at least the word width gives zero.
% Octave's builtin reduces large shift counts modulo the width, which the MATLAB model relies on
% not happening when it shifts a significand entirely out (e.g. `bitshift(sum_2, -shift)` in
% Generic_BFMA_TC.m with shift >= 64).
  switch class(a)
    case {'uint8', 'int8'}, w = 8;
    case {'uint16', 'int16'}, w = 16;
    case {'uint32', 'int32'}, w = 32;
    case {'uint64', 'int64'}, w = 64;
    otherwise, w = 53;
  end
  if isscalar(n) && ~isscalar(a)
    n = repmat(n, size(a));
  end
  if isscalar(a) && ~isscalar(n)
    a = repmat(a, size(n));
  end
  n = double(n);
  r = a;
  big = abs(n) >= w;
  if any(big(:))
    r(big) = 0;
  end
  ok = ~big;
  if any(ok(:))
    r(ok) = builtin('bitshift', a(ok), n(ok));
  end
end
