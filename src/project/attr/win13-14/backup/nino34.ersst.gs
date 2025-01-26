'open ersst.ndjfm1949-2013.mon.ctl'
'set gxout fwrite'
'set fwrite nino34.ndjfm.ersst.1949-2013.gr'
'set x 1'
'set y 1'
iy=1
while (iy <= 65 )

'set t 'iy''
'd aave((tn+td+tj+tf+tm)/5,lon=190,lon=240,lat=-5,lat=5)'

iy=iy+1
endwhile
