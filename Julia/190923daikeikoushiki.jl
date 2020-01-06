using PyCall
using PyPlot
using NLsolve

function daikei(f,N)
    dk = 2π/(N-1)
    fsum = 0
    for i=1:N
        k = (i-1)*dk - π
        fsum += f(k)
    end
    fsum /= N
    return fsum
end

f(x) = sin(x) + x^2
N = 400
fsum = daikei(f,N)
exact = ((π)^3/3 -(-π)^3/3)/(2π)
println("daikei $fsum, exact $exact")


using QuadGK
f(x) = sin(x) + x^2
fsum2 = QuadGk(f,-π,π)./(2π)
println("quadgk $fsum2, exact $exact")