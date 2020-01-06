using ODE
using Plots

function f(t, v)
     (x, y) = v
     dx_dt=x + y
     dy_dt=-x + y
    
    [dx_dt ; dy_dt]
end;

v_in = [1000.0; 1000.0];

time = 0.0:0.1:1;

t, v = ode45(f, v_in, time);

x = map(v -> v[1], v);
y = map(v -> v[2], v);

plot(t,y,seriestype=:scatter,label="y")
plot!(t,x,seriestype=:scatter,label="x")

x_th=map(x -> 1000*exp(x)*(cos(x)+sin(x)), t);
y_th=map(x -> 1000*exp(x)*(cos(x)-sin(x)), t);

plot!(t,y_th,label="y_th")
plot!(t,x_th,label="x_th")