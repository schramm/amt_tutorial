
function s = get_fft_spectrogram(audio_frames,N)

if nargin<2
    N = size(audio_frames,1); % num freq bins
end

L = size(audio_frames,2); % num audio frames 
s = zeros([N,L]);

%% window function (avoiding boundaries artefacts)
% warning: this assumes all audio frames have same length
w = oBlackmanharris(size(audio_frames,1)); 

for i=1:size(audio_frames,2)
      frame = audio_frames(:,i) .*w;
      f = fft(frame,N);
      f(ceil(end/2)+1:end)=0;      
      s(:,i) = (abs(f).^2);
end


