#!/usr/bin/env python3

"""Some mathematical functions"""

__author__ = 'Ryan Ellis (ryan.ellis19@imperial.ac.uk)'
__version__ = '0.0.1'

import sys
import doctest
 
def foo_1(x):
    """Finds the square root of x
    Examples:
    >>> foo_1(36)
    6.0
    """
    return x ** 0.5

def foo_2(x, y):
    """Determines which is bigger, x, or y, and prints the biggest one
    Examples:
    >>> foo_2(1, 3)
    3
    
    >>> foo_2(3, 1)
    3
    """
    if x > y:
        return x
    return y

def foo_3(x, y, z):
    """If x is bigger than y, they swap, then if the new y is
    bigger than z, they swap
    Examples:
    >>> foo_3(1, 2, 3)
    [1, 2, 3]
    
    >>> foo_3(3, 2, 1)
    [2, 1, 3]
    """
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo_4(x):
    """Returns the factorial of the given x
    Examples:
    >>> foo_4(4)
    24
    """
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x): 
    """A recursive function that calculates the factorial of x
    Examples:
    >>> foo_5(4)
    24
    """
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x):
    """Calculates the factorial of x in a different way
    Examples:
    >>> foo_6(4)
    24
    """
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

doctest.testmod()   # To run with embedded tests

def main(argv):
    """Defines what x should be for each function"""
    print(foo_1(4))
    print(foo_2(6, 4))
    print(foo_3(6, 4, 2))
    print(foo_4(5))
    print(foo_5(5))
    print(foo_6(5))
    return 0

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)