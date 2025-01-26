'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/project/attr/win13-14/hgt_strm_vpot.200mb.oct13-mar14.ctl'
'open /cpc/home/wd52pp/project/attr/win13-14/prate.oct13-mar14.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/bmout.djfm.prate.ctl'
*
'set string 1 tl 5 0'
'set strsiz 0.14 0.14'
*---------------------------set dimsnesion, page size and style
'define prate=ave(p.2,t=3,t=6)'
'define psi=ave(strm,t=3,t=6)'
'define div=adiv.3'
'define psi2=sfm.3'
nframe=2
nframe2=2
nframe3=2
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=10.; ylen=-3.5;  ygap=-0.85
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
  tlx=xmin+0.0
  tly=ymax+0.1
  bx=4.25
  by=ymin-0.35
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lon 0 360'
'set lat  -90 90'
'set yaxis -90 90 30'
*'set frame off'
'set grads off'
*'set grid off'
if(iframe=1);
'set gxout shaded'
'set clevs -3 -2 -1 -0.5 0.5 1 2 3'
'set ccols  78 76 74 72 0 32 34 36 38'
'd prate'
'set gxout contour'
'set cint 2'
'd 0.000001*(psi-ave(psi,x=1,x=144))'
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 'bx' 'by''
*'draw string 'tlx' 'tly' (a) Observed Prate & 200hPa PSI Anom DJFM 2013/14'
endif
if(iframe=2);
'set gxout shaded'
'set clevs -4 -3 -2 -1 1 2 3 4'
'set ccols  48 46 44 42 0 22 24 26 28'
'd 1000000*div'
'set gxout contour'
'set cint 1'
'd 0.000001*psi2'
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 'bx' 'by''
*'draw string 'tlx' 'tly' (b) Linear model response to trop ADIV'
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
'set string 1 tl 5 0'
'set strsiz 0.12 0.12'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Observed Prate & 200hPa PSI Anom DJFM 2013/14';endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Linear model response to trop ADIV';endif

iframe=iframe+1
endwhile
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 'bx' 'by''
'print'
'printim prate_psi_bmodel.png gif x600 y800'

