var=HGT
'open /cpc/analysis/cdas/month/prs/mean/prs.grib.mean.y1949-cur.ctl'
*
'set gxout fwrite'
*'set fwrite /cpc/consistency/telecon/R1.z500.jan1949-dec2021.std_cos.gr'
'set fwrite /cpc/consistency/telecon/R1.z500.jan1949-dec2001.std_cos.gr'
'set lon 0 357.5'
'set lat -90 90'
'set z 6'
'define rad = 3.14159/180'
*
*totmon = 864
 totm = 624
 totmp = totm + 12
*
'set t 1 12'
'define clm=ave('var',t+12,t='totm',12)'
'modify clm seasonal'
'define vv=ave(pow('var'-clm,2),t+12,t='totm',12)'
'modify vv seasonal'
'set t 1'
mon=1
while(mon<=totmp)
'set t 'mon''
'd ('var'-clm)*sqrt(cos(lat*rad))/sqrt(vv)'
*
mon=mon+1
endwhile
*
