'reinit'
'open /cpc/home/wd52pp/data/attr/djf14-15/prate.1979-2015.cmap.mon.ctl'
'open /cpc/home/wd52pp/data/attr/djf14-15/out.64x40.ctl'
'set gxout fwrite'
'set fwrite /cpc/home/wd52pp/data/attr/djf14-15/prate.1979-2015.cmap.mon.R15.gr'
nt=1
while ( nt <= 434)

'set t 'nt
say 'time='nt
'set lon    0. 354.375'
'set lat  -86.6 86.6'
'd lterp(p,p.2(t=1))'

nt=nt+1
endwhile
