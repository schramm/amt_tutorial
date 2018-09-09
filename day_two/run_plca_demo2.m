
%% number of templates per note
k = 2;

if 1
    
    filename_flute = 'audio_samples/scale_flute.wav';
    [intCQT_flute, hop_size_samples] = computeCQT(filename_flute);
    [tpl_flute, notes_flute] = extractTemplates(intCQT_flute); % using median
    
    filename_violin = 'audio_samples/scale_violin.wav';
    [intCQT_violin, hop_size_samples] = computeCQT(filename_violin);
    [tpl_violin, notes_violin] = extractTemplates(intCQT_violin); % using median
    
    filename_guitar = 'audio_samples/scale_guitar.wav';
    [intCQT_guitar, hop_size_samples] = computeCQT(filename_guitar);
    [tpl_guitar, notes_guitar] = extractTemplates(intCQT_guitar); % using median
    
    filename_piano = 'audio_samples/scale_piano.wav';
    [intCQT_piano, hop_size_samples] = computeCQT(filename_piano);
    [tpl_piano, notes_piano] = extractTemplates(intCQT_piano); % using median
    
end


if 1
    [tpl_piano2, act_piano2] = extractKtemplatesPerNote(notes_piano,k);
    [tpl_flute2, act_flute2] = extractKtemplatesPerNote(notes_flute,k);
    [tpl_guitar2, act_guitar2] = extractKtemplatesPerNote(notes_guitar,k);
    [tpl_violin2, act_violin2] = extractKtemplatesPerNote(notes_violin,k);
    
end

ww2=[];
ww2(:,:,1,1:k) = tpl_flute2;
ww2(:,:,1,k+1:2*k) = tpl_piano2;
ww2(:,:,1,2*k+1:3*k) = tpl_violin2;
ww2(:,:,1,3*k+1:4*k) = tpl_guitar2;


close all;

filename_mix01 = 'audio_samples/mix02.wav';
[intCQT_mix01, hop_size_samples] = computeCQT(filename_mix01);

[ww,pp,rr,xa] = plca3d(ww2, intCQT_mix01, 26, k*4, 30);

%%%%%

p_threshold = 30;
flute_p =  squeeze(sum(rr(1:k,:,:),1)).*pp;
piano_p =  squeeze(sum(rr(k+1:2*k,:,:),1)).*pp;
violin_p =  squeeze(sum(rr(2*k+1:3*k,:,:),1)).*pp;
guitar_p =  squeeze(sum(rr(3*k+1:4*k,:,:),1)).*pp;

if 1
    filter_span = 100;
    flute_p  = medfilt1(flute_p, filter_span, [], 2);
    piano_p  = medfilt1(piano_p, filter_span, [], 2);
    violin_p  = medfilt1(violin_p, filter_span, [], 2);
    guitar_p  = medfilt1(guitar_p, filter_span, [], 2);
end

figure;
subplot(2,2,1);
imagesc(flute_p); colorbar; axis xy; shg

subplot(2,2,2);
imagesc(piano_p); colorbar;  axis xy; shg

subplot(2,2,3);
imagesc(violin_p); colorbar; axis xy; shg

subplot(2,2,4);
imagesc(guitar_p); colorbar;  axis xy; shg

% binarization
if 1
    flute_p2 = flute_p > p_threshold;
    piano_p2 = piano_p > p_threshold;
    violin_p2 = violin_p > p_threshold;
    guitar_p2 = guitar_p > p_threshold;
end


figure;
subplot(2,2,1);
energScale=30;
imagesc(flute_p+flute_p2*energScale); colorbar; axis xy; shg
title('flute');

subplot(2,2,2);
imagesc(piano_p+piano_p2*energScale); colorbar;  axis xy; shg
title('piano');

subplot(2,2,3);
imagesc(violin_p+violin_p2*energScale); colorbar; axis xy; shg
title('violin');

subplot(2,2,4);
imagesc(guitar_p+guitar_p2*energScale); colorbar;  axis xy; shg
title('guitar');
