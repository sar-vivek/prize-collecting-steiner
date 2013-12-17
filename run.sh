#!/bin/bash
mkdir -p /tmp/vivek
rm -f output1.txt
for i in {01..09} 
do
    echo "----------$i-----------------"
    matlab -nojvm -nodisplay -nodesktop -nosplash -r "PCSTMain('data/C${i}-A.stp', 'output1.txt')" </dev/null &> /tmp/vivek/simul${i}.log &
    wait
    cat output1.txt
done
mail -s 'Local Search' -r sar.vivek@gmail.com vivek-sardeshmukh@uiowa.edu < output1.txt
    # $Id: $
