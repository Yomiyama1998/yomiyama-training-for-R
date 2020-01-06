#非線形関数の最小値

using Optim
f(x) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
x0 = [0.0, 0.0] #初期値を0,0とした。
a1 = optimize(f, x0)
xsol = Optim.minimizer(a1) #関数fを最小化するxの値
println("xsol = $xsol")
fmin = Optim.minimum(a1) #関数fの最小値
println("fmin = $fmin")

