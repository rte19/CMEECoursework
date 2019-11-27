#!usr/bin/env python3
"""A script showing how regular expressions can be used for text mining of files"""

import re
import scipy as sc 

# Read the file (using a different, more python 3 way, just for fun!)
with open('../Data/blackbirds.txt', 'r') as f:
    text = f.read()

# replace \t's and \n's with a spaces:
text = text.replace('\t',' ')
text = text.replace('\n',' ')
# You may want to make other changes to the text. 

# In particular, note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform to ASCII:

text = text.encode('ascii', 'ignore') # first encode into ascii bytes
text = text.decode('ascii', 'ignore') # Now decode back to string

# Now extend this script so that it captures the Kingdom, Phylum and Species
# name for each species and prints it out to screen neatly.
KPS = []
K = re.findall(r"Kingdom\s\w+", text)
P = re.findall(r"Phylum\s\w+", text)
S = re.findall(r"Species\s\w+\s\w+", text)
KPS.append(K)
KPS.append(P)
KPS.append(S)
#print(KPS)
KPS2 = sc.array(KPS)
KPS2 = KPS2.transpose()
print(KPS2)
    
# Hint: you may want to use re.findall(my_reg, text)... Keep in mind that there
# are multiple ways to skin this cat! Your solution could involve multiple
# regular expression calls (easier!), or a single one (harder!)
