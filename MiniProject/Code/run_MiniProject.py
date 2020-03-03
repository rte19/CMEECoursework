#!/usr/bin/env python3

"""run_Minproject.py is a the MiniProject wrapper, executing the project, script by script, from data to pdf report"""

import subprocess

###Running LG_DiagnosticPlot.R
subprocess.Popen(["/usr/lib/R/bin/Rscript", "LG_DiagnosticPlot.R"]).wait()

###Running models_all.R
subprocess.Popen(["/usr/lib/R/bin/Rscript", "models_all.R"]).wait()

###Running fit_analysis.R
subprocess.Popen(["/usr/lib/R/bin/Rscript", "fit_analysis.R"]).wait()

###Running wordcount.sh
subprocess.Popen(["bash", "wordcount.sh"]).wait()

###Running compile_MiniProject.sh
subprocess.Popen(["bash", "compile_MiniProject.sh"]).wait()