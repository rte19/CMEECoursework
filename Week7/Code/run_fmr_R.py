#!usr/bin/env python3
"""Runs fmr.R to generate the desired result and prints to the 
python screen whether the run was successful, and the contents of 
the R console output"""

import subprocess

###Running the R script and storing its output (stdout) and any error codes (stderr)
p = subprocess.Popen(["Rscript", "fmr.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
stdout, stderr = p.communicate()

###Telling us if the R script ran with no errors
if str(stderr) == "b''":
    print("This ran correctly with no errors")
else:
    print("This ran incorrectly with error/s")

###Printing the output from the R script
print(stdout.decode())