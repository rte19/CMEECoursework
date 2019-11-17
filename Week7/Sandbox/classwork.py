##Numerical computing in Python

import scipy as sc

a = sc.array(range(5)) # a one-dimensional array
a

print(type(a))
print(type(a[0]))

a = sc.array(range(5), float)
a
a.dtype #Check type

x = sc.arange(5)
x
x = sc.arange(5.) #Directly specify float using decimal
x.shape #To see the dimensions

b = sc.array([i for i in range(10) if i % 2 == 1 ])
#b is anything in the range of 10 that when divided by 2 has a remainder of 1 ie all the odd numbers
b

c = b.tolist() #Convert back to list
c 

mat = sc.array([[0, 1], [2, 3]]) #To make a matrix, you need a 2-D numpy array
mat
mat.shape

##Indexing and accessing arrays

mat[1] #Accessing whole 2nd row, remember indexing starts at  0
mat[:,1] #Accessing whole second column
mat[0,0] #1st row, 1st column element
mat[1,0] # 2nd row, 1st column element
mat[:,0] #accessing whole first column
#Python indexing also accepts negative values from going to the start from the end
mat[0,1]
mat[0,-1]
mat[-1,0]
mat[0,-2]

##Manipulating arrays
##Replacing, adding, and deleting elements

mat[0,0] = -1 #replace a single element
mat
mat[:,0] = [12,12] #replace whole column
mat
sc.append(mat, [[12,12]], axis = 0) #append row, note axis specification
sc.append(mat, [[12],[12]], axis = 1) #append column
#However, here, because we have not actually overwitten the mat object, it does not remember 

newRow = [[12, 12]] #Create new row
mat = sc.append(mat, newRow, axis = 0) #append that existing row
mat
sc.delete(mat, 2, 0) #Deleting 3rd row - won't remember

mat = sc.array([[0, 1], [2, 3]])
mat0 = sc.array([[0, 10], [-1, 3]])
sc.concatenate((mat, mat0), axis = 0) #Concatenating these two numpy arrays

##Flattening or reshaping arrays - "flatten" or "melt" arrays, that is, 

mat.ravel() # NOTEE: ravel is row-priority - happens row by row 
mat.reshape((4,1)) # this is different from ravel
mat.reshape((1,4)) # NOTEE: reshaping is also row-priority, but total elements must remain same

##Pre-allocating arrays
sc.ones((4,2)) #(4,2) are the (row,col) array dimensions
sc.zeros((4,2)) # or zeros
m = sc.identity(4) #create an identity matrix
m 
m.fill(16) #fill the matrix with 16
m 

##numpy matrices
##matrix-vector operations
mm = sc.arange(16) #makes an array
mm = mm.reshape(4,4) #Convert to matrix
mm
mm.transpose() #convrts rows to cloumns and columns to rows - like mirroring it!

mm + mm.transpose() 
mm - mm.transpose()
mm * mm.transpose() ## NOTEE: Elementwise multiplication!
mm // mm.transpose() # // is integer division. 
mm // (mm + 1).transpose() #avoiding dividing by zero
mm * sc.pi #multipling by pi 
mm.dot(mm) # MATRIX MULTIPLICATION, OR DOT PRODUCT
mm = sc.matrix(mm) # convert to scipy matrix class
mm
print(type(mm))
mm * mm #now marix multipication is syntactically easier


##Scipy stats
import scipy.stats 

scipy.stats.norm.rvs(size = 10) # 10 samples from N(0,1)
scipy.stats.randint.rvs(0, 10, size=7) #Random integers between 0 and 10


##Numerical intergration using scipy
import scipy.integrate as integrate

def dCR_dt(pops, t=0):
#A function that returns the growth rate of consumer and resource population at any given time step
    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C 

    return sc.array([dRdt, dCdt])

type(dCR_dt)

#assigning parameter values to dCR_dt
r = 1.
a = 0.1
z = 1.5
e = 0.75

#Define the time vector; let's integrate from time point 0 to 15, using 1000 sub-divisions of time
t = sc.linspace(0, 15, 1000)
t 

#Set the initial conditions for the two populations (10 resources
# and 5 consumers per unit area), and convert the two into an 
# array (because our dCR_dt function take an array as input)
R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])

pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)
pops
#So pops contains the result (the population trajectories). Also 
#check what's in infodict (it's a dictionary with additional 
#information)
type(infodict)
infodict.keys()
infodict['message'] #testing if it is successful

##Plotting in Python
import matplotlib.pylab as p 

f1 = p.figure() #Openning an empty figure object

p.plot(t, pops[:,0], 'g-', label = 'Resource density') #plot
p.plot(t, pops[:,1], 'b-', label = 'Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
p.show() #To display the figure

f1.savefig('../Results/LV_model.pdf') #save figure