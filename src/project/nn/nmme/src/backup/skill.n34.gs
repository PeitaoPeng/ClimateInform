icmon=may
nino=n34
nt=38
'reinit'
'set display color white'
'run /cpc/home/wd52pp/bin/rgbset.gs'
'open /cpc/home/wd52pp/data/nn/nmme/input_'nino'.'icmon'_ic.1982-2019.djf.ctl'
'open /cpc/home/wd52pp/data/nn/nmme/mlp.djf.'nino'.'icmon'_ic.ctl'
'set x 1'
'define stdo=sqrt(ave(n34(x=2)*n34(x=2),t=1,t='nt'))'
'define stda=sqrt(ave(n34(x=1)*n34(x=1),t=1,t='nt'))'
'define stdp=sqrt(ave(p.2*p.2,t=1,t='nt'))'
'define oa=ave(n34(x=2)*n34(x=1),t=1,t='nt')'
'define op=ave(n34(x=2)*p.2,t=1,t='nt')'
'define acoa=oa/(stdo*stda)'
'define acop=op/(stdo*stdp)'
'define rmsoa=sqrt(ave((n34(x=2)-n34(x=1))*(n34(x=2)-n34(x=1)),t=1,t='nt'))'
'define rmsop=sqrt(ave((n34(x=2)-p.2)*(n34(x=2)-p.2),t=1,t='nt'))'
