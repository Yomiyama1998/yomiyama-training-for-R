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

function sims(derived,size,end_sim,howmany)
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
    plt.show()
    end
sims(40,100,10000,10)
