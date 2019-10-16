#!usr/in/env python3
"""Writes a dictionary into a .p file and then reads that file
and prints it out"""

#############################
# STORING OBJECTS
#############################
# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

import pickle

f = open('../sandbox/testp.p', 'wb') ## note the b: accept binary
pickle.dump(my_dictionary, f)
f.close()

## Load the data again
f = open('../sandbox/testp.p', 'rb')
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)