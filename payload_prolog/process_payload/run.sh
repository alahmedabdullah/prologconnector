#!/bin/sh

INPUT_DIR=$1
OUTPUT_DIR=$2

cd $INPUT_DIR
prolog_exe=$(whereis gprolog 2>&1 | awk '/gprolog/ {print $2}')


$prolog_exe $(cat gprolog_command_line.txt) &> runlog.txt


cp ./*.txt ../$OUTPUT_DIR

# --- EOF ---
