#!usr/bin/env python3
"""A script to show how to time the speed of the script"""

def my_squares(iters):
    """A function that returns a list containing all the squared values
    of the elements between 1 and iters. In loop format"""
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters, string):
    """A function that returns a string containing a recurring pattern
    of the value of string, followed by a comma, space, then string again, 
    for the number of times specified by iters. 
    E.g "My string", "My string" - 100000000 times."""
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_funcs(x,y):
    """Function that defines the values of iters and string, 
    in the form of x and y, for the other functions"""
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000, "My string")

# Type into ipython command line:
# run -p profileme.py