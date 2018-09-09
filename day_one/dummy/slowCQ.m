

%And here is the direct implementation of the constant Q transform.
function cq= slowCQ(x, minFreq, maxFreq, bins, fs)
% x => input signal (audio frame)
% minFreq => mininum freq in Hz
% maxFreq => maximum freq in Hz
% bins => freq bins per octave
% fs => samplerate

Q= 1/(2^(1/bins)-1);  % frequency step (bin increment ratio)

s = length(x);

%num_octaves = log2(maxFreq/minFreq)
res = ceil(bins*log2(maxFreq/minFreq));

for k=1:res
    N= round(Q*fs/(minFreq*2^((k-1)/bins)));
    if s < N;
        a = hamming(s)';
        x2 = x.*a;        
        x2 = [x2, zeros(1,max(0,N-s))];    
    else
        a = hamming(N)';
        x2 = x(1:N).*a;
    end %                           v
    cq(k)= x2(1:N) * (exp( -2*pi*1i*Q*(0:N-1)'/N)) / N;
end


