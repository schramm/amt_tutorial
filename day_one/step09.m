

% We can follow many approaches to computer the CQT.
% Here, we can see two:

%% First option (easier to implement)  
% Judith C. Brown, Calculation of a constant Q spectral transform, J. Acoust. Soc. Am., 89(1):425–434, 1991.
% This CQT implementation uses FFT and the sparse spectrum characteristic (mostly zeros) to accelerate the computation.
sparKernel= sparseKernel(minFreq, maxFreq, bins, fs);
s = [];
for i=1:size(frames,2)
    frame = frames(:,i)';
    cq= fft(frame,size(sparKernel,1)) * sparKernel;
    s(:,i) = cq';
end

%% Second option (better quality)
%Christian Schörkhuber, Anssi Klapuri et all
% A Matlab Toolbox for Efficient Perfect Reconstruction Time-Frequency Transforms with Log-Frequency Resolution
% https://www.cs.tut.fi/sgn/arg/CQT/
[intCQT, hop_size_samples] = computeCQT(filename);


    