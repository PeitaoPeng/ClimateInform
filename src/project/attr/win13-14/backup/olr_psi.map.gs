'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open pent.olra.y2013-14.ctl'
'open pent.200psi.y2013-14.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.2 OLR(W/m`a2`n) and PSI(10`a6`nm`a2`n/s) Anom'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
nframe3=2
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=9.5; ylen=-2.5;  ygap=-0.5
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
  tlx=xmin+0.1
  tly=ymax+0.2
  bx=4.25
  by=ymin-0.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define olr1=ave(olra,t=80,t=83)'
'define olr2=ave(olra,t=84,t=85)'
'define psi1=ave(psi.2,t=80,t=83)'
'define psi2=ave(psi.2,t=84,t=85)'
'set lon 0 360'
'set lat -40 90'
'set yaxis -40 90 30'
*'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -50 -40 -30 -20 -10  10 20 30 40 50'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'd olr'%iframe
'set gxout contour'
'set cint 4'
'd 0.000001*psi'%iframe
*
'set string 1 tl 5 0'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Jan31-Feb19 2014'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Feb20-Mar01 2014'; endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -40 180 90'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 'bx' 'by''
'print'
'printim olr_psi.feb14.2map.png gif x600 y800'

