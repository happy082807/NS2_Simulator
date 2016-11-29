#Create a simulator object
set ns [new Simulator]
#Define different colors for data flows
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Yellow
$ns color 4 Green
$ns color 5 Orange
#Open the nam trace file
set nf [open drpout.nam w]
$ns namtrace-all $nf
#Open the trace file for analysis
set tf [open drpout.tr w]

# Set number of sources
set NumbSrc 5

set f(1) [open drpout1.tr w]
set f(2) [open drpout2.tr w]
set f(3) [open drpout3.tr w]
set f(4) [open drpout4.tr w]
set f(5) [open drpout5.tr w]
$ns trace-all $tf
#Define a 'finish' procedure
proc finish {} {
 global ns nf tf f NumbSrc
 $ns flush-trace
#Close the trace file
 close $nf
 close $tf
 for {set j 1} {$j<=$NumbSrc} { incr j } {
    close $f($j)
}
#Execute nam on the trace file
 exec nam drpout.nam &
 exec xgraph drpout1.tr drpout2.tr drpout3.tr drpout4.tr drpout5.tr &
 exit 0
}

#Create eleven nodes
set n0 [$ns node]

# Use a for-loop to create $NumbSrc source nodes
for {set j 1} {$j<=$NumbSrc} { incr j } {
    set n($j) [$ns node]
}

# Use a for-loop to create $NumbSrc router nodes
for {set j 1} {$j<=$NumbSrc} { incr j } {
    set r($j) [$ns node]
}

#Create links between the nodes
#Bandwidth 5Mbps, delay 20ms, DropTail
for {set j 1} {$j<=$NumbSrc} { incr j } {
    $ns duplex-link $n($j) $r($j) 5Mb 20ms DropTail
}

#Bandwidth 0.5Mbps, delay 100ms, DropTail
$ns duplex-link $n0 $r(1) 0.5Mb 100ms DropTail
$ns duplex-link $r(1) $r(2) 0.5Mb 100ms DropTail
$ns duplex-link $r(2) $r(3) 0.5Mb 100ms DropTail
$ns duplex-link $r(3) $r(4) 0.5Mb 100ms DropTail
$ns duplex-link $r(4) $r(5) 0.5Mb 100ms DropTail

#Set location
for {set j 1} {$j<=$NumbSrc} { incr j } {
    $ns duplex-link-op $n($j) $r($j) orient down
}

$ns duplex-link-op $r(1) $r(2) orient left
$ns duplex-link-op $r(2) $r(3) orient left
$ns duplex-link-op $r(3) $r(4) orient left
$ns duplex-link-op $r(4) $r(5) orient left
$ns duplex-link-op $n0 $r(1) orient left

# Create TCP Sources
for {set j 1} {$j<=$NumbSrc} { incr j } {
	set tcp($j) [new Agent/TCP/Reno]
}

$tcp(1) set fid_ 1
$tcp(2) set fid_ 2
$tcp(3) set fid_ 3
$tcp(4) set fid_ 4
$tcp(5) set fid_ 5

# Create TCP Destinations
for {set j 1} {$j<=$NumbSrc} { incr j } {
    set tcp_sink($j) [new Agent/TCPSink]
}

# Define connections between TCP src's and sinks
for {set j 1} {$j<=$NumbSrc} { incr j } {
    $ns attach-agent $n($j) $tcp($j)
    $ns attach-agent $n0 $tcp_sink($j)
    $ns connect $tcp($j) $tcp_sink($j)
}

# Create FTP sources
for {set j 1} {$j<=$NumbSrc} { incr j } {
    set ftp($j) [$tcp($j) attach-source FTP]
}

proc record {} {
    global tcp_sink f NumbSrc
    #Get an instance of the simulator
    set ns [Simulator instance]
    #Set the time after which the procedure should be called again
    set time 0.5
    #How many bytes have been received by the traffic sinks?
    for {set j 1} {$j<=$NumbSrc} { incr j } {
        set bw($j) [$tcp_sink($j) set bytes_]
    }
    #Get the current time
    set now [$ns now]
    #Calculate the bandwidth (in MBit/s) and write it to the files
    for {set j 1} {$j<=$NumbSrc} { incr j } {
        puts $f($j) "$now [expr $bw($j)/$time*8/1000000]"
    }
    #Reset the bytes_ values on the traffic sinks
    for {set j 1} {$j<=$NumbSrc} { incr j } {
        $tcp_sink($j) set bytes_ 0
    }
    #Re-schedule the procedure
    $ns at [expr $now+$time] "record"
}

$ns at 0.0 "record"

# Schedule START events for the FTP agents:
for {set i 1} {$i<=$NumbSrc} { incr i } {
    $ns at 0.1 "$ftp($i) start"
    $ns at 10.0 "$ftp($i) stop"
}

#Call the finish procedure after 10 seconds of simulation time
$ns at 10.0 "finish"
#Run the simulation
$ns run