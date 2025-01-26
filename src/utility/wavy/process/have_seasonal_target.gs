'open /cpc/home/wd52pp/data/wavy/hdvt.jan1981-curr.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/wavy/hdvt.mam2014.gr'
'set x 1 144'
'set y 1 73'

*it=396: dec2014
*it=348: dec2009
t1=399 
t2=400 
t3=401
*
nz=17

iz=1
while ( iz <= nz )
'set z 'iz''
'd (hgt(t='t1')+hgt(t='t2')+hgt(t='t3'))/3.'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd (div(t='t1')+div(t='t2')+div(t='t3'))/3.'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd (vor(t='t1')+vor(t='t2')+vor(t='t3'))/3.'
iz=iz+1
endwhile

'set z 1'
'd (tsfc(t='t1')+tsfc(t='t2')+tsfc(t='t3'))/3.'

