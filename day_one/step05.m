

%% PADDING
freq = 367; %% Frequency in Hz
N = 4096;
Ns = N/8; % simulating smaller window
Fs = 8000;
t = [0:Ns-1]/Fs;
x = sin(2*pi * t * freq);
w = hanning(length(x))';
x1 = [x, zeros([1, 8*Ns])]; % padding signal with zeros
x2 = [x.*w, zeros([1, 8*Ns])]; % padding signal with zeros (but signal is windowed)

X = fft(x1,N);
X2 = abs(X/N); %% double check if fft does the avg.
f = (0:length(X)-1)*Fs/length(X);
subplot(2,1,1); 
plot(f(1:end/2),X2(1:end/2))
ylabel('Magnitude');
xlabel('Freq Hz'); 


Xw = fft(x2,N);
X2w = abs(Xw/N); %% double check if fft does the avg.
subplot(2,1,2); 
plot(f(1:end/2),X2w(1:end/2))
ylabel('Magnitude');
xlabel('Freq Hz'); 

