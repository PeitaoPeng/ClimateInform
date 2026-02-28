'open /cpc/cfsr/archive/month_l/pgb/pgbl06.gdas.ctl'
'set gxout fwrite'
'set fwrite psi_uv.200mb.jan1981-cur.mon.cfsr.gr'
'set x 1 144'
'set y 1 73'
'set z 23'
*t=25: jan1981
*ttot=421: jan2014
ttot=458 
it=25 
while ( it <= ttot )
'set t 'it''
'd STRMprs'
'd UGRDprs'
'd VGRDprs'
it=it+1
endwhile


