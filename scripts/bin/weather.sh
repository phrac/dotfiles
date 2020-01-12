touch /tmp/wget_LFRS.txt
METEO_URL="http://weather.noaa.gov/pub/data/observations/metar/decoded/KOMA.TXT"

while true;
do
    wget -q -O "/tmp/wget_LFRS.txt" $METEO_URL
    TEMP=`grep Temperature /tmp/wget_LFRS.txt | cut -d " " -f 4 | sed s/\(//`
    HUMIDITY=`grep Humidity /tmp/wget_LFRS.txt | cut -d " " -f 3`
    CONDITION=`grep Sky /tmp/wget_LFRS.txt | cut -d " " --fields=3,4`
    echo "T°:" $TEMP"°C Hum:" $HUMIDITY $CONDITION > /tmp/weather.txt
    # if you need an iso output (wmii 3.6, stump modeline) use this file instead
    iconv -f utf-8 -t iso-8859-15 /tmp/weather.txt > /tmp/weatheriso.txt
    sleep 30m
done
