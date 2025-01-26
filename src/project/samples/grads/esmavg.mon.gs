*
k=1
while(k<=12)
'open z500_5094.run'k'.ctl'
k=k+1
endwhile
'set gxout fwrite'
'set fwrite z500_5094.esm.gr'
'set x 1 128'
'set y 1 64'
'set t 1 540'
'd (z+z.2+z.3+z.4+z.5+z.6+z.7+z.8+z.9+z.10+z.11+z.12)/12.'
*
