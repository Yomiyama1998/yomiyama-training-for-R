# time
import time

# additional library
import numpy as np

def evolv(derived,pop_size,end_sim):
    tr = [derived/pop_size]
    for i in range(end_sim):
         # make the next generation
        derived = np.random.binomial(n=pop_size, p=derived/pop_size)
        tr.append(derived/pop_size)
    return tr


def sim(derived,pop_size,end_sim,howmany):
   sim = []
   tr =[]
   for j in range(howmany):
      tr=evolv(derived,pop_size,end_sim)
      sim.append(tr)
   return sim

def timeevolv(derived,pop_size,end_sim,howmany):
    start=time.time()
    sim(derived,pop_size,end_sim,howmany)
    elapsed=time.time()-start
    print("elapsed time: {0:.3f} sec".format(elapsed) ) 

timeevolv(40,100,10000,100)