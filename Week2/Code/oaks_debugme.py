#!/usr/bin/env python3

"""A script to read a csv file with lots of tree bionomial names in
and write another csv file with only all the oak tree bionomial 
names in it """

import csv
import sys
import doctest

#Define function
def is_an_oak(name):
    """ Returns True if name starts with 'quercus' 
    Examples:
    >>> is_an_oak("QuerCus cerris")
    True

    >>> is_an_oak("Fagus sylvatica")
    False

    >>> is_an_oak("QuerCuss")
    False

    >>> is_an_oak("quercus,robur")
    True

    >>> is_an_oak("QuerCus.X carrisona")
    True
    """

    name = name.replace(",", " ").replace(".", " ")
    
    splitname = name.split()
    if len(splitname[0]) != 7:
        return False

    return name.lower().startswith('quercus')


def main(argv):
    """Reads a csv file with trees in it, checks if there are oaks,
    prints all the binomial names and says what genus it is in
     terminal output. If it is an oak, it will announce 'FOUND AN OAK!'
     in the terminal and write the bionomial name into a separate csv file
    """
    f = open('../Data/TestOaksData.csv','r')
    g = open('../Data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    oaks = set()
    a = "Genus"
    b = " Species"
    csvwrite.writerow([a, b])
    for row in taxa:
        if row[0] == "Genus":
            pass
        else:
            print(row)
            print ("The genus is: ") 
            print(row[0] + '\n')
            if is_an_oak(row[0]):
                print('FOUND AN OAK!\n')
                csvwrite.writerow([row[0], row[1]])    
    f.close()
    g.close()
    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)

doctest.testmod()