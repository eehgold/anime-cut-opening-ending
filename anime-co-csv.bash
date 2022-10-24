#!/bin/sh

#WORK DIRECTORY
IN_DIR="./in"
OUT_DIR="./out"
DATA_DIR="./data"

DATAFILE = $DATA_DIR/op-binge.csv

#COUNT NUMBER OF FILE
COUNT_FILES=$(ls $IN_DIR | wc -l)
echo "$COUNT_FILES files..."

FILES="$IN_DIR/*.mkv"
for f in $FILES
do
    NB=${f//[^0-9]/}
    NB=${NB:0:3}
    echo "---------------------------------------------------$NB---------------------------------------------------"
    time=$(sed -n "/$NB/p" ./data/op-binge.csv)
    time=$(echo $time | cut -c 7-)
    if [[ $time == *"-"* ]]; then
        echo "Error...cancel..."
        time="0"
    fi
    time_s=$(echo "$time" | awk -F: '{ print ($1 * 60) + $2 }')
    echo $time
    echo $time_s
    ffmpeg -ss $time_s -i "$f" -vcodec copy -acodec copy "$OUT_DIR/$NB-cut.mkv"
done
