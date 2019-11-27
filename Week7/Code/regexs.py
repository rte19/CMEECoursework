#!usr/bin/env python3
"""Regular expressions in Python"""

import re

my_string = "a given string"

match = re.search(r'\s', my_string)
print(match)

match.group()

match = re.search(r'\d', my_string)
print(match)

MyStr = 'an example'
match = re.search(r'\w*\s', MyStr)
if match:
    print('found a match:', match.group())
else:
    print('did not find a match')

match = re.search(r'2', "it takes 2 to tango")
match.group()
match = re.search(r'\d', "it takes 2 to tango")
match.group()
match = re.search(r'\d.*', "it takes 2 to tango")
match.group()
match = re.search(r'\s\w{1,3}\s', 'once upon a time') #whitespce,word character 1-3 times,whitespace
match.group()
match = re.search(r'\s\w*$', 'once upon a time') #whitespace,any number of word characters - all only at the end of the string
match.group()

#more compact syntax to directly return the matched group
re.search(r'\w*\s\d.*\d', 'take 2 grams of H2O').group() #any number of word characters,whitespace,integer,any nmber of anything,integer
re.search(r'^\w*.*\s', 'once upon a time').group() #only at the start,any number of word character,any number of anything,whitespace
#Note that *, +, and { } are all "greedy": They repeat the previous 
#regex token as many times as possible.
#As a result, they may match more text than you want. To make it 
#non-greedy and terminate at the first found instance of a pattern, 
#use ?:
re.search(r'^\w*.*?\s', 'once upon a time').group() #only at the start,any number of word character,anything,whitespace 

re.search(r'<.+>', 'This is a <EM>first</EM> test').group() # the + is very greedy

re.search(r'<.+?>', 'This is a <EM>first</EM> test').group() #the ? makes the + lazy

re.search(r'\d*\.?\d*', '1432.75+60.22i').group() #any number of integers,dot,any number of integers

re.search(r'[AGTC]+', 'the sequence ATTCGT').group() #[] means to match any character listed

re.search(r'\s+[A-Z]\w+\s*\w+', "The bird-shit frog's name is Theloderma asper.").group() 
#whitespaceS,capital letter,word characters,whitespaces,word characters

#Finding an email address
MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+", MyStr) 
#Any combination of word characters and spaces,comma,space,any combination of word characters and dots and @s,comma,space,word characters and spaces
match.group()

#See if it works on a different type of email address
MyStr = 'Samraat Pawar, s-pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+", MyStr)
match.group()
#Doesn't work..
#So you got to make it more robust
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s&]+", MyStr)
match.group()

##Grouping regex patterns

MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s&]+", MyStr)
match.group()

#without grouping the regex:
match.group(0)
#Now create groups using () :
match = re.search(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+),\s([\w\s&]+)", MyStr)
if match:
    print(match.group(0))
    print(match.group(1))
    print(match.group(2))
    print(match.group(3))


##Finding all matches
MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a-academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a_academic@imperial.ac.uk, Some other stuff thats even more boring"

#Now re.findall() returns a list of all the emails found:
emails = re.findall(r"[\w\.-]+@[\w\.-]+", MyStr)
for email in emails:
    print(email)


##Finding in files
f = open("../Data/TestOaksData.csv", "r")
found_oaks = re.findall(r"Q[\w\s].*\s", f.read())
found_oaks
f.close()

##Groups within multiple matches. Grouping with ()
MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, a-academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, y.a_academic@imperial.ac.uk, Some other stuff thats even more boring"

found_matches = re.findall(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+)", MyStr)
found_matches #In this case returns a list of tuples. Each tuple is each reg match

for item in found_matches:
    print(item)


##Extracting text from webpages
import urllib3

conn = urllib3.PoolManager() #open a connection
r = conn.request("GET", "https://www.imperial.ac.uk/silwood-park/academic-staff/")
webpage_html = r.data #read in the webpage's contents

type(webpage_html)
#This is returned as bytes and not strings, so we have to dcode it
My_Data = webpage_html.decode()
#print(My_Data)
#A lot of potentially useful information! Let's extract all the names of the academics
pattern = r"(Dr|Prof)\s+\w+\s+\w+"
regex = re.compile(pattern) #example use of re.compile(); you can also ignore case with re.IGNORECASE
for match in regex.finditer(My_Data):
    print(match.group())

##Replacing text
New_Data = re.sub(r'\t',' ', My_Data) #Replace all tabs with a space
print(New_Data)


