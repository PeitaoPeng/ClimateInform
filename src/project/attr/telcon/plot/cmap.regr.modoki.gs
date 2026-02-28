'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'

zonal=raw
area=glb
mtx=var
ts=rsd_rpc

'open /cpc/home/wd52pp/data/attr/telcon/corr.sstpc_vs_cmap.djf.ctl'
'open /cpc/home/wd52pp/data/attr/telcon/corr.cmaprsd_rpc_vs_cmap.djf.wtd.ctl'
*---------------------------string/caption
 'set string 1 tc 5 0'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.2 Rainfall Regression to Indices'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
*
nframe=2
nframe2=2

xmin0=1.25;  xlen=6.;  xgap=-0.5
ymax0=10.; ylen=-2.5; ygap=0.2
*
*'set mproj nps'
'set lat -30 30'
*'set lon -270 90'
*
'define p1=reg2'
'define p2=-reg2.2'

'set t 1'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if(iframe >  4); ylen=-1.5; endif
  if(iframe >  4); xlen=3.25; endif
  if(iframe >  4); ygap=-0.3; endif
  if(iframe >  4); ymax0=10.25; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
* if(iframe = 7); ymax=ymax0+(icy-1)*(ylen+ygap)-0.1; endif
  ymin=ymax+ylen
* if(iframe = 6); titly=ymax+0.1; endif
* if(iframe = 7); titly=ymax+0.1; endif
  xstr=xmin + 0.0
  ystr=ymax -0.4
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
'set grads off'
*'set frame off'
*
'set grads off'
*if(iframe < 6);
'set ylint 10'
*'set lon 190 300'
'set lon 0 360'
'set xlint 60'
'set grid on'
'set poli on'
*'set mpdset mres'
*'set gxout grfill'
*'set xlab off'
'set ylab off'
*if(iframe<= 5);'set ylab on';endif
if(iframe< 5);'set ylab on';endif
if(iframe=4);'set xlab on';endif
if(iframe=8);'set xlab on';endif
*
'set gxout shaded'
*'set clevs  -0.3 0.3'
*'set ccols  22 0 22'
*'d c'%ieof
*'set gxout contour'
*'set cint 5'
'set clevs   -2.0 -1.5 -1.0 -0.5 -0.2 0.2 0.5 1. 1.5 2'
'set ccols  79 77 75 74 72 0 32 34 35 37 39'
'd p'%iframe
*'run /cpc/home/wd52pp/bin/dline.gs  0 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
'set string 1 tl 5'
'set strsiz 0.11 0.11'
if(iframe = 1);'draw string 'xstr' 'ystr' a)PC2 of tropical Pacific SST'; endif
if(iframe = 2);'draw string 'xstr' 'ystr' b)RPC1 of Rainfall Residual'; endif
*endif
*----------
'set string 1 tl 5'
if(iframe = 2);'run /cpc/home/wd52pp/bin/cbarn.gs 0.75 0 4.25 5.25';endif
*

iframe=iframe+1

endwhile
*
'printim cmap_modoki.png gif x1200 y1600'
's1=sqrt(aave(p1*p1,lon=0,lon=360,lat=-30,lat=30))'
's2=sqrt(aave(p2*p2,lon=0,lon=360,lat=-30,lat=30))'
'xy=aave(p1*p2,lon=0,lon=360,lat=-30,lat=30)'
'cor=xy/(s1*s2)'
