'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.clim.y1981-2010.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/wavy/hdvt.1981-2010clim.gr'
'set x 1 144'
'set y 1 73'
it=1
nt=12
nz=17
while ( it <= nt )
'set t 'it''

iz=1
while ( iz <= nz )
'set z 'iz''
'd HGT'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd RELD'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd RELV'
iz=iz+1
endwhile

'set z 1'
'd TMP'

it=it+1
endwhile
*
