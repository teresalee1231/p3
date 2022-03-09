#!/bin/bash

# Note: Mininet must be run as root.  So invoke this shell script
# using sudo.

time=90
bwnet=1.5
delay=5

iperf_port=5001

for qsize in 20 100; do
    dir=bb-bbr-q$qsize

    python3 bufferbloat.py -d=$dir -t=$time -b=$bwnet --delay=$delay --maxq=$qsize --cong bbr
    python3 plot_queue.py -f $dir/q.txt -o bbr-buffer-q$qsize.png
    python3 plot_ping.py -f $dir/ping.txt -o bbr-rtt-q$qsize.png
done
