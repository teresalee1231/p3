# p3

Names:
Benjamin Jee (benjee19)
Ashley Luty (aluty02)
Teresa Lee  (teresl4)

To Reproduce the results:
- Run `sudo ./run.sh` for TCP Reno
- Run `sudo ./run_bbr.sh` for TCP BBR

## Part 2 Questions

### What is the average webpage fetch time and its standard deviation when q=20 and q=100?
q=20:  
- avg time: 3.608 seconds	 
- std dev: 1.258 seconds  

q=100:   
- avg time: 8.975 seconds  
- std dev: 1.501 seconds  

### Why do you see a difference in webpage fetch times with short and large router buffers?

We see a difference in webpage fetch times between short and large router buffers because as the host steadily increases their congestion window, the router packet queue will eventually fill up. On a shorter buffer, the host will encounter congestion and drop packets at an earlier time than on a larger buffer, allowing the host to respond to congestion by reducing its congestion window. This adaption allows more packets to get through without having to be retransmitted, increasing goodput. Meanwhile, by the time the larger buffer gets full, the host will be well above the optimal congestion window when compared to the smaller buffer. This difference in operation with the “optimum operating point” in combination with the fact that it takes a while to flush out the router’s queue, causes a difference in times.

### Bufferbloat can occur in other places such as your network interface card (NIC). Check the output of ifconfig eth0 of your mininet VM. What is the (maximum) transmit queue length on the network interface reported by ifconfig? For this queue size, if you assume the queue drains at 100Mb/s, what is the maximum time a packet might wait in the queue before it leaves the NIC?

Max queue length is 1000 ethernet frames (txqueuelen)  
MTU is 1500 bytes  
1000 * 1500 bytes * (1 M byte / 10^6 bytes) * ( 8 M bit / 1 M byte) * ( 1 sec / 100 Mb) = 0.12 seconds  
The packet might wait in the queue for a maximum of 0.12 seconds.  

### How does the RTT reported by ping vary with the queue size? Describe the relation between the two.

The RTT reported by ping varies by the queue size in that for the router with a smaller queue, the RTT hovers around a lower value while the router with the larger queue hovers around a larger RTT since it’s always trying to drain its longer queue, and so each new packet gets added to the long queue before it gets processed. A higher queue size results in a higher RTT reported by ping. This makes sense because as the queue size increases, the amount of data in the queue also increases (since the curling shoves data into the queue and will do slow start which runs into an higher send rate than the router can send, leading to congestion control but it still fills the queue), thus for a ping to get through it will need to wait in the queue, so a longer queue means more data the ping has to wait for until it is it’s time to get sent.


### Identify and describe two ways to mitigate the bufferbloat problem.

Bufferbloat can be mitigated by detecting when the router queue is filling up before it is full and begins dropping packets, allowing for more responsive adaptation to congestion. One way to mitigate bufferbloat is to detect congestion explicitly through ECN (explicit congestion notification). When the router queue fills past a certain point, it adds a congestion signal to new packets it encounters to signal that congestion is occurring. The receiver then sends an ack to the sender with the congestion signal, and the sender reduces its flow, thus reducing congestion even when router queue sizes are large.  
Another way to mitigate bufferbloat is to use Random Early Detection (RED). After the router queue exceeds a certain threshold, the router engages in random early drop: it randomly drops a percentage of incoming packets, implicitly notifying the host that congestion is occurring even before the queue is full. Again, this packet dropping lets the sender respond to congestion early on and avoids the delayed response that comes with only dropping packets when the buffer is completely full.

## Part 3 Questions
### What is the average webpage fetch time and its standard deviation when q=20 and q=100?
q = 20:  
- avg time: 2.274 seconds  
- std dev: 0.786 seconds  

q = 100:    
- avg time: 2.082 seconds  
- std dev: 0.474 seconds  

### Compare the webpage fetch time between q=20 and q=100 from Part 3. Which queue length gives a lower fetch time? How is this different from Part 2?

The fetch time between q=20 and q=100 are relatively similar, with q=100 being only slightly lower and having a lower standard deviation. We see that in Part 2, the difference between fetch times for q=20 and q=100 is greater than the fetch times in Part 3, and the Part 2 q=100 fetch time is much greater than the q=20 time while the opposite is true for Part 3. We also see that in Part 3, the fetch times are lower compared to the times in Part 2. The standard deviations of Part 3 are also lower than those of Part 2.


### Do you see the difference in the queue size graphs from Part 2 and Part 3? Give a brief explanation for the result you see.

We can see a clear difference in the queue size graphs from Part 2 and Part 3 where the Part 2 graphs often max out at the max number of packets while the Part 3 graphs do it much less that Part 2 in q=20 and don’t do it at all in q=100. In addition, the Part 3 graphs spend more time at a lower amount of packets in the queue than the Part 2 graphs. This is because instead of instead of TCP Reno where the algorithm uses packet loss (which occurs when the queue is full) to adjust the congestion window, TCP BBR uses Bottleneck Bandwidth and Round-trip propagation time to adjust the congestion window meaning that the queue doesn’t need to get full before congestion control kicks into effect. Since part 2 is using TCP Reno, we understand that in order to perform congestion control, the queue will be maxed, thus the graph will spend more time at higher levels in the queue, which contrasts part 3 that uses TCP BBR where congestion control is based on other aspects.

### Do you think we have solved bufferbloat problem? Explain your reasoning.

Yes, we think that BBR solves the bufferbloat problem and the data seems to back this claim up. The bufferbloat problem is that as buffer size is increased, latency increases, reducing performance. Looking at our Part 2 webpage fetch times (which uses TCP Reno) we can see the bufferbloat problem since the q=20 has a much lower RTT (low latency) than the q=100. However, when we look at our Part 3 webpage fetch times (which uses TCP BBR) we can see that the queue size doesn’t seem to negatively impact the performance and even results in a larger queue having a better performance. Bufferbloat is solved by BBR because BBR doesn’t use packet loss to adjust the congestion window, instead using the bottleneck bandwidth and RTT, which begin increasing even before the queue is full due to the queue processing delay. This means the queues having less build-up due to this form of congestion control and ultimately leads to better latency. So having a larger buffer will not cause decreased latency, solving bufferbloat.

