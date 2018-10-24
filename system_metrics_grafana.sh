#!/bin/bash

elasticsearch="Your Elasticsearch name"
port="9200" ##can run on any other port 
CWD=`pwd`
indexname="Your index name"
docname="Your Document name"
#timeformat
        timestamp=$((`date +%s`*1000+`date +%-N`/1000000))
        today=`date '+%Y%m%d%H%M%S'`
# Get VM Hostname
        hostname=`hostname` 2> /dev/null

# Get Server uptime
if [ -f "/proc/uptime" ];
then
        uptime=`cat /proc/uptime`
        uptime=${uptime%%.*}
        seconds=$(( uptime%60 ))
        minutes=$(( uptime/60%60 ))
        hours=$(( uptime/60/60%24 ))
        days=$(( uptime/60/60/24 ))
        uptime="$days days, $hours hours, $minutes minutes, $seconds seconds"
        updays="$days"
else
        uptime=""
fi

#System health
        cpuload=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
        status=`uptime | awk '{print $2}'`
#RAM
        totalRam=`free -g | awk 'FNR == 2 {print $2}'`
        freeRam=`free -g| awk 'FNR == 2 {print $3}'`
#Disk space
        temp=`df .`
        disk_perc=`echo $temp | awk -F ' ' '{print $12}' | sed 's/.$//'`
        #perc=`echo $temp | rev | cut -c 2- | rev`
        disk_left=`echo $temp | awk -F ' ' '{print $11}'`
        disk_used=`echo $temp | awk -F ' ' '{print $10}'`
        disk_total=`echo $temp | awk -F ' ' '{print $9}'`

myjson=$(echo \{\"timestamp\":$timestamp,\"$hostname\"\:\{\"updays\":$updays,\"status\":\"$status\",\"cpuload\":$cpuload,\"totalRam\":$totalRam,\"freeRam\":$freeRam,\"diskPerc\":$disk_perc,\"diskleft\":$disk_left,\"diskused\":$disk_used,\"disk_total\":$disk_total\}\})
echo $myjson >$CWD/myjson.json

echo "http://$elasticsearch:$port/$indexname/$docname/$today" >> $CWD/$today.log
curl -X POST http://$elasticsearch:$port/$indexname/$docname/$today -d @$CWD/myjson.json --header "Content-Type: application/json" >> $CWD/$today.log

##Log Cleanup
        ls -1tr $CWD/*.log | head -n -10 | xargs -d '\n' rm -f --
