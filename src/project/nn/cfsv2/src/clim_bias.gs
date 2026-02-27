'reinit'
nld=7
'run /cpc/home/wd52pp/bin/rgbset.gs'
'open /cpc/consistency/nn/cfsv2_ww/CFSv2.SSTem.ss.clim_std.may_ic.1982-2010.ld1-7.esm.1c.ctl'
'open /cpc/consistency/nn/cfsv2_ww/CFSv2.SSTem.ss.clim_std.may_ic.1982-2010.ld1-7.esm.2c.ctl'
'set x 1 144'
'set y 1  73'
'set gxout fwrite'
'set fwrite /cpc/consistency/nn/cfsv2_ww/CFSv2.SSTem.ss.clim_bias.1982-2010.ld1-7.gr'
ld=1
while ( ld <= nld )
'set t 'ld''
'define cd1=clm-clm1.2'
'define cd2=clm-clm2.2'
'd cd1'
'd cd2'
ld=ld+1
endwhile
