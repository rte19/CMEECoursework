#!/bin/bash

# Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
# Script: variables.sh
# Desc: you put in a variable in the terminal which becomes the variable
# and also give two nubers in the terminal and it will add them.
# Date: 1 Oct 2019
# Shows the use of variables

MyVar='some string'
echo 'the current value of the variable is' $MyVar
echo 'Please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVar

## Reading multiple values
echo 'Enter two numbers separated by space(s)'
read a b
echo 'you entered' $a 'and' $b '. Their sum is:'
mysum= expr $a + $b
echo $mysum
