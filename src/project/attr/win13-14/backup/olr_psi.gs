'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open pent.olra.y2013-14.ctl'
'open pent.200psia.y2013-14.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.3 OLR ANOM (5S-5N) and PSI (25N-30N)'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=10.; ylen=-6.0;  ygap=-0.4
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
  bx=4.25
  by=ymin-0.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
*'set grid off'
*'set map 15 1 2'
'set gxout shaded'
*'set gxout contour'
'set clevs   -50 -40 -30 -20 -10  10 20 30 40 50'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'set t 65 92'
'set lon 0 360'
'set lat 25'
'set yflip on'
'd tloop(ave(olra,lat=-5,lat=5))'
'set gxout contour'
'set lat 25'
'set cint 1'
'd 0.0000001*tloop(ave(psi.2,lat=25,lat=30))'
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 'bx' 'by''
'print'
'printim olr_psi.png gif x600 y800'

