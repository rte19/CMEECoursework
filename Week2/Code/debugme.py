#!/usr/bin/env python3

"""A script illustrating the use of debugging"""

def makeabug(x):
    """A function with a bug in it"""
    y = x**4
    z = 0.
    y = y/z
    return y

makeabug(25)
