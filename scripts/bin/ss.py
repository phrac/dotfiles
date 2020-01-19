#!/usr/bin/env python
import os
import sys
import datetime

save_path = os.environ['HOME'] + '/ss/'

out = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
if len(sys.argv) > 1:
    fn = out + '-sel.png'
    os.system("import -quality 95 -border png:- | convert png:- -border 12 \
              -bordercolor white "+ save_path + fn)
else:
    fn = out + '-full.png'
    os.system("import -window root -quality 95 " + save_path + fn)
