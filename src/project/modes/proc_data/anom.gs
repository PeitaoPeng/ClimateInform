'open /export-12/cacsrv1/wd52pp/bias_skill/data/obs.z200.tot.jfm.51-99.ctl'
'set gxout fwrite'
'set fwrite /export-12/cacsrv1/wd52pp/bias_skill/data/obs.z200.a_c.jfm.51-99.gr'
'set x 1 128'
'set y 1 64'
'set t 1'
'define clim=ave(z,t=1,t=49)'
*
k=1
while(k<=49)
'set t 'k''
'd z-clim'
k=k+1
endwhile
'd clim'
'd sqrt(ave((z-clim)*(z-clim),t=1,t=49))'
*
