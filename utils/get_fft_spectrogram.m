
function [s, cplx ] = get_fft_spectrogram(audio_frames,N)

if nargin<2
    N = size(audio_frames,1); % num freq bins
end

L = size(audio_frames,2); % num audio frames 
s = zeros([N,L]);
cplx = zeros([N,L]);

for i=1:size(audio_frames,2)
      frame = audio_frames(:,i);
      f = fft(frame,N);
      cplx(:,i) = f; 
      %f(ceil(end/2)+1:end)=0;      
      s(:,i) = (abs(f).^2);       
end


