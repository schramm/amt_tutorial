
%% Discrete Fourier Transform

% get a single frame (you can choose one...)
frame = frames(:,100);

% plot audio signal (window frame)
subplot(2,1,1); 
plot(frame);
ylabel('Amplitude');
xlabel('Time');

% compute DFT (slow = dummy for illustration)
ft= slowFT(frame', 1024);

% plot audio signal (window frame)
subplot(2,1,2); 
plot(abs(ft));
ylabel('Magnitude');
xlabel('Freq'); % the output from MATLAB is one period from 0 to pi




