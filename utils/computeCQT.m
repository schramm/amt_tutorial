function [intCQT, hop_size_samples] = computeCQT(filename)
% Settings for computing CQT for music signals (by E. Benetos)


bins = 12;

% Load .wav file
[x, fs ] = audioread(filename);
if (size(x,2) == 2) y = mean(x')'; clear('x'); else y=x; clear('x'); end;
if (fs ~= 44100) y = resample(y,44100,fs); end;
y = 0.5*y/max(y);
fs = 44100;


% Compute CQT
%Xcqt = cqt(y,27.5,fs/3,60,fs,'q',1.00,'atomHopFactor',0.3,'thresh',0.0005,'win','hann');
Xcqt = cqt(y,27.5,fs/3,bins,fs,'q',0.80,'atomHopFactor',0.3,'thresh',0.0005,'win','hann'); % old resolution
%Xcqt = cqt(y,27.5,fs/3,60,fs,'q',0.35,'atomHopFactor',0.3,'thresh',0.0005,'win','hann'); % old resolution
absCQT = getCQT(Xcqt,'all','all');
%absCQT = getCQT(Xcqt,'all','all', 'cubic');

% Crop CQT to useful time regions
emptyHops = Xcqt.intParams.firstcenter/Xcqt.intParams.atomHOP;
maxDrop = emptyHops*2^(Xcqt.octaveNr-1)-emptyHops;
droppedSamples = (maxDrop-1)*Xcqt.intParams.atomHOP + Xcqt.intParams.firstcenter;
outputTimeVec = (1:size(absCQT,2))*Xcqt.intParams.atomHOP-Xcqt.intParams.preZeros+droppedSamples;

lowerLim = find(outputTimeVec>0,1);
upperLim = find(outputTimeVec>length(y),1)-1;

%intCQT = absCQT(112:1200,lowerLim:upperLim); % old resolution
%intCQT = absCQT(56:600,lowerLim:upperLim);
intCQT = absCQT(:,lowerLim:upperLim);


audio_length_seconds = length(y)/fs;
%each spectram column give us a hop size of (seconds)
hop_size_seconds = audio_length_seconds / size(intCQT,2);
hop_size_samples = length(y) / size(intCQT,2);


%figure; imagesc(imrotate(abs(intCQT),90));