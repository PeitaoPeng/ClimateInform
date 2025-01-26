'open /cpc/cfsr/archive/month_l/pgb/pgbl06.gdas.ctl'
'set gxout fwrite'
'set fwrite z200.ndjfma1979-curr.mon.gdas.gr'
'set x 1 144'
'set y 1 73'
'set z 23'
'set t 1 12'
'define clim=ave(HGTprs,t+24,t=384,1yr)'
'modify clim seasonal'
'set t 1'

iy=1
while (iy <= 35 )

ir=1
while (ir <= 6 )

im=(iy-1)*12+10+ir

'set t 'im''
'd HGTprs-clim'

ir=ir+1
endwhile

iy=iy+1
endwhile
*
