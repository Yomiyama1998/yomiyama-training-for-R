using Distributions
using Plots
using PyPlot


function sims(derived,size,end_sim,howmany)
    sim=[]
    for i in 1:howmany
        p=derived/size
        tr=[p]
        for i in 1:end_sim
         m=Binomial(size,p)
         derived=rand(m)
         p=derived/size  
         tr=hcat(tr,[p])
        end 
        sim=vcat(sim,[tr])
    end
    return sim
end
@time sims(40,100,10000,100)