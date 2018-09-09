
% building spectrograms

 s1 = get_fft_spectrogram(frames, 128); 
 s2 = get_fft_spectrogram(frames, 256);
 s3 = get_fft_spectrogram(frames, 512);
 s4 = get_fft_spectrogram(frames, 1024);
 s5 = get_fft_spectrogram(frames, 2048);
 s6 = get_fft_spectrogram(frames, 8192);
 s7 = get_fft_spectrogram(frames, 32768);