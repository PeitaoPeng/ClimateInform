'open /cpc/home/wd52pp/data/obs/sst/sst.had-oi.jan1949-jan2015.anom.ctl'
'set gxout fwrite'
'set fwrite oisst.ndjfm1949-2013.mon.gr'
*'set fwrite oisst.ndjfm1957-2013.mon.gr'
'set x 1 360'
'set y 1 180'
'set t 1'

iy=1
*iy=9
while (iy <= 65 )

ir=1
while (ir <= 5 )

im=(iy-1)*12+10+ir

'set t 'im''
'd sst'

ir=ir+1
endwhile

iy=iy+1
endwhile
*
