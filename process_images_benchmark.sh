#!/bin/bash
total_time=0
for trial in {1..10}; do
    echo "Trial $trial"
    sum_of_time=0

    for item in ./edge_detection-master/images/*; do
        echo "Processing $item"
        start_time=$(date +%s.%N) 
    
        ./edge_detection-master/process "$item" ./edge_detection-master/test.png
    
        end_time=$(date +%s.%N) 
        duration=$(echo "$end_time - $start_time" | bc)
        sum_of_time=$(echo "$sum_of_time + $duration" | bc)
     done
     total_time=$(echo "$total_time + $sum_of_time" | bc)
done

average_time=$(echo "scale=5; $total_time / 10" | bc)
echo "Average time taken: $average_time seconds"
