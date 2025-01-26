open /export-6/cacsrv1/wd52pp/b9x/pdf_at_pna_5094jfm.run1_12.ctl
 reset
 enable print  meta.cor
*===========================
set y 1
set x 1 24
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4 10.5 b9x pdf (Z500 at (170W-130W, 35N-55N))
set strsiz 0.15 0.15
draw string 2.1 7.5 %
********
set t 1
set vpage 1. 7. 6 9
set grads off
set gxout bar
set bargap 50
set barbase 0
set xaxis -60 60 10
set yaxis 0 14 2
set axlim 0 14
d pdft*100
draw string 1 7.5 %
draw string 4 6 amplitude
********
print
c
********
reset
*disable print
