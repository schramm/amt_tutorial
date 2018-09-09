function [sw,w] = windowed_signal(signal)

%% window function (avoiding boundaries artefacts)
w = oBlackmanharris(length(signal)); 
sw = signal.*w;
