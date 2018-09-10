function [templates, notes] = step10_extractTemplates(intCQT, hop_size)

%% the CQT output has one frame at each 62 samples
if nargin==2
    frameStep = hop_size; % int samples   
else
    frameStep = 62; % int samples   (if using computeCQT)
end

% synthetic data (wav file) has two pitches per second (quarter notes and 120 BPM)
fs = 44100;
noteDurationSamples = fs/2; %half second
noteDurationInFrames = round(noteDurationSamples/frameStep);

% split the CQT spectrogram into single notes
notes =[];

figure; imagesc(intCQT); axis xy; hold on;
c=1;

templates = [];

for i=noteDurationInFrames:noteDurationInFrames:round(size(intCQT,2)-noteDurationInFrames)
    notes(:,:,c) = intCQT(:,i:i+noteDurationInFrames-1);        
    templates(:,c) =  median(notes(:,:,c),2)';
    stem([i,i],[0, 500], 'r');
    c=c+1;
end

%% %%%%%%%%%%%%%%
% plots
noteNames = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B','C','C#','D','D#','E','F','F#','G','G#','A','A#','B','C','C#','D','D#','E','F','F#','G','G#','A','A#','B','C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
figure; 
for i=1:25;
   subplot(5,5,i);
   imagesc(notes(:,:,i)); axis xy;
   title(noteNames{i});
end
shg;

figure; 
for i=1:25;
   subplot(5,5,i);
   plot(templates(:,i)); axis xy;
   title(noteNames{i});
end
shg;


