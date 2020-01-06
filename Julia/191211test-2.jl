#191211test-2.jl

for arg in ARGS
    println(arg)
end

function tes(a,b)
    return a+b
end
x=parse(Int,ARGS[1])
y=parse(Int,ARGS[2])
c=tes(x,y)
println(c)