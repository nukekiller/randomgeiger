;
; Geiger: Read radioactive data from GMC-300E Plus geiger counter
;
; Copyright 2023 Scotch Wichmann - www.nukekiller.net
;
; +--+--+--+--+--+--+--+--+--+--+--+--+--+
;           MULTI-OS VERSION
;         SET OS_Version BELOW
; +--+--+--+--+--+--+--+--+--+--+--+--+--+
;
; see:
; http://www.gqelectronicsllc.com/download/GQ-RFC1801.txt
; https://github.com/stilldavid/gmc-300-python/blob/master/GQ-RFC1201.txt
; https://www.gqelectronicsllc.com/comersus/store/download.asp
;
; Syntax/options:
;
; geiger /dev/tty.usbserial-14210 - use /dev/tty.usbserial-14210 serial port (will vary by OS)
; geiger -q         - quiet, dont print hello or connection messages (just print data)
; geiger -r         - print raw data without any spaces between values
; geiger -b         - convert any value greater than 1 to binary equivalent (all 1's & 0's)
; geiger -l         - log data in comma-delimited format w/date: 
;                       index #
;                       yyyy-mm-dd hh:mm:ss
;                       # of particles detected since last check
;                       particle counts per current minute (CPM)
;                       avg radioactive particles detected/second since the start
; geiger -h         - help
;


; set up variables

myversion$ = "Version 1.0" ; program version number
OS_Version = 1             ; 1=Windows, 2=Linux, 3=OS X

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Global myfi = 1 ; file number
Global ourcom$ = "" ; COM port, e.g. COM3 in Windows, /dev/tty.usbserial-14210 IN OS X, etc.
retries = 0

me$ = "Scotch Wichmann - www.nukekiller.net"
DataSection
 NumericalData:
 Data.l 154, 170, 182, 187, 170, 175, 103, 158, 176, 170, 175, 180, 168, 181, 181, 103, 116, 103, 190, 190, 190, 117, 181, 188, 178, 172, 178, 176, 179, 179, 172, 185, 117, 181, 172, 187, 0 
EndDataSection
Restore NumericalData
nk$ = ""
ky = 70+1
n = -1
While n<>0
  Read.l n
  If n<>0
    nk$ = nk$ + Chr( n - ky )
  EndIf
Wend

If OS_Version = 1
  ; Windows
  nl$ = Chr(13) + Chr(10) 
  example$ = "Windows example: COM3" ; example of serial port for this OS
  help$ = " Geiger options on Windows OS: " + nl$ + nl$ + " COM3    USB serial port where geiger attached (example: COM1, COM2, etc.)" + nl$ + "   -q    Quiet mode: don't print hello or connection messages (just print data)" + nl$ + "   -r    Print raw data without any spaces in-between (useful for one-time pads)" + nl$ + "   -b    Convert any value greater than 1 to binary equivalent (all 1's & 0's)" + nl$ 
  help$ = help$ +  "   -l    Log data in comma-delimited format with these data columns:" + nl$
  help$ = help$ +  "          * Incrementing index number" + nl$
  help$ = help$ +  "          * yyyy-mm-dd hh:mm:ss" + nl$
  help$ = help$ +  "          * # of new particles detected since last geiger counter check" + nl$
  help$ = help$ +  "          * Particle counts over the current minute (CPM) (resets every 60 secs)" + nl$
   help$ = help$ + "          * Overall avg. number of particles detected/second since the start" + nl$
   help$ = help$ + nl$ + "    Examples: "
   help$ = help$ + nl$ + "        geiger -r -q COM3" 
   help$ = help$ + nl$ + "        geiger -l COM3" + nl$
  help$ = help$ + nl$ + " For a hint on which USB COM port to use, unplug the geiger," + nl$ + " then watch the Windows Device Manager while plugging the unit back in." + nl$  
ElseIf OS_Version = 2
  ; Linux
  nl$ = Chr(10)
  example$ = "Linux example: /dev/ttyUSB0" ; example of serial port for this OS
  help$ = " Geiger options on Linux: " + nl$ + nl$ + " /dev/ttyUSB0    USB serial port where geiger attached (example: /dev/ttyUSB0)" + nl$ + "              -q    Quiet mode: don't print hello or connection messages (just print data)" + nl$ + "              -r    Print raw data without any spaces in-between (useful for one-time pads)" + nl$ + "              -b    Convert any value greater than 1 to binary equivalent (all 1's & 0's)" + nl$ 
  help$ = help$ +  "              -l    Log data in comma-delimited format with these data columns:" + nl$
  help$ = help$ +  "                     * Incrementing index number" + nl$
  help$ = help$ +  "                     * yyyy-mm-dd hh:mm:ss" + nl$
  help$ = help$ +  "                     * # of new particles detected since last geiger counter check" + nl$
  help$ = help$ +  "                     * Particle counts over the current minute (CPM) (resets every 60 secs)" + nl$
   help$ = help$ + "                     * Overall avg. number of particles detected/second since the start" + nl$
   help$ = help$ + nl$ + "    Examples: "
   help$ = help$ + nl$ + "        geiger -r -q /dev/ttyUSB0" 
   help$ = help$ + nl$ + "        geiger -l /dev/ttyUSB0" + nl$
  help$ = help$ + nl$ + " For a hint on which USB /dev port to use, unplug the geiger," + nl$ + " plug it back in, then hunt for USB /dev device name as root:" + nl$ + nl$ + "          dmesg | grep USB" + nl$
Else 
  ; OS X
  nl$ = Chr(10)
  example$ = "OS X example: /dev/tty.usbserial-14210" ; example of serial port for this OS
  help$ = " Geiger options on OS X: " + nl$ + nl$ + " /dev/serialport    USB serial port where geiger attached (example: /dev/tty.usbserial-14210)" + nl$ + "              -q    Quiet mode: don't print hello or connection messages (just print data)" + nl$ + "              -r    Print raw data without any spaces in-between (useful for one-time pads)" + nl$ + "              -b    Convert any value greater than 1 to binary equivalent (all 1's & 0's)" + nl$ 
  help$ = help$ +  "              -l    Log data in comma-delimited format with these data columns:" + nl$
  help$ = help$ +  "                     * Incrementing index number" + nl$
  help$ = help$ +  "                     * yyyy-mm-dd hh:mm:ss" + nl$
  help$ = help$ +  "                     * # of new particles detected since last geiger counter check" + nl$
  help$ = help$ +  "                     * Particle counts over the current minute (CPM) (resets every 60 secs)" + nl$
   help$ = help$ + "                     * Overall avg. number of particles detected/second since the start" + nl$
   help$ = help$ + nl$ + "    Examples: "
   help$ = help$ + nl$ + "        geiger -r -q /dev/tty.usbserial-14210" 
   help$ = help$ + nl$ + "        geiger -l /dev/tty.usbserial-14210" + nl$
   
  help$ = help$ + nl$ + " For a hint on which USB /dev port to use in OS X, search the /dev folder." + nl$ + " The geiger should be listed there as a tty serial device." + nl$
EndIf

hello$ = nl$ + "Geiger: read radioactive data from GMC-300E+ geiger counter" + nl$ + myversion$ + nl$ + nl$ + "Copyright 2021 " + nk$ + nl$ + nl$ + "Run geiger -h for help" + nl$ 

help$ = hello$ + nl$ + help$



OpenConsole()

; get command line parms
datemode=0
quietmode=0
rawmode=0
binarymode=0
parms = CountProgramParameters()
If parms > 0 ; got some parms  
For x=0 To parms-1
  thisparm$ = ProgramParameter(x)
  If thisparm$ = "-h" ; help
    PrintN( help$ )
    Goto closeconsoleandexit    
  ElseIf thisparm$ = "-l"
    datemode = 1
  ElseIf thisparm$ = "-q"
    quietmode = 1
  ElseIf thisparm$ = "-r"
    rawmode = 1
  ElseIf thisparm$ = "-b"
    binarymode=1
  ElseIf FindString(thisparm$,"dev") > 0 Or FindString(UCase(thisparm$),"COM") > 0
    ourcom$ = thisparm$
  EndIf
Next x

If ourcom$ = "" 
    PrintN( nl$ +  "Error: You must specify a serial port to open. " + example$ + nl$ + "For more help, use geiger -h" + nl$  )
  Goto closeconsoleandexit  
EndIf

Else
    ; didn't get any parms
    PrintN( help$ )
    Goto closeconsoleandexit    
EndIf


; procedure to open serial port ourcom$
Procedure openSerial() 
  If OpenSerialPort(myfi, ourcom$, 57600, #PB_SerialPort_NoParity, 8, 1, #PB_SerialPort_NoHandshake, 1024, 1024)
      ProcedureReturn 1
    Else
      ProcedureReturn 0
  EndIf
EndProcedure  

; procedure to cancel geiger counter heartbeat
Procedure cancelHeartBeat()
 WriteSerialPortString(myfi,"<HEARTBEAT0>>",#PB_Ascii)
 result = 1
 While result <> 0
    result = AvailableSerialPortOutput(myfi)
    Delay(1000)
  Wend  
EndProcedure

; procedure to start geiger heartbeach
Procedure startHeartbeat()
 WriteSerialPortString(myfi,"<HEARTBEAT1>>",#PB_Ascii)
 result = 1
 While result <> 0
    result = AvailableSerialPortOutput(myfi)
    Delay(1000)
 Wend  
EndProcedure


; print hello
If quietmode <> 1
  PrintN( hello$  )
EndIf


; open serial port
If openSerial() = 1
  If quietmode = 0
    PrintN( "Opened "+ourcom$+" serial port to geiger counter successfully")
  EndIf
Else
  PrintN( nl$ + "Error: Could not open "+ourcom$+" serial port to geiger counter")
  Goto bye
EndIf

; cancel heartbeat
cancelHeartBeat()

; get H/W version
WriteSerialPortString(myfi,"<GETVER>>",#PB_Ascii)
While result <> 0
  result = AvailableSerialPortOutput(myfi)
  Delay(2000)  
Wend
  
result=0
For x=1 To 10
  Delay(1000)
  result = AvailableSerialPortInput(myfi) 
  If result > 0
      Break
  EndIf
Next x
  
If result=0
  PrintN( nl$ + "Error: Unable to geiger counter model information")
  Goto bye
EndIf
 
Dim filebytes.b(result)
buf$=""
ReadSerialPortData(myfi,@filebytes(0),result)     
For x=0 To result
  buf$ = buf$ + Chr(filebytes.b(x))
Next x

If quietmode = 0
  PrintN( buf$ + " hardware detected" + nl$ + "Each number below is the number of particles detected since last check"  + nl$ + "Press any key to quit" + nl$ )  
EndIf


pings_since_start = 0
times_detected = 0
total_secs_elapsed.q = 0
avg_cpm_pings.f = 0
zero_seconds.q =  ElapsedMilliseconds()

startheartbeat:

startHeartBeat()

; get start time
StartTime.q = ElapsedMilliseconds()

 ; begin listening for heartbeats    
    
bigbuf$ = ""
noresult = 0
cpm$ = ""
ping_count = 0

listenmore: ; start listening loop
    
Delay(1000) ; give geiger time to analyze
 
; if COM stopped talking, try to detect it
noresult = noresult + 1 
If noresult > 10        ; no communication for 10 seconds
    
    retries = retries + 1 ; tracking number of times we've restarted COM port
    If retries > 10
      PrintN( nl$ + "Error: Lost connection to "+ourcom$+" serial port too many times. Check geiger counter and cable to make sure they are functioning properly.");
      Goto bye
    EndIf
    
   ; COM port may have dropped -- let's start over
   CloseSerialPort(myfi) ; close cleanly
   Delay(1000)
   
   ; re-open serial port
  If openSerial() <> 1
    PrintN( nl$ + "Error: Lost connection to "+ourcom$+" serial port.")
    Goto bye
  EndIf
  
  ; cancel previous hearbeat, if any
  cancelHeartBeat()
  Delay(1000)
  
 ; PrintN("*********** COM PORT DROPPED. RESTARTING."); // disable for Prod
  
  Goto startHeartbeat ; start loop over

EndIf
 

; check for key presses
 keypressed$ = Inkey()
 If keypressed$ <> ""
   PrintN("")
   Goto donelistening
 EndIf
 
 ; look for radiation data
 result=0
 result = AvailableSerialPortInput(myfi) 
 If result = 0
   Goto listenmore  
 EndIf
 
 Dim filebytes.b(result)
 ReadSerialPortData(myfi,@filebytes(0),result)
 
 For x=1 To result-1 ; skip the first byte -- CPM is second byte
       bigbuf$ = bigbuf$ + Str( filebytes(x) ) 
 Next x
 
 ; print output if we didn't get garbage
 If Len(bigbuf$) < 4
   
   times_detected = times_detected + 1 ; how many times we detected any ping at all, e.g, sessions
   
   If binarymode = 1 And Val(bigbuf$) > 1
      z.q = ValD(bigbuf$)
      bigbuf$ =  Bin(z.q) 
    EndIf
    
    If datemode = 1
      
      ; if in date mode, print date, pings, and CPM
      ping_count = ping_count + ValD(bigbuf$) ; increment CPM ping_count with last number of pings detected 
      cpm$ = Str( ping_count ) ; format CPM
      
      ; calculate total pings over our elapsed time (#/second avg)
      pings_since_start = pings_since_start + ValD(bigbuf$) 
      total_secs_elapsed = (ElapsedMilliseconds() - zero_seconds)/1000 
      avg_cpm_pings.f = ( pings_since_start / total_secs_elapsed  )    
   
      ;;;;;;PrintN( Str(pings_since_start ) + " pings over " + Str(total_secs_elapsed) + " seconds")
      
      elapsed_ms = ElapsedMilliseconds() - StartTime ; if a minute has gone by, restart the CPM clock
      If elapsed_ms >= 60000 ; 60 secs       
        ping_count = 0 ; start over
        StartTime.q = ElapsedMilliseconds() ; start over
      EndIf
      
      PrintN(  FormatDate( Str(times_detected) + ",%yyyy-%mm-%dd %hh:%ii:%ss,",Date()) + bigbuf$ + "," + cpm$ + "," + FormatNumber(avg_cpm_pings,3) )
      
      
    Else
      
    
       Print( bigbuf$  )
   
       If rawmode = 0
         Print(" ")
       EndIf
       
     EndIf
   
   noresult = 0 ; reset noresult counter
   retries = 0; reset
 EndIf
 
 bigbuf$ = ""
 z=0
 FreeArray(filebytes())
 
 Goto listenmore ; loop again
 

donelistening:

bye:

CloseSerialPort(myfi)

closeconsoleandexit:

CloseConsole()

quit:
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; ExecutableFormat = Console
; CursorPosition = 3
; Folding = -
; EnableXP
; Executable = geiger.exe