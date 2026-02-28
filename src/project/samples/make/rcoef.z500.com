open /export-1/sgi59/wd52pp/data/obs/reanl/rsd_rcoef.z500.58_94jfm.ctl
 reset
 enable print  meta.cor
*===========================
set y 1
set x 1 37
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 5.5 8 rsd_rcoef(NH Z500 jfm 58-94)
********
set t 5
set vpage 1 5.5 5 7
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 58 94 2
d coef
draw title RPC 1 
********
set t 6
set vpage 5.5 10 5 7   
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 58 94 2
d coef
draw title RPC 2 
********
set t 7
set vpage 1 5.5 3 5  
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 58 94 2
d coef
draw title RPC 3 
********
set t 8
set vpage 5.5 10 3 5   
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 58 94 2
d coef
draw title RPC 4 
********
set t 9
set vpage 1 5.5 1 3  
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 58 94 2
d coef
draw title RPC 5 
********
set t 10
set vpage 5.5 10 1 3   
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 58 94 2
d coef
draw title RPC 6 
print
c
*----------
reset
*disable print
