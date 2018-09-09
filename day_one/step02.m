
% window analysis size
win_size = 2048;
% hop (step) size 
hop_size = 2048-512;
% split entire audio signal into several frames 
[frames,idx] = get_audio_frames(x, win_size, hop_size);
%size(frames),

figure; hold on;
for i=1:size(frames,2)-1    
   plot(idx(i,1):idx(i,2), frames(:,i)); 
end
