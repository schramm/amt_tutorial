function ft= slowFT(x, N)
%
%  inputs:
%     x => input signal
%     N => num of frequency points (frequency resolution)
%  output:
%     ft => complex fourier coeficients
%
% The purpose of this function is only to illustrate the basis of the
% Fourier Transform. real implementations are usually based on the FFT
% algorithm. See https://en.wikipedia.org/wiki/Cooley–Tukey_FFT_algorithm

for k=0:N-1;
    ft(k+1)= x(1:N) * (hamming(N) .* exp( -2*pi*1i*k*(0:N-1)'/N)) / N;
end