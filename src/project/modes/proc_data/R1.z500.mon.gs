var=HGT
'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.y1949-cur.ctl'
*
'set gxout fwrite'
*'set fwrite /cpc/consistency/telecon/R1.z500.jan1950-dec2020.gr'
 'set fwrite /cpc/consistency/telecon/R1.z500.jan1949-dec2021.gr'
*'set fwrite /cpc/consistency/telecon/R1.z500.jan1950-jun2022.gr'
'set x 1 144'
'set y 1 73'
'set z 6'
*
*mon=13
mon=1
while(mon<=876)
'set t 'mon''
'd 'var''
*
mon=mon+1
endwhile
*
