* have int_smp by "z-esm' for each run then cat them together
run=1
while(run<=12)
'reinit'
'open prcp_5094jfm.run'run'.ctl'
'open prcp_5094jfm.esm.ctl'
'set gxout fwrite'
'set fwrite r'run''
'set x 1 128'
'set y 1 64'
tt=1
while(tt<=45)
'set t 'tt''
'd z-z.2'
tt=tt+1
endwhile
*
run=run+1
endwhile
