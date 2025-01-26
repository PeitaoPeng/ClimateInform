'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/djf14-15/z_s_v.200mb.jan1979-feb2015.cfsr.mon.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.8 PSI200 2013-2015'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
nframe3=6
xmin0=0.75;  xlen=4.5;  xgap=0.5
ymax0=7.75; ylen=-2.75;  ygap=0.4
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
  tlx=xmin+0.3
  tly=ymax-0.5
  bx=5.5
  by=ymin-0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=ave(s,time=sep2013,time=nov2013)/1000000'
'define s2=ave(s,time=dec2013,time=feb2014)/1000000'
'define s3=ave(s,time=mar2014,time=may2014)/1000000'
'define s4=ave(s,time=jun2014,time=aug2014)/1000000'
'define s5=ave(s,time=sep2014,time=nov2014)/1000000'
'define s6=ave(s,time=dec2014,time=feb2015)/1000000'
'define ss1=s1-ave(s1,lon=0,lon=360,-b)'
'define ss2=s2-ave(s2,lon=0,lon=360,-b)'
'define ss3=s3-ave(s3,lon=0,lon=360,-b)'
'define ss4=s4-ave(s4,lon=0,lon=360,-b)'
'define ss5=s5-ave(s5,lon=0,lon=360,-b)'
'define ss6=s6-ave(s6,lon=0,lon=360,-b)'
'set t 1'
'set lon 0 360'
'set lat  -60 80'
'set yaxis -60 85 15'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
*'set gxout shaded'
*'set clevs   -1.5 -1.2 -0.9 -0.6 -0.3 0.3 0.6 0.9 1.2 1.5'
*'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'set gxout contour'
'set ccolor 4'
'd ss'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -60 180 80'
'set string 1 tl 6 0'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly'  SON2013'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  DJF2014'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  MAM2014'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  JJA2014'; endif
if(iframe = 5); 'draw string 'tlx' 'tly'  SON2014'; endif
if(iframe = 6); 'draw string 'tlx' 'tly'  DJF2015'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 'bx' 'by''
'print'
'printim psi200.obs.14-15.png gif x800 y600'

