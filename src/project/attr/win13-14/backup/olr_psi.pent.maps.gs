'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open pent.olra.y2013-14.ctl'
'open pent.200psi.y2013-14.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10. OLR(W/m`a2`n) and PSI(10`a6`nm`a2`n/s) Anom'
*---------------------------set dimsnesion, page size and style
nframe=8
nframe2=4
nframe3=8
xmin0=0.75;  xlen=3.5;  xgap=0.1
ymax0=9.65; ylen=-2.;  ygap=0.1
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
  tly=ymax+0.0
  bx=4.25
  by=ymin-0.35
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define olr1=olra(t=78)'
'define olr2=olra(t=79)'
'define olr3=olra(t=80)'
'define olr4=olra(t=81)'
'define olr5=olra(t=82)'
'define olr6=olra(t=83)'
'define olr7=olra(t=84)'
'define olr8=olra(t=85)'
'define psi1=psi.2(t=78)'
'define psi2=psi.2(t=79)'
'define psi3=psi.2(t=80)'
'define psi4=psi.2(t=81)'
'define psi5=psi.2(t=82)'
'define psi6=psi.2(t=83)'
'define psi7=psi.2(t=84)'
'define psi8=psi.2(t=85)'
'set lon 0 360'
'set lat -40 90'
'set yaxis -40 90 30'
if(iframe > 4); 'set ylab off'; endif
'set xlab off'
if(iframe = 4); 'set xlab on'; endif
if(iframe = 8); 'set xlab on'; endif
*'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -50 -40 -30 -20 -10  10 20 30 40 50'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'd olr'%iframe
'set gxout contour'
'set cint 1'
'd 0.0000001*psi'%iframe
*
'set string 1 tl 5 0'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly' Jan21-25'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' Jan26-30'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' Jan31-Feb04'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' Feb05-09'; endif
if(iframe = 5); 'draw string 'tlx' 'tly' Feb10-14'; endif
if(iframe = 6); 'draw string 'tlx' 'tly' Feb15-19'; endif
if(iframe = 7); 'draw string 'tlx' 'tly' Feb20-24'; endif
if(iframe = 8); 'draw string 'tlx' 'tly' Feb25-Mar01'; endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -40 180 90'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1 0 'bx' 'by''
'print'
'printim olr_psi.feb14.pent.maps.png gif x600 y800'

