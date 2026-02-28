'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open sst.oct13-mar14.ctl'
'open hgt_strm_vpot.200mb.oct13-mar14.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.5 200mb HGT(m) and SST(K), DJFM2013/14'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=1.;  xlen=9.;  xgap=0.2
ymax0=8.; ylen=-7.;  ygap=-0.4
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin-0.5
  tly=ymax-0.2
  bx=5.5
  by=ymin + 0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define sst=ave(sst,t=3,t=6)'
'define z200=ave(hgt.2,t=3,t=6)'
'set t 1'
'set lon 0 360'
'set lat  -90 90'
'set yaxis -90 90 30'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -2.5 -2 -1.5 -1 -0.5 -0.25 0.25 0.5 1 1.5 2 2.5'
'set ccols   49 47 45 43 42 41 0 21 22 23 25 27 29'
'd sst'
'set gxout contour'
'set ccolor 1'
'set cint 25'
'd z200'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
'set string 1 tl 6 90'
'set strsiz 0.14 0.14'
*if(iframe = 1); 'draw string 'tlx' 'tly' (a) Dec 2013'; endif
*if(iframe = 2); 'draw string 'tlx' 'tly' (b) Jan 2014'; endif
*if(iframe = 3); 'draw string 'tlx' 'tly' (c) Feb 2014'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 'bx' 'by''
'print'
'printim sst_z200.djfm14.png gif x800 y600'

