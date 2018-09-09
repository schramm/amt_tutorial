
%%%%%%%%%%%%%
% DFT matrix
% KERNEL => exp((-i*2*pi*k*n)/N);  

frame  = frames(:,200)';
N = length(frame);

D =[]; 
for n=0:N-1;
    for k=0:N-1; 
        D(k+1,n+1) =exp((-1i*2*pi*k*n)/N); 
    end;
end;
%D =D/sqrt(N);

% iFFT =>  conj(D) (conjugate). In this case, conj is D transposed => D'
X = D*frame(1:N)';
frame2 = real(D'*X)/N;
plot(frame(1:N)); hold on;
plot(real(frame2(1:N)), 'r--');





