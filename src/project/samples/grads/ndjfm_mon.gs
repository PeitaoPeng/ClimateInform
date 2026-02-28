* have ndjfm monthly for each run
var=z500
nrun=12
'reinit'
'open 'var'_5094.run'nrun'.ctl'
'set gxout fwrite'
'set fwrite 'var'_5094_ndjfm_mon.run'nrun'.gr'
'set x 1 128'
'set y 1 64'
'set t 1 12'
* clim 50-94
'define clim=ave(z,t+0,t=540,1yr)'
'modify clim seasonal'
'set t 1'
*
'set t 1 3'
'd z-clim'
k=10
while(k<=526)
ks=k+1
ke=k+5
'set t 'ks' 'ke''
'd z-clim'
k=k+12
endwhile
'set t 539 540'
'd z-clim'
*
* write out ndjfm mon clim 
'set t 11 15'
'd clim'
*
