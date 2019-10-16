#!/usr/bin/env python3
"""Script that:
1)Reads a csv file containing rows of tuples, and upon printing each
tuple row, it will also print "This speies is" and the row[0] which
is the species name in the tuple
2)Will read the same file again, then it will write another csv
 containing only the species names and their corresponding male
body masses
""" 

import csv

# Read a file containing:
# 'Species', 'Infraorder', 'Family', 'Distribution', 'Body mass male'
f = open('../Data/testcsv.csv', 'r')

csvread = csv.reader(f)
temp = []
for row in csvread:
    temp.append(tuple(row))
    print(row)
    print("The species is", row[0], "\n")

f.close()

# Write a file containing only species name and Body mass male
f = open('../Data/testcsv.csv', 'r')
g = open('../Data/bodymass.csv', 'w')

csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()
