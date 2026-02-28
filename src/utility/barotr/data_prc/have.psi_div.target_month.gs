'open psi_div.200mb.jan1981-cur.mon.R15.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/attr/winter13-14/bminput.psi_div.200mb.mar2014.gr'
*it=397: jan2014
it=399 
'set x 1 64'
'set y 1 40'
'set t 1 12'
'define sc=ave(s,t+0,t=360,1yr)'
'define dc=ave(d,t+0,t=360,1yr)'
'modify sc seasonal'
'modify dc seasonal'
'set t 'it''
'd sc' 
'd dc' 
'd s' 
'd d' 


