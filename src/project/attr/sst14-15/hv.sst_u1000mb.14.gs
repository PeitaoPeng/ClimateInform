'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/sst.had-oi.jan1949-cur.mon.anom.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/uv.1000mb.ERA.jan1979-cur.mon.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10 5S-5N avg SST and 1000hPa-U Anom'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=1.5;  xlen=6.;  xgap=0.2
ymax0=9.75; ylen=-8;   ygap=0.2
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
  tly=ymax-1.25
  bx=xmin+3
  by=ymin-0.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lon 120 280'
'set lat  0'
'set grads off'
'set gxout shaded'
'set arrlab off'
'set clevs    -1.5 -1.2 -0.9 -0.6 -0.3  0.3 0.6 0.9 1.2 1.5'
'set ccols    49 47 45 43 41 0 21 23 25 27 29'
*'set t 780 800'
'set t 779 795'
'd ave(sst,lat=-5,lat=5)'
'set dfile 2'
'set gxout contour'
'set clevs -1.5 -1. -0.5  0.5 1 1.5 2'
'd ave(u.2,lat=-5,lat=5)'
'set clevs 0'
'set cthick 6'
'set ccolor 1'
'd ave(u.2,lat=-5,lat=5)'
'set string 1 tc 5 90'
'set strsiz 0.13 0.13'
'set string 1 tl 5 0'

'run /cpc/home/wd52pp/bin/cbarn2.gs 0.9 0 'bx' 'by''
iframe=iframe+1
endwhile
'print'
'printim hv.sst_u1000mb.nov13-mar15.png gif x1200 y1600'
*'printim fig7.png gif x1200 y1600'

