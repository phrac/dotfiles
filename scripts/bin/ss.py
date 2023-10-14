#!/usr/bin/env python
import os
import sys
import datetime

save_path = os.environ['SSDIR']

out = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")

# Any arguments appended will capture a window or selectable region and add a white border
if len(sys.argv) > 1:
    fn = out + '-sel.png'
    os.system("import -quality 95 -frame -border png:- | convert png:- -border 6 \
              -bordercolor white " + save_path + fn)

# No arguments, capture the entire desktop
else:
    fn = out + '-full.png'
    os.system("import -window root -quality 95 " + save_path + fn)
