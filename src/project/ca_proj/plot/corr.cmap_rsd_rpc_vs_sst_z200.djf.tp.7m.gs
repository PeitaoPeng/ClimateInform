'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

'open /cpc/home/wd52pp/data/ca_proj/corr.cmap_rsd_rpc_vs_sst.djf.ctl'
'open /cpc/home/wd52pp/data/ca_proj/corr.cmap_rsd_rpc_vs_z200.djf.ctl'
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.11 0.11'
 'draw string 4.25 11. Regr of CMAP_RSD_RPC to SST&Z200'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=14
nframe2=7

xmin0=0.75;  xlen=3.5;  xgap=0.3
ymax0=10.75; ylen=-1.2; ygap=-0.2
*
'define p1=reg1'
'define p2=-reg2'
'define p3=-reg3'
'define p4=reg4'
'define p5=reg5'
'define p6=reg6'
'define p7=-reg7'

'define z1=reg1.2'
'define z2=-reg2.2'
'define z3=-reg3.2'
'define z4=reg4.2'
'define z5=reg5.2'
'define z6=reg6.2'
'define z7=-reg7.2'
*
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
* if(iframe >  7); ylen=-1.125; endif
* if(iframe >  7); xlen=3.5; endif
* if(iframe >  7); ygap=-0.29; endif
* if(iframe >  7); ymax0=10.75; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  if(iframe = 8); titly=ymax+0.1; endif
  if(iframe = 9); titly=ymax+0.1; endif
  xstr=xmin - 0.25
  ystr=ymin + 0.58
  xstr2=xmin + 0.85
  ystr2=ymin + 1.0
  if(iframe > 7);
* xstr=xmax + 0.25
  endif
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set mproj scaled'
'set lat -30 90'
'set ylint 15'
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
if(iframe < 8);
'set gxout shaded'
'set clevs  -0.9 -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7 0.9'
'set ccols  49 47 45 43 42 0 22 23 25 27 29'
'd p'%ieof
'set gxout contour'
'set cint 0.1'
*'d p'%ieof
*if(iframe = 2);'set cint 5';endif
*'d p'%ieof
*'d c'%ieof
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
*if(iframe=1);'/cpc/home/wd52pp/bin/hatch1.gs c1 0.3 1';endif
*if(iframe=1);'/cpc/home/wd52pp/bin/hatch1.gs c1 -1 -0.3';endif
*if(iframe=2);'/cpc/home/wd52pp/bin/hatch1.gs c2 0.3 1';endif
*if(iframe=2);'/cpc/home/wd52pp/bin/hatch1.gs c2 -1 -0.3';endif
*if(iframe=3);'/cpc/home/wd52pp/bin/hatch1.gs c3 0.3 1';endif
*if(iframe=3);'/cpc/home/wd52pp/bin/hatch1.gs c3 -1 -0.3';endif
*if(iframe=4);'/cpc/home/wd52pp/bin/hatch1.gs c4 0.3 1';endif
*if(iframe=4);'/cpc/home/wd52pp/bin/hatch1.gs c4 -1 -0.3';endif
*if(iframe=5);'/cpc/home/wd52pp/bin/hatch1.gs c5 0.3 1';endif
*if(iframe=5);'/cpc/home/wd52pp/bin/hatch1.gs c5 -1 -0.3';endif
*if(iframe=6);'/cpc/home/wd52pp/bin/hatch1.gs c6 0.3 1';endif
*if(iframe=6);'/cpc/home/wd52pp/bin/hatch1.gs c6 -1 -0.3';endif

'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set string 1 tc 5 90'
'set strsiz 0.12 0.12'
if(iframe = 1);'draw string 'xstr' 'ystr' SST_RPC1'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' SST_RPC2'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' RSD_RPC1'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' RSD_RPC2'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' RSD_RPC3'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' RSD_RPC4'; endif
if(iframe = 7);'draw string 'xstr' 'ystr' RSD_RPC5'; endif

'set string 1 tc 6 0'
*if(iframe = 1);'draw string 'xstr2' 'ystr2' 47.7%'; endif
*if(iframe = 2);'draw string 'xstr2' 'ystr2'  8.8%'; endif
*if(iframe = 3);'draw string 'xstr2' 'ystr2'  7.3%'; endif
*if(iframe = 4);'draw string 'xstr2' 'ystr2'  5.1%'; endif
*if(iframe = 5);'draw string 'xstr2' 'ystr2'  5.0%'; endif
*if(iframe = 6);'draw string 'xstr2' 'ystr2'  3.9%'; endif
*if(iframe = 7);'draw string 'xstr2' 'ystr2'  3.1%'; endif
endif
if(iframe > 7);
if(iframe=14);'set xlab on';endif
'set gxout shaded'
'set clevs  -40 -35 -30 -25 -20 -15 -10 -5 0 5 10 15 20 25 30 35 40'
'set ccols  49 48 47 46 45 44 43 42 41 21 22 23 24 25 26 27 28 29'
'd z'%ipc
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set ylab on'
*'set xlab off'
if(iframe=14);'set xlab on';endif
'set string 1 tc 5 270'
'set strsiz 0.12 0.12'
*if(iframe = 8);'draw string 'xstr' 'ystr' RPC1'; endif
*if(iframe = 9);'draw string 'xstr' 'ystr' RPC2'; endif
*if(iframe = 10);'draw string 'xstr' 'ystr' RPC3'; endif
*if(iframe = 11);'draw string 'xstr' 'ystr' RPC4'; endif
*if(iframe = 12);'draw string 'xstr' 'ystr' RPC5'; endif
*if(iframe = 13);'draw string 'xstr' 'ystr' RPC6'; endif
*if(iframe = 14);'draw string 'xstr' 'ystr' RPC7'; endif
endif
*----------
'set string 1 tc 5 0'
if(iframe = 7);'run /cpc/home/wd52pp/bin/cbarn.gs 0.5 0 2.475 0.65';endif
if(iframe = 14);'run /cpc/home/wd52pp/bin/cbarn.gs 0.5 0 6.325 0.65';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-7

endwhile
*
'printim corr.cmap_rsd_rpc_vs_sst_z200.djf.tp.7m.png gif x1200 y1600'
