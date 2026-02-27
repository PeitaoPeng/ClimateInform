'open /cpc/home/wd52pp/data/ca_proj/FV3AMIP_djf.sst_anom.yb1979.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/ca_proj/nino34.had-oi.1979-2022.djf.gr'
'set x 1 360'
'set y 1 180'
'define clm=ave(sst,t=1,t=43)'
k=1
while ( k <= 43)
'set t 'k''
'd aave(sst-clm,lon=190,lon=240,lat=-5,lat=5)'
k=k+1
endwhile
