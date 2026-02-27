'open /cpc/analysis/cdas/bulletin/cams_opi_v0208/data/t.ctl'
'set gxout fwrite'
'set fwrite prate.ndjfm.1979-curr.mon.gr'
'set x 1 144'
'set y 1 72'
'set t 1 12'
'define clim=ave(opi,t+24,t=384,1yr)'
'modify clim seasonal'
'set t 1'

iy=1
while (iy <= 35 )

ir=1
while (ir <= 5 )

im=(iy-1)*12+10+ir

'set t 'im''
'd opi-clim'

ir=ir+1
endwhile

iy=iy+1
endwhile
*
