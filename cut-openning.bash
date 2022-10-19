#!/bin/sh 

#WORK DIRECTORY
IN_DIR="./in"
OUT_DIR="./out"

#COUNT NUMBER OF FILE
COUNT_FILES=$(ls $IN_DIR | wc -l)
echo "$COUNT_FILES files..."

#HOW MANY SECONDS TO CUT AT THE ENDS OF FILES
CUT_PART_A="15"
CUT_PART_B="3.3"

FILES="$IN_DIR/*.mkv"
for f in $FILES
do
  NB=${f//[^0-9]/}
  NB=${NB:0:3}
  echo "----------------------------- $NB -----------------------------"
  #SPLITING
  [ ! -f "$OUT_DIR/$NB-Part B.mkv" ] && mkvmerge -o $OUT_DIR/$NB-%c.mkv --split chapters:all "$f"
  find $OUT_DIR/ -type f ! -name "*Part*" -delete

  #PART A TRIMMING
  durationA=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT_DIR/$NB-Part A.mkv")
  durationA=$(echo "$durationA - $CUT_PART_A" | bc -l)
  [ ! -f "$OUT_DIR/$NB-Part-A-cut.mkv" ] && ffmpeg -ss 0 -to $durationA -i "$OUT_DIR/$NB-Part A.mkv" -c copy "$OUT_DIR/$NB-Part-A-cut.mkv"
  rm "$OUT_DIR/$NB-Part A.mkv"

  #PART B TRIMMING
  durationB=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT_DIR/$NB-Part B.mkv")   
  durationB=$(echo "$durationB - $CUT_PART_B" | bc -l)
  [ ! -f "$OUT_DIR/$NB-Part-B-cut.mkv" ] && ffmpeg -ss 0 -to $durationB -i "$OUT_DIR/$NB-Part B.mkv" -c copy "$OUT_DIR/$NB-Part-B-cut.mkv"
  rm "$OUT_DIR/$NB-Part B.mkv"
done

