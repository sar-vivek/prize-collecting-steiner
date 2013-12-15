#!/bin/bash
rm -f output.txt
matlab -nojvm -nodisplay -nodesktop -nosplash < PCSTMain.m > smalllocal.log &
wait
cat output.txt
mail -s 'Local Search' -r sar.vivek@gmail.com vivek-sardeshmukh@uiowa.edu < output.txt
# $Id: $
