#!/bin/sh

#WORK DIRECTORY
IN_DIR="./out"
OUT_DIR="./out"
DATA_DIR="./data"

DATAFILE = $DATA_DIR/op-binge.csv

#COUNT NUMBER OF FILE
COUNT_FILES=$(ls $IN_DIR | wc -l)
echo "$COUNT_FILES files..."

#RECUP VARIABLE
echo Episode de depart?
read EP_START
echo Episode de fin?
read EP_FIN
echo Nom du fichier final?
read MERGE_NAME

#VALID DES EPISODES
EP_DIFF=$(($EP_FIN-$EP_START))
echo Selection de $EP_DIFF épisodes

#CREATION FICHIER DES EPISODES
touch "$OUT_DIR/zlist.txt"
echo "" > "$OUT_DIR/zlist.txt"

#ON AJOUTE CHAQUES EPISODES AU FICHIER
for (( i=$EP_START; i <= $EP_FIN; i++ )); 
do 
    echo "Ajout de l'épisode $i"
    echo "file $i-cut.mkv" >> "$OUT_DIR/zlist.txt"
done

#ON CONCAT LES EPISODES
ffmpeg -f concat -i "$OUT_DIR/zlist.txt" -c copy "$MERGE_NAME.mkv"