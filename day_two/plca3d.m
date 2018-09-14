function [ww,pp,zz,xa] = plca3d(ww, x, K, R, iter)
%
% Basic transcription based on PLCA model
%
% Inputs:
%  x     input distribution
%  K     number of pitches
%  F     number of bins per semitone
%  R     nmuber of instruments
%
%  iter  number of EM iterations [default = 35]
%
%  pa    pitch range (TODO)
%  ww    initial value of ww (basis 3-D tensor = dictionary template)

%
% Outputs:
%  ww   spectral bases
%  pp   pitch detection
%  xa  approximation of input
%
% Original script from Emmanouil Benetos 2015
% (https://code.soundsoftware.ac.uk/projects/amt_plca_5d)
% Modifications by Rodrigo Schramm 2017/2018

%rng(666);

pp5=[];


% Get sizes
[M,N] = size(x);
sumx = sum(x);

% Default training iterations
if ~exist( 'iter')
    iter = 30;
end

% Initialize
%% ----------------------------------------
if ~exist( 'ww') || isempty(ww)
    error('Please, define the input dictionary ww.');
end


%normalize spectral templates
% // TODO -- replace for loops below (this can be done previously offline)
for k=1:K % num of pitches
    for r=1:R  % num of freq bins (shift)
        ww(:,k,r) = ww(:,k,r) ./ (sum(ww(:,k,r))+eps);
    end
end


%% ----------------------------------------
% rr = instrument source contribution
if ~exist( 'rr') || isempty(zz)
    zz = ones(R, K, N);
end 

for k=1:K
    for n=1:N
        zz(:,k,n) = zz(:,k,n) ./ (sum(zz(:,k,n))+eps);
    end
end


%% ----------------------------------------
% pp = pitch activation
if ~exist( 'pp') || isempty(pp)
    pp = rand(K, N);
end 
n=1:N;
pp(:,n) = repmat(sumx(n),K,1) .* (pp(:,n) ./ (repmat( sum( pp(:,n), 1), K, 1)+eps));


%% ----------------------------------------
% Initialize update parameters
w_reshaped = reshape(ww,[M K*R]);  % freqBins x (pitch x instrument) 
sumx = diag(sumx);  %P(t)

% Iterate
fprintf('iteration: ');
for it = 1:iter
    fprintf(' %d' , it);
    %% E-step    
    p_big  = permute(repmat(pp, [1 1 R]), [2 1 3]); % [t,p,z]            
    z_big  = permute(repmat(zz, [1 1 1]), [3 2 1]); % [t,p,z] (repmat is not needed in this case)
    
    %% Hell starts here.
    ppzz  = p_big.*z_big;        
    ppzz_reshaped = reshape(ppzz,[N K*R]);
    xa = w_reshaped * ppzz_reshaped'; % dot product (Equation 4 from slides) (this is only the denominator of Eq 5)    
    D = x ./ (xa+eps);    % denominator
    %% M-step (update pp and rr)
    WD = D' * w_reshaped; % don' forget to multiplay by the numerator: first (w|z,p) (the dot product already takes the sum over w)!!! 
    PPZZ = reshape(ppzz_reshaped .* WD,[N K R]);  % also mutiply by  P(z|p) and P(p)     
    %% Hell ends here.
    
    %% marginalizations
    % instrument source    
    zz = permute(PPZZ, [3 2 1]);  % marginalization (it is already done over \omega)
    % pitch activation
    pp = permute(squeeze(sum(PPZZ,3)), [2 1]);    %% marginalization
        
    pp = medfilt1(pp, 20, [], 2);    
    
    zz = zz.^1.05; % sparsity
      
    %% normalization
    z_resh = reshape(zz,[R K*N]);
    z_resh = (z_resh ./ (repmat(sum(z_resh,1),[R 1])+eps));
    zz = reshape(z_resh,[R K N]);        
    
    n=1:N;    
    pp(:,n) = pp(:,n) ./ (repmat( sum( pp(:,n), 1), K, 1)+eps) * sumx;
    
    %% sparsity    
    %pp = pp.^1.1; % sparsity
    
    
    subplot(1,3,1); imagesc(x); axis xy;
    subplot(1,3,2); imagesc(xa); axis xy;
    subplot(1,3,3); imagesc(pp); axis xy; title(it);
    shg; pause(.1);
end



