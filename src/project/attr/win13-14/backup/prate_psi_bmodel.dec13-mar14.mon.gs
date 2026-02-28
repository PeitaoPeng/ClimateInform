'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open hgt_strm_vpot.200mb.oct13-mar14.ctl'
'open prate.oct13-mar14.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/bmout.dec13.prate.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/bmout.jan14.prate.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/bmout.feb14.prate.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/bmout.mar14.prate.ctl'
*
'set string 1 tc 5'
'set strsiz 0.13 0.13'
'draw string 4.25 10.0 200hPa PSI: Observed vs Linear Model Response'
*---------------------------set dimsnesion, page size and style
'define p1=p.2(t=3)'
'define p2=p.2(t=4)'
'define p3=p.2(t=5)'
'define p4=p.2(t=6)'
'define p5=adiv.3'
'define p6=adiv.4'
'define p7=adiv.5'
'define p8=adiv.6'
'define st1=strm(t=3)-ave(strm(t=3),lon=0,lon=360)'
'define st2=strm(t=4)-ave(strm(t=4),lon=0,lon=360)'
'define st3=strm(t=5)-ave(strm(t=5),lon=0,lon=360)'
'define st4=strm(t=6)-ave(strm(t=6),lon=0,lon=360)'
'define st5=sfm.3'
'define st6=sfm.4'
'define st7=sfm.5'
'define st8=sfm.6'

nframe=8
nframe2=4
nframe3=8
xmin0=1.3;  xlen=3.;  xgap=0.2
ymax0=9.75; ylen=-1.4;  ygap=-0.0
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
  tly=ymax-1.
  bx=xmin+1.5
  by=ymin-0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lon 0 360'
'set lat  -40 90'
'set yaxis -40 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set xlab off'
'set ylab off'
'set clab off'
if(iframe = 4); 'set xlab on'; endif
if(iframe = 8); 'set xlab on'; endif
if(iframe <= 4); 'set ylab on'; endif
*'set map 15 1 2'
if(iframe <= 4);
'set gxout shaded'
'set clevs   -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
'd p'%iframe
if(iframe = 4);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.45 0 'bx' 'by'';endif
'set gxout contour'
'set ccolor 1'
'set cint 5'
'd 0.000001*st'%iframe
endif
if(iframe > 4);
'set gxout shaded'
'set clevs   -5 -4 -3 -2 -1 1 2 3 4 5'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'd 1000000*p'%iframe
if(iframe = 8);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.45 0 'bx' 'by'';endif
'set gxout contour'
'set ccolor 1'
'set cint 2'
'd 0.000001*st'%iframe
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -40 180 90'
'set string 1 tl 5 90'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly' Dec13'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' Jan14'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' Feb14'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' Mar14'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'print'
'printim prate_psi_bmodel.dec13-mar14.png gif x600 y800'

