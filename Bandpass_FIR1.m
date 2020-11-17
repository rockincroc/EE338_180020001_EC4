f_samp = 330e3;

%Band Edges
fs1 = 63.7e3;
fp1 = 67.7e3;
fp2 = 87.7e3;
fs2 = 91.7e3;

Wc1 = fp1*2*pi/f_samp;
Wc2  = fp2*2*pi/f_samp;

%Kaiser parameters
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end

N_min = ceil((A-7.95) / (2.285*0.0761598));           %empirical formula for N_min

%Window length for Kaiser Window
n=N_min+18

%Ideal bandpass impulse response of length "n"
bp_ideal = ideal_lp(1.71,n) - ideal_lp(1.245,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandPass = bp_ideal .* kaiser_win;
fvtool(FIR_BandPass);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandPass,1,1024, f_samp);
plot(f,abs(H));
grid;