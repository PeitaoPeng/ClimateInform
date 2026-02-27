'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.y1949-cur.ctl'
'set gxout fwrite'
'set fwrite z200.ndjfma1949-curr.mon.gr'
'set x 1 144'
'set y 1 73'
'set z 10'
'set t 1 12'
'define clim=ave(hgt,t+0,t=785,1yr)'
'modify clim seasonal'
'set t 1'

iy=1
while (iy <= 65 )

ir=1
while (ir <= 6 )

im=(iy-1)*12+10+ir

'set t 'im''
'd hgt-clim'

ir=ir+1
endwhile

iy=iy+1
endwhile
*
