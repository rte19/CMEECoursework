#!usr/bin/env python3

"""A script to generate and plot a "synthetic" food web"""

import networkx as nx 
import scipy as sc 
import matplotlib.pylab as p

def GenRdmAdjList(N = 2, C = 0.5):
    """Generating a random adjacency list of consumers and resources"""
    Ids = range(N)
    ALst = []
    for i in Ids:
        if sc.random.uniform(0,1,1) < C: #if one number chosen in the uniform random distribution bewteen 0 and 1 is less then C, then this is used as the connectance probablity between the consumer and the resource
            Lnk = sc.random.choice(Ids,2).tolist() #creating a temporary variable Lnk, taking two random Ids, adding them to the list
            if Lnk[0] != Lnk[1]: #avoid self (e.g. cannibalistic) loops
                ALst.append(Lnk) 
    return ALst

MaxN = 30 #Assign the number of species
C = 0.75 #Assign concatenance probability

#Generate the adjacency list representing a random food web:
Adjl = sc.array(GenRdmAdjList(MaxN, C))
#Adjl
#The columns in this adjacency list refer to th consumer and resource ids respectively

#Creating the species node data
Sps = sc.unique(Adjl) #get species ids
#Sps

#Generating body sizes for the species. We use a log10 scale because
#species body sizes tend to e log-normally distributed
SizRan = ([-10, 10]) #use log10 scale
Sizs = sc.random.uniform(SizRan[0], SizRan[1], MaxN)
#Sizs

#Let's visualize the size distriution we have generated
p.hist(Sizs) #log10 scale

p.hist(10 ** Sizs) #raw scale

#Let's plot the network, with node sizes proportional to (log) body size
p.close('all') #close all open plot objects

#Let's use a circular configuration. For this we calculate the cordinates using networkx
pos = nx.circular_layout(Sps)

#Generate a networkx graph object
G = nx.Graph()
#Add the nodes and links
G.add_nodes_from(Sps)
G.add_edges_from(tuple(Adjl)) #Needs the adjacency list as a tuple
#Generate node sizes that are proportional to (log) body sizes
NodSizs = 1000 * (Sizs-min(Sizs))/(max(Sizs)-min(Sizs))
#Plot the graph
nx.draw_networkx(G, pos, node_size = NodSizs)

p.savefig("../Results/DrawFW.pdf")

