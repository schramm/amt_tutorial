    
filename_piano = '../audio_samples/scale_piano.wav';
[intCQT_piano, hop_size_samples] = computeCQT(filename_piano);
[tpl_piano, notes_piano] = step10_extractTemplates(intCQT_piano); % using median
    
k = 2;
[tpl_piano2, act_piano2] = extractKtemplatesPerNote(notes_piano,k); % using nmf (non-negative matrix factorisation)