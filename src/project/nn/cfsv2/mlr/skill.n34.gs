clim=1c
icmon=may
area=whole
nt=38
'reinit'
'set display color white'
'run /cpc/home/wd52pp/bin/rgbset.gs'
'open /cpc/home/wd52pp/data/nn/cfsv2/mlr.grdsst_2_n34.'icmon'_ic.1982-2020.djf.'area'.$clim.ctl'
'set x 1'
'define stdo=sqrt(ave(o*o,t=1,t='nt'))'
'define stdp=sqrt(ave(p*p,t=1,t='nt'))'
'define op=ave(o*p,t=1,t='nt')'
'define acop=op/(stdo*stdp)'
'define rmsop=sqrt(ave((o-p)*(o-p),t=1,t='nt'))'
