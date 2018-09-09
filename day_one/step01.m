addpath('../utils');
addpath('../utils/CQT');
addpath('dummy');



% input wave file name
filename = 'scale_flute.wav';
% read the entire file to variable x
[x,fs] = audioread(filename);
% show/plot the content
figure; plot(x);
