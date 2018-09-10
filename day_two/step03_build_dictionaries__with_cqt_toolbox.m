
%% number of templates per note
k = 2;

filename_flute = '../audio_samples/scale_flute.wav';
[intCQT_flute, hop_size_samples] = computeCQT(filename_flute);
[tpl_flute, notes_flute] = step10_extractTemplates(abs(intCQT_flute)); % using median

filename_violin = '../audio_samples/scale_violin.wav';
[intCQT_violin, hop_size_samples] = computeCQT(filename_violin);
[tpl_violin, notes_violin] = step10_extractTemplates(abs(intCQT_violin)); % using median

filename_guitar = '../audio_samples/scale_guitar.wav';
[intCQT_guitar, hop_size_samples] = computeCQT(filename_guitar);
[tpl_guitar, notes_guitar] = step10_extractTemplates(abs(intCQT_guitar)); % using median

filename_piano = '../audio_samples/scale_piano.wav';
[intCQT_piano, hop_size_samples] = computeCQT(filename_piano);
[tpl_piano, notes_piano] = step10_extractTemplates(abs(intCQT_piano)); % using median


[tpl_piano2, act_piano2] = extractKtemplatesPerNote(notes_piano,k);
[tpl_flute2, act_flute2] = extractKtemplatesPerNote(notes_flute,k);
[tpl_guitar2, act_guitar2] = extractKtemplatesPerNote(notes_guitar,k);
[tpl_violin2, act_violin2] = extractKtemplatesPerNote(notes_violin,k);


ww2=[];
ww2(:,:,1,1:k) = tpl_flute2;
ww2(:,:,1,k+1:2*k) = tpl_piano2;
ww2(:,:,1,2*k+1:3*k) = tpl_violin2;
ww2(:,:,1,3*k+1:4*k) = tpl_guitar2;


%close all;




