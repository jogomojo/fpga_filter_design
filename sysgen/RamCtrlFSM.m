% Copyright (c) 2021 Joshua Goldsmith
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
% 1.    Redistributions of source code must retain the above copyright  
%       notice, this list of conditions and the following disclaimer.
% 
% 2.    Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in the 
%       documentation and/or other materials provided with the 
%       distribution.
% 
% 3.    Neither the name of the copyright holder nor the names of its 
%       contributors may be used to endorse or promote products derived 
%       from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
% TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER 
% OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function [addr,valid_out] = RamCtrlFSM(rst,valid_in,M,NFFT)
    
    wlength = 10; % ceil(log2(NFFT))

    % states
    IDLE  = 0;
    WAIT  = 1;
    ADDR = 2;
    
    persistent state,
    state = xl_state(IDLE, {xlUnsigned, 2, 0});
    
    persistent cnt,
    cnt = xl_state(0, {xlUnsigned, wlength+1, 0});
    
    switch state
        
        case IDLE
            addr = xfix({xlUnsigned, wlength, 0, xlTruncate, xlWrap}, 0);
            valid_out = false;
            cnt = NFFT-M;
            
            if rst == true
                state = IDLE;
            elseif valid_in == true && rst == false
                state = WAIT;
            end
            
        case WAIT
            addr = xfix({xlUnsigned, wlength, 0, xlTruncate, xlWrap}, 0);
            valid_out = false;
            cnt = NFFT-M;
            
            if rst == true
                state = IDLE;
            elseif valid_in == true && rst == false
                state = WAIT;
            elseif valid_in == false && rst == false
                state = ADDR;
            else
                state = WAIT;
            end
            
        case ADDR
            
            if rst == true
                state = IDLE;
                addr = xfix({xlUnsigned, wlength, 0, xlTruncate, xlWrap}, 0);
                valid_out = false;
            elseif cnt < NFFT && rst == false
                addr = xfix({xlUnsigned, wlength, 0, xlTruncate, xlWrap}, cnt);
                valid_out = true;
                cnt = cnt + 1;
                state = ADDR;
            else
                addr = xfix({xlUnsigned, wlength, 0, xlTruncate, xlWrap}, 0);
                valid_out = true;
                state = IDLE;
            end
            
        otherwise
            addr = xfix({xlUnsigned, wlength, 0, xlTruncate, xlWrap}, 0);
            valid_out = false;
            state = IDLE;
            
    end

end

