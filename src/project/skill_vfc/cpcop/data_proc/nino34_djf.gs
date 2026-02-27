'open nino34_3mon.jfm50-jja07.ctl'
var=z
'set gxout fwrite'
'set fwrite nino34.73-07djf.gr'
'set x 1'
'set y 1'
'set t 1'
k=276
while(k<=684)
'set t 'k''
'd 'var''
k=k+12
endwhile
*
* write out djfm clim 
*'d ave(clim,t=12,t=15)'
