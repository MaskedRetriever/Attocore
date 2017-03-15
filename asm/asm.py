#!/bin/python
import sys

def bits8(val):
    return(str((val/128)%2)+str((val/64)%2)+str((val/32)%2)+str((val/16)%2)+str((val/8)%2)+str((val/4)%2)+str((val/2)%2)+str(val%2))

fp = open(sys.argv[-1])
romout = open("rom.txt","w")

regdict={"r5":"0101","r6":"0110"}

jmpdict={}
pc=0
for line in fp:
    line = line.split(":")
    if len(line)>1:
        jmpdict.update({line[0]:pc})
    line = line[-1]
    cmd = line.split()
    if len(cmd)==0:
        cmd=""
    else:
        cmd=cmd[0]

    if cmd == "NOOP":
        romout.write("00000000\n")

    if cmd == "JUMP":
        target=line.split()[-1]
        if(target in jmpdict):
            romout.write("01100000\n")
            romout.write(bits8(jmpdict[target]%256)+"\n")
            romout.write("01100000\n")
            romout.write(bits8(jmpdict[target]/256)+"\n")
            romout.write("01000000\n")
        else:
            print("Error: Link not found")

    if cmd == "VALSET":
        data=int(line.split()[-1])
        reg=regdict[line.split()[-2]]
        romout.write("0110"+reg+"\n")
        romout.write(bits8(data)+"\n")

    if cmd == "ADD":
        romout.write("01000000\n")
    if cmd == "SUB":
        romout.write("01000001\n")
    if cmd == "GT":
        romout.write("01000010\n")
    if cmd == "LT":
        romout.write("01000011\n")
    if cmd == "EQ":
        romout.write("01000100\n")
    if cmd == "LSHIFT":
        romout.write("01000101\n")
    if cmd == "RSHIFT":
        romout.write("01000110\n")



    pc=pc+1
print(pc)
print(jmpdict)
