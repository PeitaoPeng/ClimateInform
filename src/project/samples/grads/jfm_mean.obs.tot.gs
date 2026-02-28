'reinit'
'open /export-8/cacsrv1/cpc/anal/cdas/month/prs/mean/prs.grib.mean.y1949-cur.ctl'
'set gxout fwrite'
'set fwrite  /export-12/cacsrv1/wd52pp/bias_skill/obs.z200.jfm.50-99.2x2.gr'
'set x 1 144'
'set y 1 73'
'set z 10'
'set t 1 12'
'define clim=ave(HGT,t+12,t=600,1yr)'
'modify clim seasonal'
'set t 1'
*
k=12
while(k<=600)
ks=k+1
ke=k+3
'd ave(hgt-clim,t='ks',t='ke')'
k=k+12
endwhile
'd ave(clim,t=1,t=3)'
*
