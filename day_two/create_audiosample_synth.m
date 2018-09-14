## Copyright (C) 2018 Rodrigo Schramm
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} create_audiosample_synth (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Rodrigo Schramm <schramm@schramm-MacBookPro>
## Created: 2018-09-14

function [synth, p] = create_audiosample_synth (sample_file, activations)


s = size(activations); 
N = s(2)*62; % hop size is 62
[spl, fs2] = audioread(sample_file);

range_semitons = s(1);
ncopies = ceil(N*ceil(2^(range_semitons/12)) /length(spl));
spl_r = repmat(spl, [ncopies, 1]);
spl_r = spl_r(1:N*ceil(2^(range_semitons/12))); % 4 give us a pitch range with two octaves


synth_sampler = zeros([s(1),N]);
for i=1:range_semitons;
    n_semitons = i;
    c = imresize(spl_r(1:round(N*2^(n_semitons/12))), [N, 1]);
    synth_sampler(i,:) = c';
end



synth = imresize(activations, size(synth_sampler));
synth = sum(synth.*synth_sampler);
synth = synth./max(synth);

p = audioplayer(synth, fs2);
