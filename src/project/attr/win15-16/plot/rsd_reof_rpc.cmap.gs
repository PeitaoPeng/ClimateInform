'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/home/wd52pp/data/attr/win15-16/rsd_reof.cmap.djf.'eof_range'.'mtx'.ctl'
'open /cpc/home/wd52pp/data/attr/win15-16/rsd_rpc.cmap.djf.'eof_range'.'mtx'.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.65 Nino34 Regr & REOF/RPC of DJF Detrd rsd_CMAP'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=10
nframe2=5

xmin0=0.75;  xlen=3.5;  xgap=0.1
ymax0=10.25; ylen=-1.2; ygap=-0.2
*
'define p1=renso'
'define p2=reg1'
'define p3=reg2'
'define p4=reg3'
'define p5=-reg4'
'define p6=reg5'
'set t 1 41'
'define cf1=cf1.2'
'define cf2=cf2.2'
'define cf3=cf3.2'
'define cf4=cf4.2'
'define cf5=-cf5.2'
'define cf6=cf6.2'

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
  if(iframe >  5); ylen=-1.2; endif
  if(iframe >  4); xlen=3.5; endif
  if(iframe >  5); ygap=-0.2; endif
  if(iframe >  5); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  if(iframe = 6); titly=ymax+0.1; endif
  if(iframe = 7); titly=ymax+0.1; endif
  xstr=xmin - 0.0
  ystr=ymin + 0.65
  if(iframe > 5);
  xstr=xmax + 0.25
  endif
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
if(iframe < 6);
*'set mproj scaled'
'set lat -60 60'
'set ylint 20'
'set lon 0 360'
'set xlint 60'
'set grid on'
*'set poli on'
*'set mpdset mres'
*'set gxout grfill'
'set xlab off'
'set ylab off'
if(iframe=5);'set xlab on';endif
*
'set gxout shaded'
'set clevs  -3. -2.5 -2.0 -1.5 -1.0 -0.5 -0.2 0.2 0.5 1. 1.5 2 2.5 3'
'set ccols  79 78 77 76 75 73 71 0 31 33 35 36 37 38 39'
*'set clevs  -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9'
*'set ccols  79 77 75 73 48 46 44 42 0 21 23 25 27 63 65 67 69'
*'set ccols  75 74 73 72 44 43 42 41 0 21 22 23 24 62 63 64 65'
*'d c'%ieof
*'set gxout contour'
'set cint 10'
*if(iframe = 2);'set cint 5';endif
'd p'%ieof
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -60 180 60'
'set string 1 tc 5 90'
'set strsiz 0.12 0.12'
if(iframe = 1);'draw string 'xstr' 'ystr' ENSO'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' rsd_EOF1'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' rsd_EOF2'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' rsd_EOF3'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' rsd_EOF4'; endif
*if(iframe = 6);'draw string 'xstr' 'ystr' rsd_EOF5'; endif
endif
if(iframe > 5);
'set ylab on'
'set xlab off'
if(iframe=10);'set xlab on';endif
'set gxout bar'
'set barbase 0'
'set vrange -3.0 3.0'
'set ylint 1.'
'set y 1'
'set x 1'
'set grid on'
'set grads off'
'set xaxis 1980 2019 5'
'set bargap 30'
'set t 1 41'
'set ccolor 29'
'd maskout(cf'%ipc',cf'%ipc')'
'set ccolor 49'
'd maskout(cf'%ipc',-cf'%ipc')'
'set gxout line'
'set string 1 tc 5 270'
'set strsiz 0.12 0.12'
if(iframe = 6);'draw string 'xstr' 'ystr' NINO3.4'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' rsd_PC1'; endif
if(iframe = 8);'draw string 'xstr' 'ystr' rsd_PC2'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' rsd_PC3'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' rsd_PC4'; endif
endif
*----------
'set string 1 tc 5 0'
if(iframe = 5);'run /cpc/home/wd52pp/bin/cbarn.gs 0.7 0 4.2 2.9';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-5

endwhile
*
'printim rsd_reof_rpc.cmap.djf.'eof_range'.'mtx'.png gif x600 y800'
