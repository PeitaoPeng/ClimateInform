'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*

'open /cpc/home/wd52pp/data/attr/sst14-15/sst.had-oi.jan1949-cur.3mon.anom.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/uv10m.esm.amip.para.3mon.anom.2.5x2.5.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/prate.1979-cur.cmap.3mon.R15.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
*'draw string 4.25 10.1 Oberved SST, 10m-wind and Prate(contours)'
'draw string 4.25 10.1 SST and AMIP 10m-wind'
*---------------------------set dimsnesion, page size and style
nframe=5
nframe2=3
nframe3=5
xmin0=0.75;  xlen=3.5;  xgap=0.2
ymax0=10.0; ylen=-2.5;  ygap=0.2
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
if(iframe > 3);tlx=xmax+0.25;endif
  tly=ymax-1.125
  bx=xmin+1.75
  by=ymin-1.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=sst(t=780)'
'define s2=sst(t=783)'
'define s3=sst(t=786)'
'define s4=sst(t=789)'
'define s5=sst(t=792)'
'define u1=skip(u.2(time=jan2014),2,2)'
'define u2=skip(u.2(time=apr2014),2,2)'
'define u3=skip(u.2(time=jul2014),2,2)'
'define u4=skip(u.2(time=oct2014),2,2)'
'define u5=skip(u.2(time=jan2015),2,2)'
'define v1=skip(v.2(time=jan2014),2,2)'
'define v2=skip(v.2(time=apr2014),2,2)'
'define v3=skip(v.2(time=jul2014),2,2)'
'define v4=skip(v.2(time=oct2014),2,2)'
'define v5=skip(v.2(time=jan2015),2,2)'
'define p1=p.3(t=420)'
'define p2=p.3(t=423)'
'define p3=p.3(t=426)'
'define p4=p.3(t=429)'
'define p5=p.3(t=432)'
'set t 1'
'set lon 120 290'
'set lat  -30 60'
'set yaxis -30 60 20'
'set xlab off'
if(iframe = 3); 'set xlab on'; endif
if(iframe = 5); 'set xlab on'; endif
if(iframe > 3); 'set ylab off'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
 'set gxout shaded'
 'set clevs    -1.5 -1.2 -0.9 -0.6 -0.3  0.3 0.6 0.9 1.2 1.5'
 'set ccols    49 47 45 43 41 0 21 23 25 27 29'
'd s'%iframe
'set gxout contour'
'set ccolor 1'
'set cthick 6'
'set clevs -5 -4 -3 3 4 5'
*'d p'%iframe
'set cthick 4'
'set ccolor 1'
'set arrscl  0.5 4'
'set arrowhead 0.05'
'set arrlab off'
if(iframe = 5);'set arrlab on';endif
if (iframe = 1)
'd maskout(u1,sqrt(u1*u1+v1*v1)-0.3);maskout(v1,sqrt(u1*u1+v1*v1)-0.3)'
endif
if(iframe = 2)
'd maskout(u2,sqrt(u2*u2+v2*v2)-0.3);maskout(v2,sqrt(u2*u2+v2*v2)-0.3)'
endif
if(iframe = 3)
'd maskout(u3,sqrt(u3*u3+v3*v3)-0.3);maskout(v3,sqrt(u3*u3+v3*v3)-0.3)'
endif
if(iframe = 4)
'd maskout(u4,sqrt(u4*u4+v4*v4)-0.3);maskout(v4,sqrt(u4*u4+v4*v4)-0.3)'
endif
if(iframe = 5)
'd maskout(u5,sqrt(u5*u5+v5*v5)-0.3);maskout(v5,sqrt(u5*u5+v5*v5)-0.3)'
endif
'run /cpc/home/wd52pp/bin/dline.gs 120 0 290 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 60'
'set string 1 tc 5 90'
if(iframe > 3);'set string 1 tc 5 270';endif
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly'  a) DJF13/14'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  b) MAM14'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  c) JJA14'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  d) SON14'; endif
if(iframe = 5); 'draw string 'tlx' 'tly'  e) DJF14/15'; endif
'set string 1 tl 5 0'

if(iframe = 5);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.56 0 'bx' 'by'';endif
iframe=iframe+1
endwhile
'print'
'printim sst_uv10m_prate.amip.png x1200 y1600'

