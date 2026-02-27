'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/home/wd52pp/data/attr/telcon/corr.cmaprsd_rpc_vs_cmap.djf.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/corr.cmaprsd_rpc_vs_s200.djf.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/wvflx.tn.regr1.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/wvflx.tn.regr2.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/wvflx.tn.regr3.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/wvflx.tn.regr4.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/wvflx.tn.regr5.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/wvflx.tn.regr6.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
* 'draw string 4.25 10.75 DJF S200 vs CMAP RSD_RPC'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=6
nframe2=3

xmin0=0.6;  xlen=4.9;  xgap=0.1
ymax0=8.25; ylen=-2.5; ygap=-0.05
*
'define p1=reg1'
'define p2=-reg2'
'define p3=reg3'
'define p4=reg4'
'define p5=reg5'
'define p6=reg6'
'define s1=reg1.2/500000'
'define s2=-reg2.2/500000'
'define s3=reg3.2/500000'
'define s4=reg4.2/500000'
'define s5=reg5.2/500000'
'define s6=reg6.2/500000'
'define c1=cor1.2/500000'
'define c2=-cor2.2/500000'
'define c3=cor3.2/500000'
'define c4=cor4.2/500000'
'define c5=cor5.2/500000'
'define c6=cor6.2/500000'
'define u1=skip(xflx.3,2,2)'
'define v1=skip(yflx.3,2,2)'
'define u2=skip(xflx.4,2,2)'
'define v2=skip(yflx.4,2,2)'
'define u3=skip(xflx.5,2,2)'
'define v3=skip(yflx.5,2,2)'
'define u4=skip(xflx.6,2,2)'
'define v4=skip(yflx.6,2,2)'
'define u5=skip(xflx.7,2,2)'
'define v5=skip(yflx.7,2,2)'
'define u6=skip(xflx.8,2,2)'
'define v6=skip(yflx.8,2,2)'

'set t 1'
*
iframe=1
ieof=1
ipc=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
* if(iframe >  5); ylen=-1.2; endif
* if(iframe >  4); xlen=3.5; endif
* if(iframe >  5); ygap=-0.2; endif
* if(iframe >  5); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
* if(iframe = 6); titly=ymax+0.1; endif
* if(iframe = 7); titly=ymax+0.1; endif
  xstr=xmin+0.
  ystr=ymax + 0.05
  if(iframe > 6);
  xstr=xmax + 0.25
  endif
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
if(iframe < 7);
*'set mproj scaled'
'set lat -45 90'
*'set vrange -45 90'
'set ylint 30'
'set lon 0 360'
'set xlint 60'
'set grid on'
*'set poli on'
*'set mpdset mres'
*'set gxout grfill'
'set xlab off'
'set ylab off'
if(iframe=3);'set xlab on';endif
if(iframe=6);'set xlab on';endif
if(iframe<=3);'set ylab on';endif
*
'set gxout shaded'
'set clevs  -2.5 -2.0 -1.5 -1.0 -0.5 -0.2 0 0.2 0.5 1. 1.5 2 2.5'
'set ccols  79 78 77 75 74 73 71 31 33 34 35 37 38 39'
'd p'%ieof
'set gxout contour'
'set cint 1'
if(iframe=1);'set cint 3'; endif
'd s'%ieof
'set gxout vector'
if(iframe=1)
'set arrscl 0.5 20'
'set arrowhead 0.05'
'set ccolor 8'
'define u=u'%ieof
'define v=v'%ieof;
'd maskout(u,sqrt(u*u+v*v)-1.);maskout(v,sqrt(u*u+v*v)-1.)'
endif
if(iframe>1)
'set arrscl  0.5 2'
'set arrowhead 0.05'
'set ccolor 8'
'define u=u'%ieof
'define v=v'%ieof
if(iframe=3)
'd maskout(u,sqrt(u*u+v*v)-0.10);maskout(v,sqrt(u*u+v*v)-0.10)';
endif
if(iframe=2)
'd maskout(u,sqrt(u*u+v*v)-0.20);maskout(v,sqrt(u*u+v*v)-0.20)';
endif
if(iframe>3)
'd maskout(u,sqrt(u*u+v*v)-0.20);maskout(v,sqrt(u*u+v*v)-0.20)';
endif
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -45 180 90'
'set string 1 tl 5 0'
'set strsiz 0.13 0.13'
if(iframe = 1);'draw string 'xstr' 'ystr' a)NINO34'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)rsd_RPC1'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' c)rsd_RPC2'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' d)rsd_RPC3'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' e)rsd_RPC4'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' f)rsd_RPC5'; endif
endif
*----------
'set string 1 tc 5 0'
*if(iframe = 6);'run /cpc/home/wd52pp/bin/cbarn.gs 0.75 0 5.5 0.25';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-3

endwhile
*
'printim regr.cmaprsd_rpc.vs.s200.png gif x800 y600'
