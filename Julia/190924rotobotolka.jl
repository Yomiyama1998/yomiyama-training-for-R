using ODE
using Plots

function f(t, v)
     (x, y) = v
     dx_dt=(a-b*y)x
     dy_dt=(c*y-d)y
    
    [dx_dt ; dy_dt]
end;

a=2.0
b=3.0
c=1.0
d=2.0

v_in = [0.4; 0.4];

time = 0.0:0.1:1;

t,v=ode45(f,v_in,time)

x = map(v -> v[1], v);
y = map(v -> v[2], v);

plot(t,y,seriestype=:line,label="y")
plot!(t,x,seriestype=:line,label="x")

plot(t,y,seriestype=:scatter,label="y")
plot!(t,x,seriestype=:scatter,label="x")

x_th=map(x -> 1000*exp(x)*(cos(x)+sin(x)), t);
y_th=map(x -> 1000*exp(x)*(cos(x)-sin(x)), t);

plot!(t,y_th,label="y_th")
plot!(t,x_th,label="x_th")