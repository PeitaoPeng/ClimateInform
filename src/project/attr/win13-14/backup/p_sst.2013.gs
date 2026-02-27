'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open prate.ond_dec2013.ctl'
'open hgt_strm_vpot.200mb.ond_dec2013.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.6 Prate(mm/day) and 200mb VPOT(10`a6`nm`a2`n/s) Anoms from Analyses'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
nframe3=2
xmin0=1.;  xlen=6.5;  xgap=0.2
ymax0=9.8; ylen=-3.5;  ygap=-0.75
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
  tlx=xmin+0.2
  tly=ymax+0.2
  bx=xmax+0.1
  by=ymax+0.33
  bx2=xmin+3.4
  by2=ymin+0.875
  bx3=xmin+3.4
  by3=ymin+2.00
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lon 0 360'
'set lat  -90 90'
'set yaxis -90 90 20'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
if(iframe = 1)
'set gxout shaded'
'set clevs   -8 -4 -2 -1 -0.5 0.5 1 2 4 8'
'set ccols   79 77 75 73 72 0 32 33 35 37 39'
'd p1m'
'set gxout contour'
'set ccolor 1'
'set cint 2'
'd v1.2/1000000'
*'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by''
endif
if(iframe = 2)
'set gxout shaded'
'set clevs   -8 -4 -2 -1 -0.5 0.5 1 2 4 8'
'set ccols   79 77 75 73 72 0 32 33 35 37 39'
'd p3m'
'set gxout contour'
'set ccolor 1'
'set cint 2'
'd v3.2/1000000'
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.85 1 'bx' 'by''
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
'set string 1 tl 5'
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) December 2013'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Oct-Nov-Dec 2013'; endif

iframe=iframe+1
endwhile
'print'
'printim p_vp.2013.png gif x600 y800'

