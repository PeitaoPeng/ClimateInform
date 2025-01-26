'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*

'open /cpc/home/wd52pp/data/attr/sst14-15/sst.had-oi.jan1949-cur.mon.anom.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/uv.1000mb.ERA.jan1979-cur.mon.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/uv10m.esm.amip.para.3mon.anom.2.5x2.5.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
*'draw string 4.25 10.1 SST and 1000hPa Wind'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=1
nframe3=5
xmin0=0.5;  xlen=3.75;  xgap=0.2
ymax0=9.75; ylen=-2.0;  ygap=0.2
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
  tlx=xmin+0.
  tly=ymax-0.0
  bx=xmin+1.75
  by=ymin-1.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1 12'
'define clm=ave(sst,t+384,t=744,1yr)'
'modify clm seasonal'
'set t 1'
'define s1=ave(sst-clm,time=jun2014,time=jul2014)'
'define s2=s1'
'define uo=ave(u.2,time=jun2014,time=jul2014)'
'define vo=ave(v.2,time=jun2014,time=jul2014)'
'define um=u.3(time=jun2014)'
'define vm=v.3(time=jun2014)'

'define u1=skip(uo,2,2)'
'define v1=skip(vo,2,2)'
'define u2=skip(um,2,2)'
'define v2=skip(vm,2,2)'
'set t 1'
'set lon 120 290'
'set lat  -30 30'
'set yaxis -30 30 10'
*'set xlab off'
if(iframe > 1); 'set ylab off'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
 'set gxout shaded'
 'set clevs    -1.5 -1.2 -0.9 -0.6 -0.3  0.3 0.6 0.9 1.2 1.5'
 'set ccols    49 47 45 43 41 0 21 23 25 27 29'
'd s'%iframe
'set cthick 4'
'set ccolor 1'
'set arrscl  0.5 4'
'set arrowhead 0.05'
*'set arrlab off'
if (iframe = 1)
'd maskout(u1,sqrt(u1*u1+v1*v1)-0.5);maskout(v1,sqrt(u1*u1+v1*v1)-0.5)'
endif
if(iframe = 2)
'd maskout(u2,sqrt(u2*u2+v2*v2)-0.5);maskout(v2,sqrt(u2*u2+v2*v2)-0.5)'
endif
'run /cpc/home/wd52pp/bin/dline.gs 120 0 290 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 30'
'set string 1 tl 5 0'
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly'  a) OBS'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  b) Model'; endif
'set string 1 tl 5 0'

*if(iframe = 5);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.56 0 'bx' 'by'';endif
iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 4.45 7.3'
'print'
*'printim sst_uv1000mb_obs_vs_para.png x1200 y1600'
'printim Fig9.png x1200 y1600'

