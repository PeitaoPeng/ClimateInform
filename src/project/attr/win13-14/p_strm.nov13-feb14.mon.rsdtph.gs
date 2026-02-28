'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/winter13-14/wavyout.nov13.rsdtph.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/wavyout.dec13.rsdtph.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/wavyout.jan14.rsdtph.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/wavyout.feb14.rsdtph.ctl'
'open hgt_strm_vpot.200mb.oct13-jan14.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.6 200mb STRM(10`a6`nm`a2`n/s) Anom: Linear Model Response'
'draw string 4.25 10.3 to Tropical Heating (residual)'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
nframe3=4
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=10.; ylen=-2.0;  ygap=-0.4
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
  tlx=xmin-0.2
  tly=ymax-1.75
  bx=xmax+0.075
  by=ymax+2.6
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set z 6'
'define st1=s-s(t=2)-ave(s-s(t=2),lon=0,lon=360,-b)'
'define st2=s.2-s.2(t=2)-ave(s.2-s.2(t=2),lon=0,lon=360,-b)'
'define st3=s.3-s.3(t=2)-ave(s.3-s.3(t=2),lon=0,lon=360,-b)'
'define st4=s.4-s.4(t=2)-ave(s.4-s.4(t=2),lon=0,lon=360,-b)'
'set t 1'
'set lon 0 360'
'set lat  -40 90'
'set yaxis -40 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set gxout contour'
'set ccolor 1'
'set cint 5'
'd 0.00000175*st'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set string 1 tl 6 90'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Nov 2013'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Dec 2013'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' (c) Jan 2014'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' (d) Feb 2014'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim st.nov13-feb14.rsdtph.png gif x600 y800'

