#!usr/bin/env python3
"""A script to time and compare speeds of the functions from 
profileme.py and profileme2.py. A method that is easy to use and 
easy to compare the speeds of functions.
This also illustrates how to use %timeit to do just this"""

#################################################################
# loops vs. list comprehensions: which is faster?
#################################################################

iters = 1000000

import timeit
from profileme import my_squares as my_squares_loops
from profileme2 import my_squares as my_squares_lc

# %timeit my_squares_loops(iters)      (can't use magic commands inside the script, must type in command line)
# %timeit my_squares_lc(iters)

#################################################################
# loops vs. the join method for strings: which is faster?
#################################################################

mystring = "my string"

from profileme import my_join as my_join_join
from profileme2 import my_join as my_join

# %timeit(my_join_join(iters, mystring))
# %timeit(my_join(iters, mystring))

#This is golden:) :)