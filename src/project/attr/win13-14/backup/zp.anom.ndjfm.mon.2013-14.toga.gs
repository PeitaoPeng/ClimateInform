'open z200.esm.amip.para.ctl'
'open z200.esm.amip.para.toga.ctl'
'set gxout fwrite'
'set fwrite z200.ndjfm2013-14.mon.para.toga.esm.gr'
'set x 1 360'
'set y 1 181'
'set t 1 12'
'define clim=ave(z,t+288,t=648,1yr)'
'modify clim seasonal'
'set t 1'
tt=683
while(tt <= 687)
'set t 'tt''
*'d clim'
'd z.2-clim'
tt=tt+1
endwhile
