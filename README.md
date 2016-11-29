NS2 Simulator

Question:
To write a script to simulate the above topology in which there are five TCP sessions established at the same time. FTP transfers are attached in each of TCP sessions. Each of the TCP sessions has a distinct source but all are destined to the same receiver. All sources start transmitting from time t=0.1s to t=10s continuously. Then, monitor the average throughput of all five TCP sessions at the sink over a series of windows of size 0.5s each. 

Queue Type:

Droptail: FIFO
	Who comes first, who always drops

SFQ: Stochastic Fair Queuing
	Random drop

As the xgraphs show, using SFQ is fairer than using Droptail. In Droptail, the first source always gets the highest throughput. However, in SFQ, most of the sources get a fair share of bandwidth so that no one is always using the most time.
