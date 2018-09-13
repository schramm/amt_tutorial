addpath('../utils');
addpath('../day_one');

%% number of templates per note
k = 2;

hop_size = 128;
win_size = 4096;

filename_flute = '../audio_samples/scale_flute.wav';
[x,fs] = audioread(filename_flute);
%p = audioplayer(x,fs); play(p);
%%
cqt_kernel = sparseKernel(27, fs/3, 60, fs);
%%
disp('Processing flute wav.');
frames = get_audio_frames(x, win_size, hop_size);
%[wf] = windowed_audio_frames(frames);
%[intCQT_flute, hop_size_samples] = computeCQT(filename_flute);
%intCQT_flute = get_cqt_spectrogram(wf, cqt_kernel);
intCQT_flute = get_cqt_spectrogram(frames, cqt_kernel);
[tpl_flute, notes_flute] = step10_extractTemplates(abs(intCQT_flute), hop_size); % using median

filename_violin = '../audio_samples/scale_violin.wav';
%[intCQT_violin, hop_size_samples] = computeCQT(filename_violin);
disp('Processing violin wav.');
[x,fs] = audioread(filename_violin);
frames = get_audio_frames(x, win_size, hop_size);
%[wf] = windowed_audio_frames(frames);
%intCQT_violin = get_cqt_spectrogram(wf, cqt_kernel);
intCQT_violin = get_cqt_spectrogram(frames, cqt_kernel);
[tpl_violin, notes_violin] = step10_extractTemplates(abs(intCQT_violin),hop_size); % using median

filename_guitar = '../audio_samples/scale_guitar.wav';
%[intCQT_guitar, hop_size_samples] = computeCQT(filename_guitar);
disp('Processing guitar wav.');
[x,fs] = audioread(filename_guitar);
frames = get_audio_frames(x, win_size, hop_size);
%[wf] = windowed_audio_frames(frames);
%intCQT_guitar = get_cqt_spectrogram(wf, cqt_kernel);
intCQT_guitar = get_cqt_spectrogram(frames, cqt_kernel);
[tpl_guitar, notes_guitar] = step10_extractTemplates(abs(intCQT_guitar),hop_size); % using median

filename_piano = '../audio_samples/scale_piano.wav';
%[intCQT_piano, hop_size_samples] = computeCQT(filename_piano);
disp('Processing piano wav.');
[x,fs] = audioread(filename_piano);
frames = get_audio_frames(x, win_size, hop_size);
%[wf] = windowed_audio_frames(frames);
%intCQT_piano = get_cqt_spectrogram(wf, cqt_kernel);
intCQT_piano = get_cqt_spectrogram(frames, cqt_kernel);
[tpl_piano, notes_piano] = step10_extractTemplates(abs(intCQT_piano),hop_size); % using median

disp('Extracting templates for piano.');
[tpl_piano2, act_piano2] = extractKtemplatesPerNote(notes_piano,k);
disp('Extracting templates for flute.');
[tpl_flute2, act_flute2] = extractKtemplatesPerNote(notes_flute,k);
disp('Extracting templates for guitar.');
[tpl_guitar2, act_guitar2] = extractKtemplatesPerNote(notes_guitar,k);
disp('Extracting templates for violin.');
[tpl_violin2, act_violin2] = extractKtemplatesPerNote(notes_violin,k);


ww2=[];
ww2(:,:,1,1:k) = tpl_flute2;
ww2(:,:,1,k+1:2*k) = tpl_piano2;
ww2(:,:,1,2*k+1:3*k) = tpl_violin2;
ww2(:,:,1,3*k+1:4*k) = tpl_guitar2;

%close all;




