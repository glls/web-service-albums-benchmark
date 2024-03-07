#!/usr/bin/env bash

dir=$(basename $PWD)
host=$(hostnamectl hostname)
filename="results_${dir}_${host}.txt"

echo Running $dir test | tee -a $filename

wrk -d 20 -t 1 -c 1 http://127.0.0.1:8000/albums | tee -a $filename

wrk -d 20 http://127.0.0.1:8000/albums | tee -a $filename

wrk -d 20 -t 16 -c 500 http://127.0.0.1:8000/albums | tee -a $filename

exit 0
