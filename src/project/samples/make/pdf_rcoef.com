open /export-6/cacsrv1/wd52pp/echam/pdf_rcoef_5094d_j_f_m.run1_10.ctl
open /export-6/cacsrv1/wd52pp/echam/pdf_rcoef_intsmp_5094d_j_f_m.run1_10.ctl
 reset
 enable print  meta.cor
*===========================
set y 1
set x 1 32
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4 10.5 echam pdf_PNA_coef (NH Z500 5094djfm)
set strsiz 0.15 0.15
draw string 2.1 7.5 %
draw string 2.1 4.5 %
********
set t 1
set vpage 1. 7. 6 9
set grads off
set gxout bar
set bargap 50
set barbase 0
set xaxis -80 80 20
set yaxis 0 12 2
set axlim 0 12
d pdft*100
draw string 1 7.5 %
draw string 4 6 amplitude
draw title tot (`3s`0=25.0)
********
set t 2
set vpage 1. 7. 3 6
set grads off
set gxout bar
set bargap 50
set barbase 0
set xaxis -80 80 20
set yaxis 0 12 2
set axlim 0 12
d pdft.2*100
draw title int (`3s`0=18.6)
********
set vpage 1. 7. 0.9 3
set grads off
set gxout bar
set bargap 50
set barbase 0
set xaxis -80 80 20
set axlim -4 2
set yaxis -4 2 2
d (pdft(t=1)-pdft.2(t=2))*100
draw title tot-int
print
c
********
reset
*disable print
