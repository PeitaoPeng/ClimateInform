'open /export/lnx258/bjha/peng/mmodel/gfdlv2.z200.tot.ens.ctl'
'set gxout fwrite'
'set fwrite /export-12/cacsrv1/wd52pp/bias_skill/data/gfdlv2.z200.tot.jfm.51-99.gr'
'set x 1 128'
'set y 1 64'
'set t 1 12'
'define clim=ave(z,t+0,t=576,1yr)'
'modify clim seasonal'
'set t 1'
*
k=0
while(k<=576)
ks=k+1
ke=k+3
*'d ave(z-clim,t='ks',t='ke')'
'd ave(z,t='ks',t='ke')'
k=k+12
endwhile
*'d ave(clim,t=1,t=3)'
*
