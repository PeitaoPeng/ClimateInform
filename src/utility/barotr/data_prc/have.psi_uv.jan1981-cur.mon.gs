'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.y1979-cur.ctl'
'set gxout fwrite'
'set fwrite psi_uv.200mb.jan1981-cur.mon.gr'
'set x 1 144'
'set y 1 73'
'set z 10'
*t=25: jan1981
*ttot=421: jan2014
ttot=423 
it=25 
while ( it <= ttot )
'set t 'it''
'd STRM'
'd UGRD'
'd VGRD'
it=it+1
endwhile


