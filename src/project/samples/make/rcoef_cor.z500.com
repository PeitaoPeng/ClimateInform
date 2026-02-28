open /export-1/sgi59/wd52pp/data/echam/rcoef_cor.z500.esm.58_94jfm.ctl
 reset
 enable print  meta.cor
*===========================
set y 1
set x 1 37
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 4.0 10.8 rcoef_cor(echam NH Z500 jfm 58-94)
********
set t 1
set vpage 0 7 7.5 10.5
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 58 94 2
d coef
draw title RPC 1 
********
set t 2
set vpage 0 7  5 8     
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 58 94 2
d coef
draw title RPC 2 
********
set t 3
set vpage 0 7 2.5 5.5  
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 58 94 2
d coef
draw title RPC 3 
********
print
c
*----------
reset
