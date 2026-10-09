function r = dot(a, b)
% MATLAB semantics for the empty inner product: dot of two empty vectors is 0. Octave rejects
% empty operands whose shapes differ (0x0 and 1x0), which occur in Generic_BFMA_TC.m when every
% product of a block is zero.
  if isempty(a) && isempty(b)
    r = 0;
  else
    r = builtin('dot', a, b);
  end
end
