
%% a pipeline example


%% step01
% input wave file name
filename = '../audio_samples/scale_flute.wav';
% read the entire file to variable x
[x,fs] = audioread(filename);
% show/plot the content
figure; plot(x);

%% step02
% window analysis size
win_size = 2048;
% hop (step) size 
hop_size = 256;
% split entire audio signal into several frames 
[frames, idx] = get_audio_frames(x, win_size, hop_size);
%size(frames),

%% step03~05
[wf] = windowed_audio_frames(frames);

%% step06
[s, cplx ] = get_fft_spectrogram(wf); 

%% 
x2 = from_spectrogram_to_audio(cplx, idx); % magnitude and phase
x3 = from_spectrogram_to_audio(s, idx); %only magnitude


x2 = x2./max(x2);
x3 = x3./max(x3);
x = x./max(x);

figure; hold on;
plot(x(30000:40000), 'k');
plot(x2(30000:40000), 'r--');
plot(x3(30000:40000), 'g--');
