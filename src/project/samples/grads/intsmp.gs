* have int_smp by "z-esm' for each run then cat them together
run=1
while(run<=12)
'reinit'
'open z500_5094jfm.run'run'.ctl'
'open z500_5094jfm.esm.ctl'
'set gxout fwrite'
'set fwrite r'run''
'set x 1 128'
'set y 1 64'
'set t 1 45'
'd z+z(t=46)-(z.2+z.2(t=46))'
*
run=run+1
endwhile
