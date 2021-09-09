x = win_out;
y = x(end-1:-1:1);  % mirror the half impulse response
z = [x;y];          % join responses

fvtool(z,1)         % display filter frequency response