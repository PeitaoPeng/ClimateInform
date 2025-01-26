'reinit'
'open /cpc/home/wd52pp/data/attr/djf14-15/psi_div.200mb.1979-2015.cfsr.djf.R15.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/attr/djf14-15/bminput.1979-2015.cfsr.djf.gr'
'set x 1 64'
'set y 1 40'
nt=1
while ( nt <= 36)

'set t 'nt
say 'time='nt
'd s(t=37)'
'd d(t=37)'
'd s+s(t=37)'
'd d+d(t=37)'
nt=nt+1
endwhile
