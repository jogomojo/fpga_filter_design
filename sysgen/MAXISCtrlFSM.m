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

function [m_axis_reload_tdata, m_axis_reload_tvalid, m_axis_reload_tlast, m_axis_config_tdata, m_axis_config_tvalid] = MAXISCtrlFSM(M, rst, data,valid)

    nbits = 7; % ceil(log2(N))
    wlength = 24; % == output_wlength
    flength = wlength-1;

    % states
    IDLE = 0;
    VALID = 1;
    LAST = 2;
    LOAD = 3;
    WAIT = 4;

    persistent state,
    state = xl_state(IDLE, {xlUnsigned, 3, 0});

    persistent cnt,
    cnt = xl_state(0, {xlUnsigned, nbits, 0});

    switch state

        case IDLE
            m_axis_reload_tdata = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, 0);
            m_axis_reload_tvalid = xfix({xlBoolean}, false);
            m_axis_reload_tlast = xfix({xlBoolean}, false);
            m_axis_config_tdata = xfix({xlUnsigned, 8, 0, xlTruncate, xlWrap}, 0);
            m_axis_config_tvalid = xfix({xlBoolean}, false);
            cnt = 0;

            if rst == true
                state = IDLE;
            elseif valid == true && rst == false
                state = VALID;
            else
                state = IDLE;
            end

        case VALID
            m_axis_reload_tdata = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, data);
            m_axis_reload_tvalid = xfix({xlBoolean}, true);
            m_axis_reload_tlast = xfix({xlBoolean}, false);
            m_axis_config_tdata = xfix({xlUnsigned, 8, 0, xlTruncate, xlWrap}, 0);
            m_axis_config_tvalid = xfix({xlBoolean}, false);
            cnt = cnt + 1;

            if rst == true
                state = IDLE;
            elseif cnt < M && valid == true && rst == false
                state = VALID;
            elseif cnt == M && valid == true && rst == false
                state = LAST;
            else
                state = IDLE;
            end

        case LAST
            m_axis_reload_tdata = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, data);
            m_axis_reload_tvalid = xfix({xlBoolean}, true);
            m_axis_reload_tlast = xfix({xlBoolean}, true);
            m_axis_config_tdata = xfix({xlUnsigned, 8, 0, xlTruncate, xlWrap}, 0);
            m_axis_config_tvalid = xfix({xlBoolean}, false);
            cnt = 0;
            state = WAIT;
            
        case WAIT
            m_axis_reload_tdata = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, 0);
            m_axis_reload_tvalid = xfix({xlBoolean}, false);
            m_axis_reload_tlast = xfix({xlBoolean}, false);
            m_axis_config_tdata = xfix({xlUnsigned, 8, 0, xlTruncate, xlWrap}, 0);
            m_axis_config_tvalid = xfix({xlBoolean}, false);
            cnt = cnt + 1;
            
            if rst == true
                state = IDLE;
            elseif cnt < 2
                state = WAIT;
            else
                state = LOAD;
            end
            
        case LOAD
            m_axis_reload_tdata = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, 0);
            m_axis_reload_tvalid = xfix({xlBoolean}, false);
            m_axis_reload_tlast = xfix({xlBoolean}, false);
            m_axis_config_tdata = xfix({xlUnsigned, 8, 0, xlTruncate, xlWrap}, 0);
            m_axis_config_tvalid = xfix({xlBoolean}, true);
            cnt = 0;
            state = IDLE;

        otherwise
            m_axis_reload_tdata = xfix({xlSigned, wlength, flength, xlTruncate, xlWrap}, 0);
            m_axis_reload_tvalid = xfix({xlBoolean}, false);
            m_axis_reload_tlast = xfix({xlBoolean}, 0);
            m_axis_config_tdata = xfix({xlUnsigned, 8, 0, xlTruncate, xlWrap}, 0);
            m_axis_config_tvalid = xfix({xlBoolean}, false);
            state = IDLE;
            
    end     
end