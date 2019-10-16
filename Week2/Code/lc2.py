#!/usr/bin/env python3
"""A practical exercise for use of using loops and list comprehensions 
to display certain information from a particular tuple of tuples"""

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

rainfall_list = list(rainfall)
## (3)
##Loop for tuple of the month, rainfall if above 100mm
Monthmm_above100 = []
for row in rainfall_list:
    if row[1] > 100:
        Monthmm_above100.append(row)
print(Monthmm_above100)

##Loop for tuple of the month if below 50mm
Name_below50 = []
for row in rainfall_list:
    if row[1] < 50:
        Name_below50.append(row[0])
print(Name_below50)

## (1)
##List comprehension for a tuple with all the month, rainfall greater than 100mm
Monthmm_above100_lc = [row for row in rainfall_list if row[1] > 100]
print(Monthmm_above100_lc)

## (2)
##List comprehension for tuple of the month if below 50mm
Name_below50_lc = [row[0] for row in rainfall_list if row[1] < 50]
print(Name_below50_lc)
