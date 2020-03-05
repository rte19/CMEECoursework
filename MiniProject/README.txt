The MiniProject README.txt

Date submitted: 06/03/2020

Code

    compile_MiniProject.sh
        #!/bin/bash
        # Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
        # Script: compile_MiniProject.sh
        # Desc: This bash compiles MiniProject LaTeX file, to make it a PDF file in Results directory
        # Date: 03 March 2020

    fit_analysis.R
        #!usr/bin/env R
        ###A script to analyse the model fitting results (AICs) produced from the models_all.R script
        R version 3.6.2 (2019-12-12)
        The package ggplot2 was used for superior plotting

    LG_DiagnosticPlots.R 
        #!usr/bin/env R
        ###Constructing diagnostic plots of the data 
        R version 3.6.2 (2019-12-12)
        The package ggplot2 was used for superior plotting
        The tidyr package was used for wrangling the datasets with the nest() function

    MiniProject.tex
        The MiniProject report

    models_all.R 
        #!usr/bin/env R
        ###A script for modelling all the six models on the data
        R version 3.6.2 (2019-12-12)
        The package ggplot2 was used for superior plotting
        The tidyr package was used for wrangling the datasets with the nest() function
        The minpack.lm package was used for the function nlsLM, to converge the non-linear models through optimisation of their parameters

    run_MiniProject.py
        #!/usr/bin/env python3
        """run_Minproject.py is a the MiniProject wrapper, executing the project, script by script, from data to pdf report"""
        version 3.6.9
        The subprocess package was used to enable it to run each script in the correct order

    wordcount.sh 
        #!/bin/bash
        # Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
        # Script: wordcount_MiniProject.sh
        # Desc: Calculates the wordcount of my write up and allows me to put this onto the document
        # Date: 03 March 2020

Data

    LogisticGrowthData.csv
        The original dataset of population growth, functional response data.

    LogisticGrowthMetaData.csv
        Key for the column headings within LogisticGrowthData.csv

    MiniProject.bib
        Bibliography for MiniProject.tex

    MiniProject.sum 
        A text file to hold the word count of the report
Results