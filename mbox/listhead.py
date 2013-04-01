#! /usr/bin/env python

import os
import sys

heads = []

try:
    mbox = sys.argv[1]
    hname = sys.argv[2]
    indat = open(mbox, 'r')
except:
    print "<script> <mbox> <header>"
    sys.exit()

hname = hname.lower()
flag = 1
chead = ''
for cline in indat.readlines():
    cline = cline.rstrip()
    if flag == 1:
        if cline[0:7] == 'From - ':
            flag = 0
    else:
        if chead != '':
            if cline[0] == ' ' or cline[0] == "\t":
                chead += " " + cline[1:]
            else:
                heads.append(chead)
                chead = ''
                flag = 1
        elif cline.lower().find(hname) == 0:
            chead = cline

indat.close()

for cline in heads:
    print cline


