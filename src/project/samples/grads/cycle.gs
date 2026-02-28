* have w and w/o seasonal cycle z500 for 51-94 monthly data
'reinit'
'open z500_5194.esm.reg.ctl'
'set gxout fwrite'
'set fwrite z500_5194.esm.nocycle.gr'
'set x 1 72'
'set y 1 37'
'set t 1 12'
* clim 51-94
'define clim=ave(z,t+0,t=528,1yr)'
'modify clim seasonal'
'set t 1 528'
'd z-clim'
*
'reinit'
'open z500_5194.esm.reg.ctl'
'set gxout fwrite'
'set fwrite z500_5194.esm.cycle.gr'
'set x 1 72'
'set y 1 37'
'define clim=ave(z,t=1,t=528)'
'set t 1 528'
'd z-clim'
*
