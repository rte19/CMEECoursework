#!usr/bin/bash
###Prifling the two scripts: LV1.py and LV2.py, using bash

echo "Profiling the LV1.py script"
python3 -m cProfile LV1.py 

echo "Profiling the LV2.py script"
python3 -m cProfile LV2.py 





