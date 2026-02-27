'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/home/wd52pp/data/attr/telcon/rsd_reof.cmap.djf.'eof_range'.'mtx'.wtd.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/trd.rsd_rpc.cmap.djf.'eof_range'.'mtx'.wtd.ctl'
*'open /cpc/home/wd52pp/data/attr/telcon/rsd_eof.cmap.djf.'eof_range'.'mtx'.wtd.ctl'
*'open /cpc/home/wd52pp/data/attr/telcon/trd.rsd_pc.cmap.djf.'eof_range'.'mtx'.wtd.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
* 'draw string 4.25 10.65 REOF/RPC of DJF rsd_CMAP'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=12
nframe2=6

xmin0=0.75;  xlen=3.5;  xgap=0.3
ymax0=10.25; ylen=-1.2; ygap=-0.2
*
'define p1=-reg1'
'define p2=-reg2'
'define p3=reg3'
'define p4=reg4'
'define p5=reg5'
'define p6=reg6'
*
'define c1=-eof1'
'define c2=-eof2'
'define c3=eof3'
'define c4=eof4'
'define c5=eof5'
'define c6=eof6'
'set t 1 42'
'define cf1=-c2.2'
'define cf2=-c3.2'
'define cf3=c4.2'
'define cf4=c5.2'
'define cf5=c6.2'
'define cf6=c7.2'

'define t1=-t2.2'
'define t2=-t3.2'
'define t3=t4.2'
'define t4=t5.2'
'define t5=t6.2'
'define t6=t7.2'

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
  if(iframe >  6); ylen=-1.125; endif
  if(iframe >  6); xlen=3.5; endif
  if(iframe >  6); ygap=-0.29; endif
  if(iframe >  6); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  if(iframe = 7); titly=ymax+0.1; endif
  if(iframe = 8); titly=ymax+0.1; endif
  xstr=xmin - 0.25
  ystr=ymin + 0.58
  xstr2=xmin + 3.1
  ystr2=ymin + 1.1
  if(iframe > 6);
  xstr=xmax + 0.25
  endif
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
if(iframe < 7);
'set mproj scaled'
'set lat -30 30'
'set ylint 15'
'set lon 0 360'
'set xlint 60'
'set grid on'
*'set poli on'
*'set mpdset mres'
*'set gxout grfill'
'set xlab off'
'set ylab off'
if(iframe=6);'set xlab on';endif
*
'set gxout shaded'
'set clevs   -2.0 -1.5 -1.0 -0.5 -0.2 0.2 0.5 1. 1.5 2'
'set ccols  79 77 75 74 72 0 32 34 35 37 39'
'set cint 10'
*if(iframe = 2);'set cint 5';endif
'd p'%ieof
*'set gxout grid'
*'set gridln off'
*'set digsize 0.03'
*'set cthick 8'
*'set ccolor 300'
*if(iframe = 1); 'define cc=maskout(c1,abs(c1)-0.3)'; endif
*if(iframe = 2); 'define cc=maskout(c2,abs(c2)-0.3)'; endif
*if(iframe = 3); 'define cc=maskout(c3,abs(c3)-0.3)'; endif
*if(iframe = 4); 'define cc=maskout(c4,abs(c4)-0.3)'; endif
*if(iframe = 5); 'define cc=maskout(c5,abs(c5)-0.3)'; endif
*if(iframe = 6); 'define cc=maskout(c6,abs(c6)-0.3)'; endif
*'d skip(cc-cc,4,2)'
if(iframe=1);'/cpc/home/wd52pp/bin/hatch1.gs c1 0.3 1';endif
if(iframe=1);'/cpc/home/wd52pp/bin/hatch1.gs c1 -1 -0.3';endif
if(iframe=2);'/cpc/home/wd52pp/bin/hatch1.gs c2 0.3 1';endif
if(iframe=2);'/cpc/home/wd52pp/bin/hatch1.gs c2 -1 -0.3';endif
if(iframe=3);'/cpc/home/wd52pp/bin/hatch1.gs c3 0.3 1';endif
if(iframe=3);'/cpc/home/wd52pp/bin/hatch1.gs c3 -1 -0.3';endif
if(iframe=4);'/cpc/home/wd52pp/bin/hatch1.gs c4 0.3 1';endif
if(iframe=4);'/cpc/home/wd52pp/bin/hatch1.gs c4 -1 -0.3';endif
if(iframe=5);'/cpc/home/wd52pp/bin/hatch1.gs c5 0.3 1';endif
if(iframe=5);'/cpc/home/wd52pp/bin/hatch1.gs c5 -1 -0.3';endif
if(iframe=6);'/cpc/home/wd52pp/bin/hatch1.gs c6 0.3 1';endif
if(iframe=6);'/cpc/home/wd52pp/bin/hatch1.gs c6 -1 -0.3';endif
*if(iframe=5);'/cpc/home/wd52pp/bin/hatch1.gs c5 0.3 1';endif
*if(iframe=5);'/cpc/home/wd52pp/bin/hatch1.gs c5 -1 -0.3';endif
*if(iframe=6);'/cpc/home/wd52pp/bin/hatch1.gs c6 0.3 1';endif
*if(iframe=6);'/cpc/home/wd52pp/bin/hatch1.gs c6 -1 -0.3';endif

'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 30'
'set string 1 tc 5 90'
'set strsiz 0.12 0.12'
if(iframe = 1);'draw string 'xstr' 'ystr' REOF1'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' REOF2'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' REOF3'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' REOF4'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' REOF5'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' REOF6'; endif

'set string 1 tc 6 0'
if(iframe = 1);'draw string 'xstr2' 'ystr2' 11.6%'; endif
if(iframe = 2);'draw string 'xstr2' 'ystr2'  5.5%'; endif
if(iframe = 3);'draw string 'xstr2' 'ystr2'  4.7%'; endif
if(iframe = 4);'draw string 'xstr2' 'ystr2'  4.5%'; endif
if(iframe = 5);'draw string 'xstr2' 'ystr2'  3.5%'; endif
if(iframe = 6);'draw string 'xstr2' 'ystr2'  2.9%'; endif
endif
if(iframe > 6);
'set ylab on'
*'set xlab off'
if(iframe=12);'set xlab on';endif
'set gxout bar'
'set barbase 0'
'set vrange -3.5 3.5'
'set ylint 1.'
'set y 1'
'set x 1'
'set grid on'
'set grads off'
'set xaxis 1979 2022 5'
'set bargap 50'
*'set time jan1979 jan2022'
'set t 0 43'
'set ccolor 29'
'd maskout(cf'%ipc',cf'%ipc')'
'set ccolor 49'
'd maskout(cf'%ipc',-cf'%ipc')'
'set gxout line'
'set line 1 9 7'
'set ccolor 1'
'set cmark 0'
'set cstyle 3'
*'set cthick 7'
'd t'%ipc
'set string 1 tc 5 270'
'set strsiz 0.12 0.12'
if(iframe = 7);'draw string 'xstr' 'ystr' RPC1'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' RPC2'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' RPC3'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' RPC4'; endif
if(iframe = 11);'draw string 'xstr' 'ystr' RPC5'; endif
if(iframe = 12);'draw string 'xstr' 'ystr' RPC6'; endif
*if(iframe = 11);'draw string 'xstr' 'ystr' RPC5'; endif
*if(iframe = 12);'draw string 'xstr' 'ystr' RPC6'; endif
endif
*----------
'set string 1 tc 5 0'
if(iframe = 6);'run /cpc/home/wd52pp/bin/cbarn.gs 0.7 0 4.2 1.5';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-6

endwhile
*
'printim rsd_reof_rpc.cmap.djf.'eof_range'.'mtx'.wtd.6m.png gif x1200 y1600'
*'printim Fig2.png x1200 y1600'
