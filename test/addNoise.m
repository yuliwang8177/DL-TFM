function dsplN = addNoise(dspl,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Description: add Gaussian noise to a modeled displacement field
%
% Input:
%   dspl: displacement field
%   N: magnitude of the noise
%
% Output: displacement field aster imposing the noise
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S = length(dspl);
stdev = N/sqrt(2); % measured = 0.00765
rng('shuffle');
noise = random('normal',0,stdev,[S,S]);
dsplN(:,:,1) = dspl(:,:,1) + noise;
noise = random('normal',0,stdev,[S,S]);
dsplN(:,:,2) = dspl(:,:,2) + noise;
end
