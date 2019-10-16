#!/usr/bin/env python3
"""A practical exercise for the use loops and list comprehensions can
be used to display specific information from a tuple of tuples"""

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

## (2)
Bird_list = list(birds) # making the tuple above into a list

## A loop to get all Latin names
Latin_names = []
for row in Bird_list:
    Latin_names.append(row[0])
print(Latin_names)

## A loop to get all the common names
Common_names = []
for row in Bird_list:
    Common_names.append(row[1])
print(Common_names)

## A loop to get all the average body masses
Body_masses = []
for row in Bird_list:
    Body_masses.append(row[2])
print(Body_masses) 

## (1)
## A list comprehension to get all Latin names
Latin_names_LC = [row[0] for row in Bird_list]
print(Latin_names_LC)

## A list comprehension to get all common names
Common_names_LC = [row[1] for row in Bird_list]
print(Common_names_LC)

## A loop comprehension to get all body masses
Body_masses_LC = [row[2] for row in Bird_list]
print(Body_masses_LC)