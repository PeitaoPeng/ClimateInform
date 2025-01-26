*D_J_F_M_pickup
var=z500
run=1
while(run<=12)
reinit
'open 'var'_5094.run'run'.ctl'
'set gxout fwrite'
'set fwrite 'var'_5094d_j_f_m.run'run'.i3e'
'set x 1 128'
'set y 1 64'
'set t 1 12'
* clim 50-94
'define clim=ave(z,t+0,t=540,1yr)'
'modify clim seasonal'
'set t 1'
*
k=0
while(k<=528)
k1=k+1
k2=k+2
k3=k+3
k4=k+12
'd z(t='k1')-clim(t='k1')'
'd z(t='k2')-clim(t='k2')'
'd z(t='k3')-clim(t='k3')'
'd z(t='k4')-clim(t='k4')'
k=k+12
endwhile
*
run=run+1
endwhile
