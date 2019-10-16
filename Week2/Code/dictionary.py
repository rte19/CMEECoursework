#!/usr/bin/env python3
"""A practical exercise for creating a dictionary from a list of
 tuples"""

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 


taxa_dictionary = dict(taxa) #Making the list into a dictionary

#Swaping the keys and values around and putting them into a new dictionary
taxa_dic = {}
for key, value in taxa_dictionary.items():
        if value in taxa_dic:
                taxa_dic[value].append(key)
        else:
                taxa_dic[value] = [key]
print(taxa_dic)

        