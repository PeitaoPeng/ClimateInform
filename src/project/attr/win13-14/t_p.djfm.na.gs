'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open prate.djfm.1981-curr.ctl'
'open mask_land_sea_edge.lnx.ctl'
'open t2m.djfm.1981-curr.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.2 Standardized Prate & T2m Anom, DJFM 2013/14'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
nframe3=2
xmin0=1.25;  xlen=6.;  xgap=0.5
ymax0=9.75; ylen=-4.;  ygap=-0.3
*
'define stdp=sqrt(ave(p*p,t=1,t=30))'
'define stdt=sqrt(ave(t2m.3*t2m.3,t=1,t=30))'
'define pt1=maskout(p(t=34)/stdp,mask.2(t=1)-1)'
'define pt2=t2m.3(t=34)/stdt'
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
  tlx=xmin+0.5
  tly=ymax-0.2
  bx=xmax+0.
  by=ymin+2.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lon 190 310'
'set lat  10 90'
*'set yaxis 10 90 20'
'set xlab off'
'set ylab off'
'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
if(iframe <= 1);
'set clevs  -2 -1.5 -1 -0.5 0 0.5 1 1.5 2'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
endif
if(iframe > 1);
'set clevs  -2 -1.5 -1 -0.5 0 0.5 1 1.5 2'
'set ccols   49 47 45 43 41 21 23 25 27 29'
endif
'd pt'%iframe
*'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set string 1 tl 6 0'
'set strsiz 0.15 0.15'
if(iframe = 1); 'run /cpc/home/wd52pp/bin/cbarn2.gs 0.7 1 'bx' 'by''; endif
if(iframe = 2); 'run /cpc/home/wd52pp/bin/cbarn2.gs 0.7 1 'bx' 'by''; endif

'set string 1 tl 6 0'
'set strsiz 0.17 0.17'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Prate'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) T2m'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim t_p.djfm.na.png gif x600 y800'

