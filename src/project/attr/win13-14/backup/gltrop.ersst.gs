'open ersst.ndjfm1949-2013.mon.ctl'
'set gxout fwrite'
'set fwrite gltrop.ndjfm.ersst.1949-2013.gr'
'set x 1'
'set y 1'
iy=1
while (iy <= 65 )

'set t 'iy''
'd aave((tn+td+tj+tf+tm)/5,lon=0,lon=360,lat=-20,lat=20)'

iy=iy+1
endwhile
