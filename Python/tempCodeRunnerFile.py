# time
import time

# additional library
import numpy as np

def evolv(derived,pop_size,end_sim,howmany):
   sim = []
   for j in range(howmany):
       tr = [derived/pop_size]
       for i in range(end_sim):
            # make the next generation
            derived = np.random.binomial(n=pop_size, p=derived/pop_size)
            tr.append(derived/pop_size)
       sim.append(tr)
   return sim

def timeevolv(derived,pop_size,end_sim,howmany):
    start=time.time()
    evolv(derived,pop_size,end_sim,howmany)
    elapsed=time.time()-start
    print("elapsed time: {0:.3f} sec".format(elapsed) ) 

timeevolv(40,100,10000,100)