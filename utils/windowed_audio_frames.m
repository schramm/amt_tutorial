function [wf] = windowed_audio_frames(frames)

s=size(frames);

% if nargin<2
%     a = [];
% else
%     a = zeros([1,s(2)*hop_size+s(1)]);
% end

wf = frames; % alloc output data
for i=1:size(frames,2)
      wf(:,i) = windowed_signal(frames(:,i));
      
      if nargin==2
          %[(i-1)*hop_size+1 , (i-1)*hop_size+s(1)],
         % a( (i-1)*hop_size+1 : (i-1)*hop_size+s(1) ) = a( (i-1)*hop_size+1 : (i-1)*hop_size+s(1) )+w';
      end
end


