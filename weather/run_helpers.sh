#!/bin/bash
while :
do
 wget http://api.openweathermap.org/data/2.1/weather/city/2925177?type=json -O current > /dev/null 2>&1
 echo "got current"
 wget http://api.openweathermap.org/data/2.2/forecast/city/2925177?mode=daily_compact -O forecast > /dev/null 2>&1
 echo "got forecast"
 wget http://www.uniklinik-freiburg.de/modules/webcam/550/1.jpg -O temppic.jpg >/dev/null 2>&1
 mv temppic.jpg 1.jpg
 echo "got pic"
# python analogclock/clock.py
 #uncomment following line if using python2
 python analogclock/clock_python2.py
 echo "set clock"
 sleep 30
done
