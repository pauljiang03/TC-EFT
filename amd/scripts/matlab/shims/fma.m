function d = fma(a, b, c)
% Octave stand-in for MATLAB's fma on binary32 operands: a*b + c rounded once to binary32 (RNE).
% p = a*b is exact in double. The double sum s = p + c and the TwoSum error e give the exact
% value s + e. Its binary32 rounding differs from that of s only when s is the midpoint of two
% adjacent binary32 values, where the sign of e decides.
  p = double(a) * double(b);
  c = double(c);
  s = p + c;
  bb = s - p;
  e = (p - (s - bb)) + (c - bb);
  d = single(s);
  if e == 0 || ~isfinite(d) || double(d) == s
    return
  end
  if double(d) < s
    lo = d; hi = nextup(d);
  else
    hi = d; lo = -nextup(-d);
  end
  if s - double(lo) == double(hi) - s
    if e > 0
      d = hi;
    else
      d = lo;
    end
  end
end

function y = nextup(x)
% Next binary32 value above x.
  if x == 0
    y = single(2^-149);
  elseif x > 0
    y = typecast(typecast(single(x), 'uint32') + uint32(1), 'single');
  else
    y = typecast(typecast(single(x), 'uint32') - uint32(1), 'single');
  end
end
