'open /cpc/home/wd52pp/data/wavy/hdvt.1981-2010clim.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/wavy/hdvt.clim_mar.gr'
'set x 1 144'
'set y 1 73'

it=3
nz=17

'set t 'it''

iz=1
while ( iz <= nz )
'set z 'iz''
'd hgt'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd div'
iz=iz+1
endwhile

iz=1
while ( iz <= nz )
'set z 'iz''
'd vor'
iz=iz+1
endwhile

'set z 1'
'd tsfc'

