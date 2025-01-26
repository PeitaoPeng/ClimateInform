* have var of intsmp for each year which will be used for corr vs tpSST
'reinit'
'open z500_intsmp_5094jfm_run1_10.ctl'
'set x 1 128'
'set y 1 64'
'set gxout fwrite'
'set fwrite z500stdv_intsmp_5094jfm_run1_10.gr'
tt=1
while(tt<=45)
'define var=ave(z*z,t='tt',t=450,45)'
'd sqrt(var)'
tt=tt+1
endwhile
