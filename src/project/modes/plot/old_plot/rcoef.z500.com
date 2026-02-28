open /export-6/cacsrv1/wd52pp/modes/rsd_rcoef.z500.5001djfm.ntd.ctl
 reset
 enable print  meta.cor
*===========================
set y 1
set x 1 52
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 5.5 8 tp_sst_rpc (1950-2001 DJFM)
********
set t 1
set vpage 1 5.5 5 7
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 1950 2001 5
d -z
draw title tp RPC 1 
********
set t 2
set vpage 5.5 10 5 7   
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 1950 2001 5
d -z
draw title tp RPC 2 
********
print
c
*----------
reset
set y 1
set x 1 52
*********
set string 1 tc 8
set strsiz 0.2 0.2
draw string 5.5 8 Z500_rsd_rpc (DJFM 1950-2001)
********
set t 3
set vpage 1 5.5 5 7
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 1950 2001 5
d z
draw title rsd_Z500 RPC 1
********
set t 4
set vpage 5.5 10 5 7   
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 1950 2001 5
d z
draw title rsd_Z500 RPC 2
********
set t 5
set vpage 1 5.5 3 5  
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 1950 2001 5
d z
draw title rsd_Z500 RPC 3 
********
set t 6
set vpage 5.5 10 3 5   
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 1950 2001 10
d z
draw title rsd_Z500 RPC 4
********
set t 7
set vpage 1 5.5 1 3  
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 1950 2001 5
d z
draw title rsd_Z500 RPC 5
********
set t 8
set vpage 5.5 10 1 3   
set grads off
set gxout bar
set bargap 30
set barbase 0.
set xaxis 1950 2001 5
d z
draw title rsd_Z500 RPC 6
print
c
*----------
