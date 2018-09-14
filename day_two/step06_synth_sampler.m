

Fs = 44100;
s = size(guitar_p2);
N = s(2)*62; % hop size is 62

%[spl, fs2] = audioread('../audio_samples/s_cello.wav');
%[spl, fs2] = audioread('../audio_samples/s_organ.wav');
[spl, fs2] = audioread('../audio_samples/s_flute.wav');
%[spl, fs2] = audioread('../audio_samples/s_ooh.wav');
%spl=spl(Fs:end);


range_semitons = s(1);
ncopies = ceil(N*ceil(2^(range_semitons/12)) /length(spl));
spl_r = repmat(spl, [ncopies, 1]);
spl_r = spl_r(1:N*ceil(2^(range_semitons/12))); % 4 give us a pitch range with two octaves


synth_sampler = zeros([s(1),N]);
for i=1:range_semitons;
    n_semitons = i;
    c = imresize(spl_r(1:round(N*2^(n_semitons/12))), [N, 1]);
    synth_sampler(i,:) = c';
end

%% time idx
t = [0:N-1]/Fs;


piano_b = imresize(piano_p2, size(synth_sampler));
synth_piano = sum(piano_b.*synth_sampler);
synth_piano = synth_piano./max(synth_piano);

flute_b = imresize(flute_p2, size(synth_sampler));
synth_flute = sum(flute_b.*synth_sampler);
synth_flute = synth_flute./max(synth_flute);

guitar_b = imresize(guitar_p2, size(synth_sampler));
synth_guitar = sum(guitar_b.*synth_sampler);
synth_guitar = synth_guitar./max(synth_guitar);

violin_b = imresize(violin_p2, size(synth_sampler));
synth_violin = sum(violin_b.*synth_sampler);
synth_violin = synth_violin./max(synth_violin);


pp = audioplayer(synth_piano, 44100);
pf = audioplayer(synth_flute, 44100);
pg = audioplayer(synth_guitar, 44100);
pv = audioplayer(synth_violin, 44100);

synth_all = (synth_piano+synth_flute+synth_guitar+synth_violin)/4;
pall = audioplayer(synth_all, 44100);

%play(pp);
%play(pf);
%play(pg);
%play(pv);
%play(pall);
