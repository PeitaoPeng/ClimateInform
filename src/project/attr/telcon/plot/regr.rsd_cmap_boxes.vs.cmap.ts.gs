'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

mtx=var
eof_range=tp

'open /cpc/home/wd52pp/data/attr/telcon/regr.rsd_cmap_boxes.vs.cmap.djf.80-cur.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/ts.rsd_cmap_boxes.djf.80-cur.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.6 RSD Prate Regression to the Anomales in the Boxed Regions'
 'set strsiz 0.11 0.11'
*---------------------------set dimsnesion, page size and style
*
nframe=6
nframe2=3

xmin0=0.75;  xlen=3.5;  xgap=0.1
ymax0=10.25; ylen=-1.2; ygap=-0.2
*
'define p1=reg1'
'define p2=reg2'
'define p3=reg3'
'set t 1 40'
'define cf1=b1.2'
'define cf2=b2.2'
'define cf3=b3.2'

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
  if(iframe >  3); ylen=-1.2; endif
  if(iframe >  2); xlen=3.5; endif
  if(iframe >  3); ygap=-0.2; endif
  if(iframe >  3); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
  if(iframe = 4); titly=ymax+0.1; endif
  if(iframe = 5); titly=ymax+0.1; endif
  xstr=xmin - 0.35
  ystr=ymin + 0.65
  if(iframe > 3);
  xstr=xmax + 0.25
  endif
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
*'set grid off'
if(iframe < 4);
*'set mproj scaled'
'set grid off'
'set lat -60 60'
'set ylint 20'
'set lon 0 360'
'set xlint 60'
*'set grid on'
*'set poli on'
*'set mpdset mres'
*'set gxout grfill'
'set xlab off'
*'set ylab off'
if(iframe=3);'set xlab on';endif
*
'set gxout shaded'
'set clevs -3.0 -2.5 -2.0 -1.6 -1.2 -0.8 -0.4 -0.2 0.2 0.4 0.8 1.2 1.6 2.0 2.5 3.'
'set ccols  79 78 77 76 75 74 73 72 0 32 33 34 35 36 37 38 39'
*'set clevs  -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9'
*'set ccols  79 77 75 73 48 46 44 42 0 21 23 25 27 63 65 67 69'
*'set ccols  75 74 73 72 44 43 42 41 0 21 22 23 24 62 63 64 65'
*'d c'%ieof
*'set gxout contour'
'set cint 10'
*if(iframe = 2);'set cint 5';endif
'd p'%ieof
if(iframe = 1);
'run /cpc/home/wd52pp/bin/dline.gs 40 10 90 10'
'run /cpc/home/wd52pp/bin/dline.gs 40 -10 90 -10'
'run /cpc/home/wd52pp/bin/dline.gs 40 -10 40  10'
'run /cpc/home/wd52pp/bin/dline.gs 90 -10 90  10'
endif
if(iframe = 2);
'run /cpc/home/wd52pp/bin/dline.gs 90  10 140 10'
'run /cpc/home/wd52pp/bin/dline.gs 90 -10 140 -10'
'run /cpc/home/wd52pp/bin/dline.gs 90 -10  90  10'
'run /cpc/home/wd52pp/bin/dline.gs 140 -10 140  10'
endif
if(iframe = 3);
'run /cpc/home/wd52pp/bin/dline.gs 160  10 210 10'
'run /cpc/home/wd52pp/bin/dline.gs 160 -10 210 -10'
'run /cpc/home/wd52pp/bin/dline.gs 160 -10 160  10'
'run /cpc/home/wd52pp/bin/dline.gs 210 -10 210  10'
endif
'set string 1 tc 5 90'
'set strsiz 0.12 0.12'
if(iframe = 1);'draw string 'xstr' 'ystr' WCIO'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' EIWP'; endif
if(iframe = 3);'draw string 'xstr' 'ystr' NINO4W'; endif
endif
if(iframe > 3);
'set ylab on'
'set xlab off'
if(iframe=6);'set xlab on';endif
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
'set t 1 40'
'set ccolor 29'
'd maskout(cf'%ipc',cf'%ipc')'
'set ccolor 49'
'd maskout(cf'%ipc',-cf'%ipc')'
'set gxout line'
'set string 1 tc 5 270'
'set strsiz 0.12 0.12'
*if(iframe = 4);'draw string 'xstr' 'ystr' NINO3.4'; endif
*if(iframe = 5);'draw string 'xstr' 'ystr' rsd_PC1'; endif
*if(iframe = 6);'draw string 'xstr' 'ystr' rsd_PC2'; endif
endif
*----------
'set string 1 tc 5 0'
if(iframe = 3);'run /cpc/home/wd52pp/bin/cbarn.gs 0.7 0 4.2 5.75';endif
*

iframe=iframe+1
ieof=ieof+1
ipc=iframe-3

endwhile
*
'printim regr.rsd_camp_box.vs.cmap.ts.png gif x600 y800'
