#!/usr/bin/env python3

"""Outlines what a python program boilerplate is"""


__appname__ = 'Pythonboilerplate'
__author__ = 'Ryan Ellis ryan.ellis19@imperial.ac.uk'
__version__ = '0.0.1'
__license__ = 'Liscense'

## imports ##
import sys # module to interface our program with the operating system

## constants ##

## functions##
def main(argv):
    """ Main entry point of the program """
    print('This is a boilerplate') # NOTE: indented using two tabs or 4 spaces
    return 0

if __name__ == "__main__":
    """Makes sure the "main" function is called from the command line"""
    status = main(sys.argv)
    sys.exit(status)
    