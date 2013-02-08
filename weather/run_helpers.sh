#!/bin/bash
while :
do
 wget http://api.openweathermap.org/data/2.1/weather/city/2925177?type=json -O current > /dev/null 2>&1
 echo "got current"
 wget http://api.openweathermap.org/data/2.2/forecast/city/2925177?mode=daily_compact -O forecast > /dev/null 2>&1
 echo "got forecast"
 python analogclock/clock.py
 echo "set clock"
 sleep 30
done
