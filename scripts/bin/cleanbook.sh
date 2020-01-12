#!/bin/bash
dos2unix $1
sed 's/^"/``/g' $1 | sed 's/\ "/\ ``/g' | sed 's/\.\.\.\./\\ldots/g' | sed 's/("/(``/g' | sed 's/{"/{``/g' >  tmp.tex 


