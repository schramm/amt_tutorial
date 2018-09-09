
function s = from_spectrogram_to_audio(spec, idx)

s = zeros([1, idx(end,2)]);
n_frames = size(spec,2);
frames = zeros(size(spec));
for i=1:n_frames
   frames(:,i) = ifft(spec(:,i));
end

for i=1:size(idx,1)
    s(idx(i,1):idx(i,2)) = s(idx(i,1):idx(i,2))+frames(:,i)';
end
