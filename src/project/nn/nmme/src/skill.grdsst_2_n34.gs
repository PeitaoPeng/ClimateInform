icmon=may
nt=38
area=whole
*area=NWTP
'reinit'
'set display color white'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*'open /cpc/home/wd52pp/data/nn/nmme/nino34.oi.dec1982-feb2020.djf.ctl'
'open /cpc/home/wd52pp/data/nn/nmme/nino34.oi.1982-2020.djf.ctl'
'open /cpc/home/wd52pp/data/nn/nmme/NMME.nino34.'icmon'_ic.1982-2019.djf.ctl'
'open /cpc/home/wd52pp/data/nn/nmme/mlp.djf.grdsst_2_n34.'icmon'_ic.'area'.ctl'
'set x 1'
'define stdo=sqrt(ave(o*o,t=1,t='nt'))'
'define stdf=sqrt(ave(f.2*f.2,t=1,t='nt'))'
'define stdp=sqrt(ave(p.3*p.3,t=1,t='nt'))'
'define of=ave(o*f.2,t=1,t='nt')'
'define op=ave(o*p.3,t=1,t='nt')'
'define acof=of/(stdo*stdf)'
'define acop=op/(stdo*stdp)'
'define rmsof=sqrt(ave((o-f.2)*(o-f.2),t=1,t='nt'))'
'define rmsop=sqrt(ave((o-p.3)*(o-p.3),t=1,t='nt'))'
