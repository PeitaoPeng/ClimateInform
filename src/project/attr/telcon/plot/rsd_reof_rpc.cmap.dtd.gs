'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/home/wd52pp/data/attr/telcon/rsd_reof.cmap.djf.'eof_range'.'mtx'.dtd.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/rsd_rpc.cmap.djf.'eof_range'.'mtx'.dtd.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.65 Nino34 Regr & REOF/RPC of DJF Detrd rsd_CMAP'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=12
nframe2=6

xmin0=0.75;  xlen=3.5;  xgap=0.3
ymax0=10.25; ylen=-1.2; ygap=-0.2
*
'define p1=renso'
'define p2=-reg1'
'define p3=reg2'
'define p4=reg3'
'define p5=-reg4'
'define p6=-reg5'
*
'define c1=censo'
'define c2=-eof1'
'define c3=eof2'
'define c4=eof3'
'define c5=-eof4'
'define c6=-eof5'
'set t 1 42'
'define cf1=cf1.2'
'define cf2=-cf2.2'
'define cf3=cf3.2'
'define cf4=cf4.2'
'define cf5=-cf5.2'
'define cf6=-cf6.2'

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
  xstr2=xmin + 3.2
  ystr2=ymin + 0.20
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
'set ylint 20'
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
'set clevs  -3. -2.5 -2.0 -1.5 -1.0 -0.5 -0.2 0 0.2 0.5 1. 1.5 2 2.5 3'
'set ccols  79 78 77 76 75 74 73 71 31 33 34 35 36 37 38 39'
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

'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 30'
'set string 1 tc 5 90'
'set strsiz 0.12 0.12'
if(iframe = 1);'draw string 'xstr' 'ystr' ENSO'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' rsd_EOF1'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' rsd_EOF2'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' rsd_EOF3'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' rsd_EOF4'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' rsd_EOF5'; endif

'set string 1 tc 6 0'
if(iframe = 1);'draw string 'xstr2' 'ystr2' 40.2%'; endif
if(iframe = 2);'draw string 'xstr2' 'ystr2' 13.2%'; endif
if(iframe = 3);'draw string 'xstr2' 'ystr2' 5.8%'; endif
if(iframe = 4);'draw string 'xstr2' 'ystr2' 4.6%'; endif
if(iframe = 5);'draw string 'xstr2' 'ystr2' 3.9%'; endif
if(iframe = 6);'draw string 'xstr2' 'ystr2' 2.5%'; endif
endif
if(iframe > 6);
'set ylab on'
*'set xlab off'
if(iframe=12);'set xlab on';endif
'set gxout bar'
'set barbase 0'
'set vrange -3.0 3.0'
'set ylint 1.'
'set y 1'
'set x 1'
'set grid on'
'set grads off'
'set xaxis 1979 2020 5'
'set bargap 50'
'set t 1 42'
'set ccolor 29'
'd maskout(cf'%ipc',cf'%ipc')'
'set ccolor 49'
'd maskout(cf'%ipc',-cf'%ipc')'
'set gxout line'
'set string 1 tc 5 270'
'set strsiz 0.12 0.12'
if(iframe = 7);'draw string 'xstr' 'ystr' NINO3.4'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' rsd_PC1'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' rsd_PC2'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' rsd_PC3'; endif
if(iframe = 11);'draw string 'xstr' 'ystr' rsd_PC4'; endif
if(iframe = 12);'draw string 'xstr' 'ystr' rsd_PC5'; endif
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
'printim rsd_reof_rpc.cmap.djf.'eof_range'.'mtx'.dtd.png gif x600 y800'
