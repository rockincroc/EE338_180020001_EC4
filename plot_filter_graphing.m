hold on
plot(f,angle(H))
%yline(1.0, '-', '1.0')
%yline(0.85, '-', '0.85')
%yline(0.15, '-', '0.15')
xline(fp1*1e0, '-', string(fp1) + 'kHz')
xline(fp2*1e0, '-', string(fp2) + 'kHz')
xline(fs1*1e0, '-', string(fs1) + 'kHz')
xline(fs2*1e0, '-', string(fs2) + 'kHz')
title("Phase Response of the IIR Bandpass Filter")
xlabel('Frequency in Hz')
ylabel('Phase in radians')
grid
hold off