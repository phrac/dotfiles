#! /bin/bash
for i in $(seq --format=%003.f 1 150); do
	echo Prepare page $i and press Enter, f when finished scanning
	read text
	if [ "$text" == "f" ]; then
		break
	fi
	scanimage --format=png --resolution 300 -x 216 -y 279.4 >scan-$i.png

done
