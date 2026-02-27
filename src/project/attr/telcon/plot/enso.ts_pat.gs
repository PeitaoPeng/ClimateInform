'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

'open /cpc/home/wd52pp/data/attr/telcon/corr.cmaprsd_rpc_vs_cmap.djf.wtd.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/trd.rsd_rpc.cmap.djf.tp.var.wtd.ctl'

*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
* 'draw string 4.25 10.65 Nino3.4 Index & Prate Regr'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=2
nframe2=2

ymax0=10.; ylen=-1.125; ygap=-0.5
xmin0=2.5;  xlen=3.5;  xgap=0.3
*
'define p1=reg1'
*
'define c1=cor1'
'set t 1 42'
'define cf1=c1.2'
'define t1=t1.2'

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
  if(iframe >  1); ylen=-1.2; endif
  if(iframe >  1); xlen=3.5; endif
  if(iframe >  1); ygap=-0.5; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  xstr=xmin - 0.
  ystr=ymax + 0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
if(iframe = 1);
*'set xlab off'
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
'set string 1 tc 5 0'
'set strsiz 0.12 0.12'
endif
if(iframe =2);
'set t 1'
'set mproj scaled'
'set lat -30 30'
'set ylint 15'
'set lon 0 360'
'set xlint 60'
'set grid on'
*'set poli on'
*'set mpdset mres'
*'set gxout grfill'
*'set xlab off'
*'set ylab off'
*
'set gxout shaded'
'set clevs   -4.0 -2. -1.0 -0.5 -0.2 0.2 0.5 1. 2. 4'
'set ccols  79 77 75 73 71 0 31 33 35 37 39'
*'set cint 10'
'd p'%ieof
*'set gxout grid'
*'set gridln off'
*'set digsize 0.03'
*'set cthick 8'
*'set ccolor 300'
'/cpc/home/wd52pp/bin/hatch1.gs c1 0.3 1'
'/cpc/home/wd52pp/bin/hatch1.gs c1 -1 -0.3'

'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 30'
endif
'set string 1 tl 5 0'
'set strsiz 0.12 0.12'
if(iframe = 1);'draw string 'xstr' 'ystr' a)Nino3.4 Index'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)Prate Regr to Nino3.4 (35.8%)'; endif
*----------
'set string 1 tc 5 0'
if(iframe = 2);'run /cpc/home/wd52pp/bin/cbarn.gs 0.6 0 4.2 6.6';endif
*

iframe=iframe+1
ieof=iframe-1
ipc=iframe

endwhile
*
'printim Fig1.png x1200 y1600'
