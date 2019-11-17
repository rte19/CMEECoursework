#!usr/bin/env python3

"""A script that plots Lotka-Volterra model: a predator-prey system 
in 2D space"""

import sys
##Numerical intergration using scipy
import scipy.integrate as integrate
import scipy as sc

#The Lotka-Volterra model: a predator-prey system in 2D space

def dCR_dt(pops, t=0):
    """A function that returns the growth rate of consumer and resource population at any given time step"""
    R = pops[0]
    C = pops[1]
#    dRdt = r * R - a * R * C
    dRdt = r * R * (1 - R / K) - a * R * C

    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])

#C and R are consumer (e.g., predator) and resource (e.g., prey) 
#population abundance (either number × area−1 ), r is the intrinsic 
#(per-capita) growth rate of the resource population (time−1), a is
# per-capita "search rate" for the resource (area×time−1) 
#multiplied by its attack success probability, which determines the
# encounter and consumption rate of the consumer on the resource,
# z is mortality rate (time−1) and e is the consumer's efficiency 
#(a fraction) in converting resource to consumer biomass.

type(dCR_dt)

#assigning parameter values to dCR_dt with the command line
r = sys.argv[1]
a = sys.argv[2]
z = sys.argv[3]
e = sys.argv[4]
K = 1

#Define the time vector; let's integrate from time point 0 to 15, using 1000 sub-divisions of time
t = sc.linspace(0, 15, 1000)

#Set the initial conditions for the two populations (10 resources
# and 5 consumers per unit area), and convert the two into an 
# array (because our dCR_dt function take an array as input)
R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)
#So pops contains the result (the population trajectories). Also 
#check what's in infodict (it's a dictionary with additional 
#information)

#type(infodict)
#infodict.keys()
#infodict['message'] #testing if it is successful

##Plotting in Python
import matplotlib.pylab as p 

f1 = p.figure() #Openning an empty figure object

p.plot(t, pops[:,0], 'g-', label = 'Resource density') #plot
p.plot(t, pops[:,1], 'b-', label = 'Consumer density') #plot
p.grid()
p.legend(loc='best')
p.xlabel('Time') 
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
p.show() #To display the figure

#f1.savefig('../Results/LV2_model.pdf') #save figure

#f2 = p.figure() #Openning a second empty figure
#p.plot(pops[:,0], pops[:,1], 'r-') # plot
#p.grid()
#p.xlabel('Resource density')
#p.ylabel('Consumer density')
#p.title('Consumer-Resource population dynamics')

#f2.savefig('../Results/LV_model2.pdf')
