

filename_mix01 = '../audio_samples/mix02.wav';
[intCQT_mix01, hop_size_samples] = computeCQT(filename_mix01);


%% computer the PLCA (multipitch detection)
[ww,pp,rr,xa] = plca3d(ww2, abs(intCQT_mix01), 26, k*4, 30);




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% plotting / show results

p_threshold = 5;
flute_p =  squeeze(sum(rr(1:k,:,:),1)).*pp;
piano_p =  squeeze(sum(rr(k+1:2*k,:,:),1)).*pp;
violin_p =  squeeze(sum(rr(2*k+1:3*k,:,:),1)).*pp;
guitar_p =  squeeze(sum(rr(3*k+1:4*k,:,:),1)).*pp;

if 1
    filter_span = 70;
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
energScale=1;
imagesc(flute_p2); colorbar; axis xy; shg
title('flute');

subplot(2,2,2);
imagesc(piano_p2); colorbar;  axis xy; shg
title('piano');

subplot(2,2,3);
imagesc(violin_p2); colorbar; axis xy; shg
title('violin');

subplot(2,2,4);
imagesc(guitar_p2); colorbar;  axis xy; shg
title('guitar');
