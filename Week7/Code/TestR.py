#!usr/bin/env python3
"""A script that runs R from python, by use of a simple workflow"""

import subprocess

subprocess.Popen("Rscript --verbose TestR.R > ../Results/TestR.Rout 2> ../Results/TestR_errFile.Rout", shell=True).wait()