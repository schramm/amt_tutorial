
% window analysis size
win_size = 2048;
% hop (step) size 
hop_size = 512;
% split entire audio signal into several frames 
[frames,idx] = get_audio_frames(x, win_size, hop_size);

size(frames),