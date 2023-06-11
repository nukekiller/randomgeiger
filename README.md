# randomgeiger
Generate random data streams from a GMC-300E Plus geiger counter using PureBasic

Set the OS_Version in the source code, then compile into a PowerBasic executable to use.

Here are runtime instructions for Windows (OS X and Linux instructions will vary):

Run geiger -h for help

 COM3    USB serial port where geiger attached (example: COM1, COM2, etc.)
   -q    Quiet mode: don't print hello or connection messages (just print data)
   -r    Print raw data without any spaces in-between (useful for one-time pads)
   -b    Convert any value greater than 1 to binary equivalent (all 1's & 0's)
   -l    Log data in comma-delimited format with these data columns:
          * Incrementing index number
          * yyyy-mm-dd hh:mm:ss
          * # of new particles detected since last geiger counter check
          * Particle counts over the current minute (CPM) (resets every 60 secs)
          * Overall avg. number of particles detected/second since the start

    Examples:
        geiger -r -q COM3
        geiger -l COM3

 For a hint on which USB COM port to use, unplug the geiger,
 then watch the Windows Device Manager while plugging the unit back in.
 
