#! /bin/sh


mkdir thumb/$1
find orig/$1 -iname "*.JPG" | awk '{print "convert -geometry 200x150",$1,"s" $1 }' | sed s/sorig/thumb/ > mkthumb.cmd
/bin/sh mkthumb.cmd
rm -f mkthumb.cmd
find orig/$1 -iname "*.JPG"|awk '{print "<a href=\"" $1 "\"><img src=\"s" $1 "\"></a>"}'|sed s/sorig/thumb/ > $1.html

