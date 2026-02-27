'open /cpc/home/wd52pp/data/wavy/hdvt.jan1981-curr.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/wavy/hdvt.mar2014.gr'
'set x 1 144'
'set y 1 73'

*it=398: feb2014
it=399 
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

