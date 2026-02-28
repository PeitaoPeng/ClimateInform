'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
eof_range=tp_np
*analysis=ersst
analysis=hadoisst
*
'open /cpc/home/wd52pp/data/casst/avgac3d.'analysis'.'mam'.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac3d.'analysis'.'jja'.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac3d.'analysis'.'son'.'eof_range'.ctl'
'open /cpc/home/wd52pp/data/casst/avgac3d.'analysis'.'djf'.'eof_range'.ctl'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
'draw string 4.25 10.5 SST Skill(AC) vs # of EOFs and IC-Seasons'
'draw string 4.25 10.25  'analysis', Hindcast:1981-2015'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.5;  xlen=5.5;  xgap=0.6
ymax0=9.6; ylen=-2.5;  ygap=-1.25
'define sk1=(ac(t=5)+ac.2(t=5)+ac.3(t=5)+ac.4(t=5))/4.' 
'define sk2=(ac(t=11)+ac.2(t=11)+ac.3(t=11)+ac.4(t=11))/4.' 
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  xlabx=xmin+2.75
  xlaby=ymin-0.2
  ylabx=xmin-0.4
  ylaby=ymin+1.25
  tlx=xmin+0.5
  tly=ymax+0.05
  bx=xmin+2.75
  by=ymin-0.65
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
*'set lon 1 0 360'
*'set lat -29 63'
*'set xlab off'
*'set ylab off'
*'set x 1 10'
'set xaxis 15 60 5'
'set yaxis 1 4 1'
'set grads off'
*'set grid off'
'set gxout shaded'
if(iframe = 1)
'set clevs    0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70'
'set ccols    0 21 22 23 24 25 26 27 28 29'
endif
if(iframe = 2)
'set clevs   0.40 0.42 0.44 0.46 0.48 0.50 0.52 0.54 0.56'
'set ccols    0 21 22 23 24 25 26 27 28 29'
endif
'd sk'%iframe
'run /cpc/home/wd52pp/bin/cbarn.gs 0.8 0 'bx' 'by''
*
 'set string 1 tc 5 0'
 'set strsiz 0.13 0.13'
if(iframe = 1);'draw string 'tlx' 'tly' Lead-1';endif
if(iframe = 2);'draw string 'tlx' 'tly' Lead-7';endif
'draw string 'xlabx' 'xlaby' # of EOFs'
'set string 1 tc 5 90'
'draw string 'ylabx' 'ylaby' # of IC Season'
*'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 -29 180 65'
'set string 1 tc 5 0'
  iframe=iframe+1
endwhile
'printim avgac.eof_vs_ic.'analysis'.4savg.shaded.'eof_range'.png gif x1200 y1600'
'print'
*
*'c'
'set vpage off'
