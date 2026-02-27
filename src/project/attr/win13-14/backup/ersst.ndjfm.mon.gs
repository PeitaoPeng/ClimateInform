'open ersst.jan1949-apr2014.ctl'
'set gxout fwrite'
'set fwrite ersst.ndjfma1949-2013.mon.gr'
'set x 1 180'
'set y 1  89'
'set t 1'

iy=1
while (iy <= 65 )

ir=1
while (ir <= 6 )

im=(iy-1)*12+10+ir

'set t 'im''
'd sst'

ir=ir+1
endwhile

iy=iy+1
endwhile
*
