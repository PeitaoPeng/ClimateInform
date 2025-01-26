icmon=may
nt=41
its=3
'reinit'
'set display color white'
'run /cpc/home/wd52pp/bin/rgbset.gs'
'open /cpc/home/wd52pp/data/nn/empr/nino34.hadoi.dec1979-feb2021.djf.ctl'
*'open /cpc/home/wd52pp/data/nn/empr/nino34.hadoi.dec1979-feb2021.djf.random.ctl'
 'open /cpc/home/wd52pp/data/nn/empr/mlp.djf.grdsst_2_n34.'icmon'_ic.ctl'
*'open /cpc/home/wd52pp/data/nn/empr/mlp.djf.grdsst_2_n34.'icmon'_ic.tmarch.ctl'
'define stdo=sqrt(ave(o*o,t='its',t='nt'))'
'define stdp=sqrt(ave(p.2*p.2,t='its',t='nt'))'
'define op=ave(o*p.2,t='its',t='nt')'
'define acop=op/(stdo*stdp)'
'define rmsop=sqrt(ave((o-p.2)*(o-p.2),t='its',t='nt'))'
