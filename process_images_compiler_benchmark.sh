#!/bin/bash
input_file="./edge_detection-master/main_process_parallel.c"
output_file="./edge_detection-master/process"
for flag in "-O0" "-O1" "-O2" "-O3"; do
    command="gcc $flag $input_file ./edge_detection-master/png_util.c -o $output_file -lpng -lm -fopenmp"
    $(eval "$command") 
    total_time=0
    for trial in {1..10}; do
        echo "Trial $trial"
        sum_of_time=0
        for item in ./edge_detection-master/images/*; do
	    start_time=$(date +%s.%N)
            ./edge_detection-master/process "$item" ./edge_detection-master/test.png
            end_time=$(date +%s.%N) 
            duration=$(echo "$end_time - $start_time" | bc)
            sum_of_time=$(echo "$sum_of_time + $duration" | bc)
        done
        total_time=$(echo "$total_time + $sum_of_time" | bc)
    done
    average_time=$(echo "scale=5; $total_time / 10" | bc)
    echo "Flag: $flag Average time taken: $average_time seconds"
done
