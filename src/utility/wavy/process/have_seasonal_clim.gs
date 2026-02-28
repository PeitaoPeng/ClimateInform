'open /cpc/home/wd52pp/data/wavy/hdvt.1981-2010clim.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/wavy/hdvt.clim_mam.gr'
'set x 1 144'
'set y 1 73'

it=1
nz=17

m1=3
m2=4
m3=5

'set t 'it''

iz=1
while ( iz <= nz )
'set z 'iz''
'd (hgt(t='m1')+hgt(t='m2')+hgt(t='m3'))/3.'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd (div(t='m1')+div(t='m2')+div(t='m3'))/3.'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd (vor(t='m1')+vor(t='m2')+vor(t='m3'))/3.'
iz=iz+1
endwhile

'set z 1'
'd (tsfc(t='m1')+tsfc(t='m2')+tsfc(t='m3'))/3.'
*
