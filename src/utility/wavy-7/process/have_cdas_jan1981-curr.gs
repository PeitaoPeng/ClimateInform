'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.y1979-cur.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/wavy/hdvt.jan1981-curr.gr'
'set x 1 144'
'set y 1 73'
*t=421: Jan2014
nt=425 
nz=17

it=25
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
