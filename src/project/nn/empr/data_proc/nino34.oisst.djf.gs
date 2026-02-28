*'open /cpc/home/wd52pp/data/nn/empr/obs.sst.djf.1979-2020.anom.ctl'
'open /cpc/home/wd52pp/data/nn/empr/obs.sst.djf.1949-2020.anom.ctl'
'set gxout fwrite'
*'set fwrite /cpc/home/wd52pp/data/nn/empr/nino34.hadoi.dec1979-feb2021.djf.gr'
'set fwrite /cpc/home/wd52pp/data/nn/empr/nino34.hadoi.dec1949-feb2021.djf.gr'
'set x 72'
'set y 37'
* have 1991-2020 clim
*'set t 1 12'
*'define clim=ave(sst,t+2,t=362,1yr)'
*'modify clim seasonal'
k=1
*while ( k <= 42)
while ( k <= 72)
'set t 'k''
'd aave(o,lon=190,lon=240,lat=-5,lat=5)'
k=k+1
endwhile
