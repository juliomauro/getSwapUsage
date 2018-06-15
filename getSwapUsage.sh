
#!/bin/bash
# Show which are the PID using SWAP space 
# Julio Cesar Mauro

SUM=0
TOTAL=0

for DIR in `find /proc/ -maxdepth 1 -type d | egrep "^/proc/[0-9]"` ; do
        PID=`echo $DIR | cut -d / -f 3`
        PROGNAME=`ps -p $PID -o comm --no-headers`
        for SWAP in `grep Swap $DIR/smaps 2>/dev/null| awk '{ print $2 }'`
                do
                        let SUM=$SUM+$SWAP
                done
        echo "PID=$PID - Swap usage: $SUM - ($PROGNAME )" >> /tmp/get_swap.txt
        let TOTAL=$TOTAL+$SUM
        SUM=0
done
cat /tmp/get_swap.txt | sort -n -k 5 | grep -i --color "Swap usage"
\rm -rf /tmp/get_swap.txt
