* have jfm avg for each run
var=z500
run=1
while(run<=12)
'reinit'
'open 'var'_5094.run'run'.ctl'
'set gxout fwrite'
'set fwrite 'var'_5094djfm.run'run'.gr'
'set x 1 128'
'set y 1 64'
'set t 1 12'
* clim 58-94
'define clim=ave(z,t+0,t=540,1yr)'
'modify clim seasonal'
'set t 1'
'd ave(z-clim,t=1,t=3)'
*
k=11
while(k<=528)
ks=k+1
ke=k+4
'd ave(z-clim,t='ks',t='ke')'
k=k+12
endwhile
*
* write out jfm clim 
'd ave(clim,t=1,t=3)'
*
run=run+1
endwhile
