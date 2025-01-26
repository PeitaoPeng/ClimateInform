'open sst.para.ctl'
'open sst.para.toga.ctl'
'set gxout fwrite'
'set fwrite sst.ndjfm2013-14.mon.toga.gr'
'set x 1 360'
'set y 1 181'
'set t 1 12'
'define clim=ave(sst,t+0,t=684,1yr)'
'modify clim seasonal'
'set t 1'

iy=57

ir=1
while (ir <= 5 )

im=(iy-1)*12+10+ir

'set t 'im''
'd sst.2-clim'

ir=ir+1
endwhile

