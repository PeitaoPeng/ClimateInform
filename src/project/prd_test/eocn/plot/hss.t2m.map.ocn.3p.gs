'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/prd_skill/hss_gocnv1.temp.jfm1995-djf2011.2x2.ctl'
'open /cpc/home/wd52pp/data/prd_skill/hss_gocn.temp.jfm1995-djf2011.2x2.ctl'
'open /cpc/home/wd52pp/data/prd_skill/hss_eocn.temp.jfm1995-djf2011.2x2.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print hss.t2m.map.ocn.3p.mega'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.6 HSS of Seasonal Temp Forecast'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.5;  xlen=5.5;  xgap=0.75
ymax0=10.; ylen=-2.75;  ygap=-0.6
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.75
  titly=ymax+0.22
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set x 3 33'
'set y 3 16'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set mpdset mres'
'set gxout grfill'
*'set gxout shaded'
'set clevs   0 10 20 30 40 50 60'
'set ccols   0 22 23 24 25 26 27 29'
if(iframe = 1); 'd hs'; endif
if(iframe = 2); 'd hs.2'; endif
if(iframe = 3); 'd hs.3'; endif
*'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*----------
if(iframe = 1); 'draw string 'titlx' 'titly' OCN(K=10)'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' OCN(opt K)'; endif
if(iframe = 3); 'draw string 'titlx' 'titly' EOCN'; endif
*
  iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 7.3 5.3'
'print'
'printim hss.t2m.map.ocn.3p.png gif x600 y800'
*'c'
* 'set vpage off'
*----------
