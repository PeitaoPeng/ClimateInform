'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/wk34/ac3d.ca_psi200_prcp.wkly.winter.ctl'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.14 0.14'
'draw string 5.5 8. CA PRCP WK3-4 Skill(AC) vs # of EOFs and IC-Weeks'
'draw string 5.5 7.75 Hindcast:1979-2015 Winters for CONUS'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.25;  xlen=8.5;  xgap=0.6
ymax0=7.25; ylen=-5.5;  ygap=-1.25
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  xlabx=xmin+4.25
  xlaby=ymin-0.4
  ylabx=xmin+1.25
  ylaby=ymin+2.75
  tlx=xmin+0.5
  tly=ymax+0.05
  bx=xmin+7.
  by=ymax-2.75
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
*'set lon 1 0 360'
*'set lat -29 63'
*'set xlab off'
*'set ylab off'
*'set x 1 10'
'set xlabs 15 | 20 | 25 | 35 '
'set yaxis 1 4 1'
'set grads off'
*'set grid off'
'set gxout shaded'
if(iframe = 1)
'set clevs    0.10 0.12 0.14 0.16 0.18 0.20 0.22 0.24'
'set ccols    0 21 23 24 25 26 27 28 29'
endif
if(iframe = 2)
'set clevs   0.40 0.42 0.44 0.46 0.48 0.50 0.52 0.54 0.56'
'set ccols    0 21 22 23 24 25 26 27 28 29'
endif
'set t 6'
'd ac'
'run /cpc/home/wd52pp/bin/cbarn.gs 1.0 1 'bx' 'by''
*
 'set string 1 tc 5 0'
 'set strsiz 0.13 0.13'
*if(iframe = 2);'draw string 'tlx' 'tly' Lead-7';endif
'draw string 'xlabx' 'xlaby' # of EOFs'
'set string 1 tc 5 90'
'draw string 'ylabx' 'ylaby' # of IC Weeks'
*'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 -29 180 65'
'set string 1 tc 5 0'
  iframe=iframe+1
endwhile
'printim avgac_wk34.eof_vs_ic.winter.prcp.png gif x1600 y1200'
'print'
*
*'c'
'set vpage off'
