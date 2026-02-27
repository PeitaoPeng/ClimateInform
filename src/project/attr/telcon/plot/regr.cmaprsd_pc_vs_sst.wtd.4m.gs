'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/home/wd52pp/data/attr/telcon/corr.cmap_rsd_pc_vs_sst.djf.wtd.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
* 'draw string 4.25 10.75 DJF Z200 vs CMAP RSD_RPC'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=4
nframe2=4

xmin0=1.25;  xlen=6.0;  xgap=0.1
ymax0=10.75; ylen=-1.5; ygap=-0.1
*
'define p1=-reg1'
'define p2=reg2'
'define p3=reg3'
'define p4=reg4'
'define p5=-reg5'
'define p6=reg6'
'define c1=-eof1'
'define c2=eof2'
'define c3=eof3'
'define c4=eof4'
'define c5=-eof5'
'define c6=eof6'

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
  if(iframe >  6); ylen=-1.2; endif
  if(iframe >  5); xlen=3.5; endif
  if(iframe >  6); ygap=-0.2; endif
  if(iframe >  6); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  if(iframe = 7); titly=ymax+0.1; endif
  if(iframe = 8); titly=ymax+0.1; endif
  xstr=xmin - 0.275
  ystr=ymin + 0.75
  if(iframe > 6);
  xstr=xmax + 0.25
  endif
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
if(iframe < 5);
'set mproj scaled'
'set lat -30 30'
'set ylint 30'
'set lon 0 360'
'set xlint 60'
'set grid on'
*'set poli on'
*'set mpdset mres'
*'set gxout grfill'
'set xlab off'
'set ylab off'
if(iframe=4);'set xlab on';endif
*
'set gxout shaded'
'set clevs  -1 -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5 1'
'set ccols  49 48 47 46 44 42 0 22 24  26 27 28 29'
'd p'%ieof
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
'set strsiz 0.14 0.14'
if(iframe = 1);'draw string 'xstr' 'ystr' PC1'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' PC2'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' PC3'; endif
if(iframe = 4);'draw string 'xstr' 'ystr' PC4'; endif
if(iframe = 5);'draw string 'xstr' 'ystr' PC5'; endif
if(iframe = 6);'draw string 'xstr' 'ystr' PC6'; endif
endif
*----------
'set string 1 tc 5 0'
if(iframe = 4);'run /cpc/home/wd52pp/bin/cbarn.gs 0.85 0 4.25 3.9';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-4

endwhile
*
'printim regr.cmaprsd_pc.vs.sst.wtd.4m.png gif x600 y800'
