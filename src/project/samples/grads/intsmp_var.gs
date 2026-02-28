* have var for intsmp
'reinit'
'open z500_intsmp_5094jul_run1_10.ctl'
'set x 1 128'
'set y 1 64'
'set gxout fwrite'
'set fwrite z500var_intsmp_5094jul_run1_10.gr'
tt=0
while(tt<=405)
nt1=tt+1
nt2=tt+45
'define var=ave(z*z,t='nt1',t='nt2')'
'd var'
*'set t 'nt1''
*'d z*z'
*
tt=tt+45
endwhile
