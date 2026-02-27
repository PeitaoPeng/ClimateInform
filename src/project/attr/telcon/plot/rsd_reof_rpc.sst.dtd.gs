'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/home/wd52pp/data/attr/telcon/rsd_reof.sst.djf.'eof_range'.'mtx'.dtd.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/rsd_rpc.sst.djf.'eof_range'.'mtx'.dtd.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.65 Nino34 Regr & REOF/RPC of DJF Detrd rsd_SST'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=14
nframe2=7

xmin0=0.75;  xlen=3.5;  xgap=0.1
ymax0=10.35; ylen=-1.2; ygap=-0.1
*
'define p1=renso'
'define p2=reg1'
'define p3=-reg2'
'define p4=reg3'
'define p5=-reg4'
'define p6=reg5'
'define p7=reg6'
'set t 1 42'
'define cf1=cf1.2'
'define cf2=cf2.2'
'define cf3=-cf3.2'
'define cf4=cf4.2'
'define cf5=-cf5.2'
'define cf6=cf6.2'
'define cf7=cf7.2'

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
  if(iframe >  7); ylen=-1.027; endif
  if(iframe >  7); xlen=3.5; endif
  if(iframe >  7); ygap=-0.29; endif
  if(iframe >  7); ymax0=10.30; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  if(iframe = 8); titly=ymax+0.1; endif
  if(iframe = 9); titly=ymax+0.1; endif
  xstr=xmin - 0.0
  ystr=ymin + 0.52
  xstr2=xmin + 0.75
  ystr2=ymin + 0.20
  if(iframe > 7);
  xstr=xmax + 0.25
  endif
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
if(iframe < 8);
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
if(iframe=7);'set xlab on';endif
*
'set gxout shaded'
'set clevs  -1.5 -1.0 -0.5 -0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 1.0 1.5'
'set ccols  49 48 47 46 45 44 43 41 21 23 24 25 26 27 28 29'
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
if(iframe = 6);'draw string 'xstr' 'ystr' rsd_EOF5'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' rsd_EOF6'; endif

'set string 1 tc 5 0'
*if(iframe = 1);'draw string 'xstr2' 'ystr2' 40.2%'; endif
*if(iframe = 2);'draw string 'xstr2' 'ystr2' 13.2%'; endif
*if(iframe = 3);'draw string 'xstr2' 'ystr2' 5.8%'; endif
*if(iframe = 4);'draw string 'xstr2' 'ystr2' 4.6%'; endif
*if(iframe = 5);'draw string 'xstr2' 'ystr2' 3.9%'; endif
*if(iframe = 6);'draw string 'xstr2' 'ystr2' 3.9%'; endif
*if(iframe = 7);'draw string 'xstr2' 'ystr2' 3.9%'; endif
endif
if(iframe > 7);
'set ylab on'
*'set xlab off'
if(iframe=14);'set xlab on';endif
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
if(iframe = 8);'draw string 'xstr' 'ystr' NINO3.4'; endif
if(iframe = 9);'draw string 'xstr' 'ystr' rsd_PC1'; endif
if(iframe = 10);'draw string 'xstr' 'ystr' rsd_PC2'; endif
if(iframe = 11);'draw string 'xstr' 'ystr' rsd_PC3'; endif
if(iframe = 12);'draw string 'xstr' 'ystr' rsd_PC4'; endif
if(iframe = 13);'draw string 'xstr' 'ystr' rsd_PC5'; endif
if(iframe = 14);'draw string 'xstr' 'ystr' rsd_PC6'; endif
endif
*----------
'set string 1 tc 5 0'
if(iframe = 7);'run /cpc/home/wd52pp/bin/cbarn.gs 0.7 0 4.2 0.85';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-7

endwhile
*
'printim rsd_reof_rpc.sst.djf.'eof_range'.'mtx'.dtd.png gif x600 y800'
