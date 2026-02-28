'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
*'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.djf.1991-2009.non-norm.2x2.ctl'
*'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.jja.1991-2009.non-norm.2x2.ctl'
*'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.mam.1991-2009.non-norm.2x2.ctl'
*'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.son.1991-2009.non-norm.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.djf.1991-2009.test.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.jja.1991-2009.test.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.mam.1991-2009.test.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.son.1991-2009.test.2x2.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print meta.Fig3'
*
*---------------------------string/caption
 'define temp1=ave(t+t.2+t.3+t.4,t=5,t=19)/4.'
 'define temp2=ave(t,t=5,t=19)'
 'define temp3=ave(t.2,t=5,t=19)'
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 4.25 10.5 OCN Forecasted Temp (1995-2009 mean)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.5;  xlen=5.5;  xgap=0.5
ymax0=9.75; ylen=-2.5;  ygap=-0.75
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.75
  titly=ymax+0.225
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set lat 20 56'
*'set lon 230 300'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
*'set gxout shaded'
'set gxout grfill'
'set mpdset mres'
*'set clevs   -0.2 0 0.2 0.4 0.6 0.8 1.0 1.2'
'set clevs   -0.3 0 0.3 0.6 0.9 1.2 1.5 1.8'
'set ccols   44 42 22 23 24 25 26 27 29'
*'set xlab off'
*'set ylab off'
'set xlabs 130W | 120W | 110W | 100W | 90W | 80W | 70W | 60W'
*'set yaxis -80 80 20'
'd temp'%iframe
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout contour'
*'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*'set clopts -1 3 0.05'
*'set cthick 4'
*'d hds'%iframe
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' Annual'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' DJF'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' JJA'; endif
*
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 1 1 7. 5.25'
endwhile
'print'
'printim avg_temp.gocn.map.paper.png gif x600 y800'
*'c'
* 'set vpage off'
*----------
