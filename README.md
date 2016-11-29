#NS2 Simulator

-Install:
sudo apt-get install ns2
sudo apt-get purge nam
wget --user-agent="Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" "http://technobytz.com/wp-content/uploads/2015/11/nam_1.14_amd64.zip"
unzip nam_1.14_amd64.zip
sudo dpkg -i nam_1.14_amd64.deb
sudo apt-mark hold nam

-Question:
To write a script to simulate the above topology in which there are five TCP sessions established at the same time. FTP transfers are attached in each of TCP sessions. Each of the TCP sessions has a distinct source but all are destined to the same receiver. All sources start transmitting from time t=0.1s to t=10s continuously. Then, monitor the average throughput of all five TCP sessions at the sink over a series of windows of size 0.5s each. 

-Queue Type:

Droptail: FIFO
	Who comes first, who always drops

SFQ: Stochastic Fair Queuing
	Random drop

As the xgraphs show, using SFQ is fairer than using Droptail. In Droptail, the first source always gets the highest throughput. However, in SFQ, most of the sources get a fair share of bandwidth so that no one is always using the most time.
