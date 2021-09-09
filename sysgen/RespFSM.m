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

function [sof, rout, valid] = RespFSM(trig, rst, numHighs, numLows)

    wlength = 14;
    flength = wlength-1;
    r = 0.9531;

    IDLE  = 0;
    SoF   = 1;
    HIGHS = 2;
    LOWS  = 3;
    WAIT  = 4;
    
    persistent state,
    state = xl_state(IDLE, {xlUnsigned, 3, 0});
    
    persistent cnt,
    cnt = xl_state(0, {xlUnsigned, 11, 0});
    
    persistent status,
    status = xl_state(0, {xlUnsigned, 1, 0});
    
    switch state
        
        case IDLE
            sof = 0;
            rout = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, 0);
            valid = 0;
            cnt = 0;
            status = 0;
            
            if rst == true
                state = IDLE;
            elseif trig == true && rst == false
                state = SoF;
            else
                state = IDLE;
            end
            
        case WAIT % this case waits until trigger has reset before going back to idle
            sof = 0;
            rout = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, 0);
            valid = 0;
            cnt = 0;
            status = 0;
            
            if trig == true
                state = WAIT;
            else
                state = IDLE;
            end
            
        case SoF
            cnt = 0;
            sof = 1;
            rout = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, r);
            valid = 1;
           
            if rst == true
                state = IDLE;
            else
                state = HIGHS;
            end
            
        case HIGHS
            cnt = cnt + 1;
            sof = 0;
            rout = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, r);
            valid = 1;
            
            if rst == true
                state = IDLE;
            elseif cnt < numHighs-1 && rst == false
                state = HIGHS;
            elseif cnt >= numHighs-1 && status == 0 && rst == false
                cnt = 0;
                state = LOWS;
            elseif trig == true
                state = WAIT;
            else
                state = IDLE;
            end
            
        case LOWS
            cnt = cnt + 1;
            sof = 0;
            rout = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, 0);
            valid = 1;
            
            if rst == true
                state = IDLE;
            elseif cnt < numLows && rst == false
                state = LOWS;
            else
                cnt = 0;
                status = 1;
                state = HIGHS;
            end
            
        otherwise
            sof = 0;
            rout = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, 0);
            valid = 0;
            state = WAIT;
            
    end
    
end
                