using DifferentialEquations

f(u,p,t) = 1.01*u
u0=1/2
tspan = (0.0,1.0)
prob = ODEProblem(f,u0,tspan) #微分がfで初期値がu0の微分方程式du/dt = f(u)を解く。
@time sol = solve(prob,Tsit5(),reltol=1e-8,abstol=1e-8) #Tsit5は解き方を指定
nt = 50
t = range(0.0, stop=1.0, length=nt) #0.0から1.0までのnt点を生成する
for i=1:nt
    println("t= $(t[i]), solution: $(sol(t[i])), exact solution $(0.5*exp(1.01t[i]))")
end

#ローレンツ曲線

using ParameterizedFunctions

function parameterized_lorenz(du,u,p,t) #微分dy、関数u、パラメータp、変数t
    du[1] = p[1]*(u[2]-u[1])
    du[2] = u[1]*(p[2]-u[3]) - u[2]
    du[3] = u[1]*u[2] - p[3]*u[3]
   end
   
   u0 = [1.0,0.0,0.0] #x=1,y=0,z=0を初期値とする。
   tspan = (0.0,1.0) #時間は0から1まで。
   p = [10.0,28.0,8/3] #パラメータ三つ
   @time prob = ODEProblem(parameterized_lorenz,u0,tspan,p)

#マクロを使った書き方

using ParameterizedFunctions
g = @ode_def LorenzExample begin
  dx = σ*(y-x) #dxとあるので、xが微分されるもの。
  dy = x*(ρ-z) - y
  dz = x*y - β*z
end σ ρ β #パラメータは三つある

u0 = [1.0;0.0;0.0] #x=1,y=0,z=0を初期値とする。
tspan = (0.0,1.0) #時間は0から1まで。
p = [10.0,28.0,8/3] #σ ρ β を設定
@time prob = ODEProblem(g,u0,tspan,p)


