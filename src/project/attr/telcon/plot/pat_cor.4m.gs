iyr=18
ts=rsd_rpc
zonal=raw
'reinit'
'set display color white'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/telcon/z200_'iyr'.'ts'.djf.contrib.'zonal'.ctl'
'set x 1 144'
'set y 1  73'
*global corr
*
'define p8=n34+trd+c1+c2+c3+c4'
*
'define oo=sqrt(aave(obs*obs,x=1,x=144,y=1,y=73))'
'define nn=sqrt(aave(n34*n34,x=1,x=144,y=1,y=73))'
'define c11=sqrt(aave(c1*c1,x=1,x=144,y=1,y=73))'
'define c22=sqrt(aave(c2*c2,x=1,x=144,y=1,y=73))'
'define c33=sqrt(aave(c3*c3,x=1,x=144,y=1,y=73))'
'define c44=sqrt(aave(c4*c4,x=1,x=144,y=1,y=73))'
'define tt=sqrt(aave(trd*trd,x=1,x=144,y=1,y=73))'
'define pp=sqrt(aave(p8*p8,x=1,x=144,y=1,y=73))'
*
'define on=aave(obs*n34,x=1,x=144,y=1,y=73)'
'define oc1=aave(obs*c1,x=1,x=144,y=1,y=73)'
'define oc2=aave(obs*c2,x=1,x=144,y=1,y=73)'
'define oc3=aave(obs*c3,x=1,x=144,y=1,y=73)'
'define oc4=aave(obs*c4,x=1,x=144,y=1,y=73)'
'define ot=aave(obs*trd,x=1,x=144,y=1,y=73)'
'define op=aave(obs*p8,x=1,x=144,y=1,y=73)'
*
'define con=on/(oo*nn)'
'define coc1=oc1/(oo*c11)'
'define coc2=oc2/(oo*c22)'
'define coc3=oc3/(oo*c33)'
'define coc4=oc4/(oo*c44)'
'define cot=ot/(oo*tt)'
'define cop=op/(oo*pp)'
