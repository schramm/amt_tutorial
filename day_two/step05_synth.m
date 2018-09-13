

Fs = 44100;
s = size(guitar_p2);
N = s(2)*62; % hop size is 62
synth_sine = zeros([s(1),N]);
t = [0:N-1]/Fs;

for i=1:s(1);
    midi_note = 59+i;
    freq = 440*2^((midi_note-69)/12); %% Frequency in Hz
    x = sin(2*pi * t * freq);
    synth_sine(i,:) = x;
end

piano_b = imresize(piano_p2, size(synth_sine));
synth_piano = sum(piano_b.*synth_sine);
synth_piano = synth_piano./max(synth_piano);

flute_b = imresize(flute_p2, size(synth_sine));
synth_flute = sum(flute_b.*synth_sine);
synth_flute = synth_flute./max(synth_flute);

guitar_b = imresize(guitar_p2, size(synth_sine));
synth_guitar = sum(guitar_b.*synth_sine);
synth_guitar = synth_guitar./max(synth_guitar);

violin_b = imresize(violin_p2, size(synth_sine));
synth_violin = sum(violin_b.*synth_sine);
synth_violin = synth_violin./max(synth_violin);


pp = audioplayer(synth_piano, 44100);
pf = audioplayer(synth_flute, 44100);
pg = audioplayer(synth_guitar, 44100);
pv = audioplayer(synth_violin, 44100);

synth_all = (synth_piano+synth_flute+synth_guitar+synth_violin)/4;
pall = audioplayer(synth_all, 44100);


