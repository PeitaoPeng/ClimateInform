reinit
'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.y1979-cur.ctl'
*
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/skill_ac/z200.3mon.fma1981-jfm2021.cdas.gr'
'set x 1 144'
'set y 1  73'
'set z 10'
* have 1981-2010 clim
'set t 1 12'
'define clim=ave(hgt,t+24,t=499,1yr)'
'modify clim seasonal'
'set t 25 498'
'd ave(hgt-clim,t-1,t+1)'
