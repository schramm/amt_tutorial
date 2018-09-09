
%% NO BOUNDARING ISSUES CASE

figure;
%freq = 20;
freq = 367; %% Frequency in Hz
%N = 512; % try bigger window: e.g: 4096 (better freq resolution)
N = 1024;
%N = 4096;
%N = 1024*256; % 
Fs = 16000;
t = [0:N-1]/Fs;
x = sin(2*pi * t * freq);

X = fft(x,N);
X2 = abs(X/N); %% double check if fft does the avg.
f = (0:length(X)-1)*Fs/length(X);


figure;
plot(f(1:end/2),X2(1:end/2))
ylabel('Magnitude');
xlabel('Freq Hz'); 
