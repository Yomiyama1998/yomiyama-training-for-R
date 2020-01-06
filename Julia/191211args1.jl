using Distributions
using Plots
using PyPlot

function evol(derived,size,end_sim)
    p=derived/size
    tr=[p]
    for i in 1:end_sim
     m=Binomial(size,p)
     derived=rand(m)
     p=derived/size  
     tr=hcat(tr,[p])
    end          
    return tr
end

function sims(derived,size,end_sim,howmany,filename)
    sim=[]
    for i in 1:howmany
            tr=evol(derived,size,end_sim)
    sim=vcat(sim,[tr])
    end
    fig=plt.figure()
    ax=fig.add_subplot(1,1,1)
    for i in 1:howmany
        ax.plot(sim[i]')
    end
    ax.set_xlim(0,100)
    fig.savefig(filename)
    end
a=parse(Int,ARGS[1])
b=parse(Int,ARGS[2])
c=parse(Int,ARGS[3])
d=parse(Int,ARGS[4])
@time sims(a,b,c,d,ARGS[5])