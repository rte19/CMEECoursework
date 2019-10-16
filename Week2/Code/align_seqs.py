#!usr/bin/env python3
"""This script aligns two DNA sequences, from an external csv file,
 such that they are as similar as possible, and writes the best match
 into another external csv file"""

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest
import csv

f = open('../Data/seqs.csv', 'r') #

csvread = csv.reader(f)
temp = []
for row in csvread:
    temp.append(row)

f.close()

for sequence in temp:
    seq1 = sequence[0]
    seq2 = sequence[1]

l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    seq1 = seq2
    seq2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    """This function takes the shortest DNA sequence, aligns it at
     each position on the longest position and counts how many 
     matches for each iteration. It also prints each match and its score"""
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

g = open('../Results/Best_alignment.txt', 'w')

for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # think about what this is doing!
        my_best_score = z 
print(my_best_align)
print(s1)
print("Best score:", my_best_score)

print(my_best_align, file=g)
print(s1, file=g)
print("Best score:", my_best_score, file=g)

g.close()

