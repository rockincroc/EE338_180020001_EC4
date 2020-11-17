%Butterworth Analog LPF parameters
Wc = 1.073;              %cut-off frequency
N = 7;                  %order 

%poles of Butterworth polynomial of degree 7 in the open CLHP 
    p1 = -0.96674 - 0.465557i;
    p2 = -0.96674 + 0.465557i;
    p3 = -0.669005 - 0.838905i;
    p4 = -0.669005 + 0.838905i;
    p5 = -0.238765 - 1.0461i;
    p6 = -0.238765 + 1.0461i;
    p7 = -1.07300;

%Band Edge specifications
fs1 = 63.7;
fp1 = 67.7;
fp2 = 87.7;
fs2 = 91.7;

%Transformed Band Edge specs using Bilinear Transformation
f_samp = 330;         
wp1 = tan(fp1/f_samp*pi);
ws1 = tan(fs1/f_samp*pi); 
ws2 = tan(fs2/f_samp*pi);
wp2 = tan(fp2/f_samp*pi);

%Parameters for Bandstop Transformation
W0 = sqrt(wp1*wp2);
B = wp2-wp1;

[num,den] = zp2tf([],[p1 p2 p3 p4 p5 p6 p7],Wc^N);   %TF with poles p1-p7 and numerator Wc^N and no zeroes
                                                        %numerator chosen to make the DC Gain = 1

%Evaluating Frequency Response of Final Filter
syms s z;
analog_lpf(s) = poly2sym(num,s)/poly2sym(den,s);        %analog LPF Transfer Function
analog_bpf(s) = analog_lpf((s*s + W0*W0)/(B*s));        %bandstop transformation
discrete_bpf(z) = analog_bpf((z-1)/(z+1));              %bilinear transformation

%coeffs of analog bpf
[ns, ds] = numden(analog_bpf(s));                   %numerical simplification to collect coeffs
ns = sym2poly(expand(ns));                          
ds = sym2poly(expand(ds));                          %collect coeffs into matrix form
k = ds(1);    
ds = ds/k
ns = ns/k

%coeffs of discrete bpf
[nz, dz] = numden(discrete_bpf(z));                     %numerical simplification to collect coeffs                    
nz = sym2poly(expand(nz));
dz = sym2poly(expand(dz));                              %coeffs to matrix form
k = dz(1);                                              %normalisation factor
dz = dz/k
nz = nz/k
fvtool(nz,dz);                                           %frequency response

%magnitude plot (not in log scale) 
[H,f] = freqz(nz,dz,1024*1024, 330e3);
plot(f,abs(H))
grid