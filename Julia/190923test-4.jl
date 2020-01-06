using PyCall
using PyPlot
using NLsolve

α=1.85
β=0.0732
δ=1.81
c=80.46
p=1.0

function EBOLA(T1,T2,I,V)
    T1_new=(α*T2*I-β*T1*V)
    T2_new=-α*T2*I
    I_new=β*T1*V-δ*I
    V_new=p*I-c*V
    T1,T2,I,V = T1_new, T2_new,I_new,V_new
    return T1,T2,I,V
end

V_0=5.43
T1_0=100000
T2_0=100000
I_0=0.001

EBOLA(T1_0,T2_0,I_0,V_0)