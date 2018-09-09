
function [frames,idx] = get_audio_frames(x, win_size, hop_size)
  
   if hop_size > win_size
         warning('hop_size must (ideally) be not bigger than win_size. setting: hop_size=win_size.');
         hop_size = win_size;
   end

   num_frames = floor(length(x)/hop_size);
   frames = zeros(win_size, num_frames+1);
   idx = [];

 c=1;  
for i=1:hop_size:length(x)-win_size
      frames(:,c) = x(i:i+win_size-1);
      c=c+1;
      idx = [idx; [i, i+win_size-1]];
end



