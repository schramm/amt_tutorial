function s = get_cqt_spectrogram(frames, sparKernel)

s = [];
for i=1:size(frames,2)
    frame = frames(:,i)';    
    cq= fft(frame,size(sparKernel,1)) * sparKernel;
    s(:,i) = cq';
end
