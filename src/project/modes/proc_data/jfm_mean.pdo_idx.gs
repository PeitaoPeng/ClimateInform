'reinit'
'open /export-8/cacsrv1/cpc/anal/cdas/month/prs/mean/prs.grib.mean.y1949-cur.ctl'
'set gxout fwrite'
'set fwrite  /export-12/cacsrv1/wd52pp/bias_skill/data//obs.z200.tot.jfm.51-99.2x2.gr'
'set x 1 144'
'set y 1 73'
'set z 10'
'set t 1 12'
'define clim=ave(HGT,t+24,t=600,1yr)'
'modify clim seasonal'
'set t 1'
*
k=24
while(k<=600)
ks=k+1
ke=k+3
*'d ave(hgt-clim,t='ks',t='ke')'
'd ave(hgt,t='ks',t='ke')'
k=k+12
endwhile
'd ave(clim,t=1,t=3)'
*
