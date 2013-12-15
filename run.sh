#!/bin/bash
rm -f output.txt
matlab -nojvm -nodisplay -nodesktop -nosplash -r "PCSTMain('C02-A.stp', 'output.txt')" </dev/null &> /tmp/vivek/simul.log &
wait
cat output.txt
mail -s 'Local Search' -r sar.vivek@gmail.com vivek-sardeshmukh@uiowa.edu < output.txt
# $Id: $
