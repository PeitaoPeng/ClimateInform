* have jas avg for each run
var=prcp
run=1
while(run<=12)
'reinit'
'open 'var'_5094.run'run'.ctl'
'set gxout fwrite'
'set fwrite 'var'_5894jas.run'run'.gr'
'set x 1 128'
'set y 1 64'
'set t 1 12'
* clim 58-94
'define clim=ave(z,t+96,t=540,1yr)'
'modify clim seasonal'
'set t 1'
*
k=96
while(k<=528)
ks=k+7
ke=k+9
'd ave(z-clim,t='ks',t='ke')'
k=k+12
endwhile
*
* write out jfm clim 
'd ave(clim,t=7,t=9)'
*
run=run+1
endwhile
