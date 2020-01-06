using PyCall
using PyPlot
using NLsolve

#被食-捕食系

function hisyoku(dt,a,b,c,d,x,y)
    x_new=x+(a-b*y)*x*dt#被食者
    y_new=y+(c*x-d)*y*dt#捕食者
    x,y=x_new,y_new
    return x,y
end

dt=0.001
a=2.0
b=3.0
c=1.0
d=2.0

x_0=y_0=0.4

x,y=x_0,y_0

xy_sq=[x_0,y_0]

for i in 1:500
    x,y=hisyoku(dt,a,b,c,d,x,y)
    xy_sq=hcat(xy_sq,[x,y])
end

#競争系
function kyousou(a,b,c,d,e,f,x,y)
    x_new=1+(a-b*x-c*y)*x*dt
    y_new=(d-e*x-f*y)*y
    x,y=x_new,y_new
    return x,y
end

#共生系

function kyousei(a,b,c,d,e,f,x,y)
    x_new=(a-b*x-c*y)*x
    y_new=(d+e*x-f*y)*y
    x,y=x_new,y_new
    return x,y
end

