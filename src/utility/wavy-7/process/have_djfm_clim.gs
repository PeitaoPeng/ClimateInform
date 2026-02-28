'open /cpc/home/wd52pp/data/wavy/hdvt.1981-2010clim.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/wavy/hdvt.clim_djfm.gr'
'set x 1 144'
'set y 1 73'

it=1
nz=17

m1=1
m2=2
m3=3
m4=12

'set t 'it''

iz=1
while ( iz <= nz )
'set z 'iz''
'd (hgt(t='m1')+hgt(t='m2')+hgt(t='m3')+hgt(t='m4'))/4.'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd (div(t='m1')+div(t='m2')+div(t='m3')+div(t='m4'))/4.'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd (vor(t='m1')+vor(t='m2')+vor(t='m3')+vor(t='m4'))/4.'
iz=iz+1
endwhile

'set z 1'
'd (tsfc(t='m1')+tsfc(t='m2')+tsfc(t='m3')+tsfc(t='m4'))/4.'
*
