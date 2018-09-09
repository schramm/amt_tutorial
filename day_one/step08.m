
minFreq = 100;
maxFreq = 8000;
bins = 12;
fs = 44100;

% L = size(audio_frames,2); % num audio frames 
% s = zeros([N,L]);
% cplx = zeros([N,L]);
s=[];
for i=1:size(frames,2)
      frame = frames(:,i);      
      cq = slowCQ(frame', minFreq, maxFreq, bins, fs);
      s(:,i) = (abs(cq).^2);       
end


%% now it is very easy aligning templates!
% just performs a shift along the frequency axis
figure; 
subplot(2,1,1);
plot(s(:,500)); hold on
plot(s(:,1000),'g'); hold on
ylabel('Magnitude');
xlabel('Freq (cqt resolution -- see num of bins per octave)'); % the output from MATLAB is one period from 0 to pi

subplot(2,1,2);
plot(s(:,500)); hold on
s2=circshift(s(:,1000),[-6,0]);
plot(s2, 'g');
ylabel('Magnitude');
xlabel('Freq (cqt resolution -- see num of bins per octave)'); % the output from MATLAB is one period from 0 to pi

