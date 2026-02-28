'open /home/peitao/data/tpz/prec.1948_cur.mon.1x1.ctl'
'set gxout fwrite'
'set fwrite /home/peitao/data/tpz/prec.48-cur.ndjfm.gr'
'set x 1 360'
'set y 1 180'
*'set t 1 12'
* clim calculation
*'define clim=ave(prec,t+516,t=876,1yr)'
*'modify clim seasonal'
*'set t 1'
*ndjfm of 1948/49-2022/23
k=10
while(k<=900)
ks=k+1
ke=k+5
*'d ave(sst-clim,t='ks',t='ke')'
'd ave(prec,t='ks',t='ke')'
k=k+12
endwhile
