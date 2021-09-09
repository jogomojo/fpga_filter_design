%% System Setup

fc = 0.33;              % percentage of fs
NFFT = 1024;            % FFT length
N = 101;                % Filter length

wlength = 14;           % RespFSM output wordlength
flength = wlength-1;    % RespFSM output fractional bits

output_wlength = 24;    % Output wordlength

h_win = blackman(N);    % Window type