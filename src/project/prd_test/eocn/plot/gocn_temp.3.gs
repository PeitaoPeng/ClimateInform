'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.djf.1991-2009.test.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.jja.1991-2009.test.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.mam.1991-2009.test.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.son.1991-2009.test.2x2.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print meta.Fig3'
*
*---------------------------string/caption
 'define temp1=t(t=5)'
 'define temp2=t(t=6)'
 'define temp3=t(t=7)'
 'define temp4=t(t=8)'
 'define temp5=t(t=9)'
 'define temp6=t(t=10)'
 'define temp7=t(t=11)'
 'define temp8=t(t=12)'
*---------------------------set dimsnesion, page size and style
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
'draw string 4.25 10.5 OCN Forecasted DJF Temp(K)'
nframe=8
nframe2=4
xmin0=0.5;  xlen=3.5;  xgap=0.5
ymax0=10.; ylen=-2.25;  ygap=-0.
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.5
  titly=ymax-2.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set xlab off'
'set ylab off'
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
 if(iframe = 1); 'draw string 'titlx' 'titly' 95/96'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' 96/97'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' 97/98'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' 98/99'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' 99/00'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly' 00/01'; endif
 if(iframe = 7); 'draw string 'titlx' 'titly' 01/02'; endif
 if(iframe = 8); 'draw string 'titlx' 'titly' 02/03'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 1 0 4.25 0.5'
endwhile
'print'
'printim gocnv1_temp.ind_season.95-02.png gif x600 y800'
'c'
* 'set vpage off'
*----------
*
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.djf.1991-2009.test.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.jja.1991-2009.test.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.mam.1991-2009.test.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.son.1991-2009.test.2x2.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print meta.Fig3'
*
*---------------------------string/caption
 'define temp1=t(t=13)'
 'define temp2=t(t=14)'
 'define temp3=t(t=15)'
 'define temp4=t(t=16)'
 'define temp5=t(t=17)'
 'define temp6=t(t=18)'
 'define temp7=t(t=19)'
 'define avg=ave(t,t=5,t=19)'
 'define temp8=sqrt(ave((t-avg)*(t-avg),t=5,t=19))'
*---------------------------set dimsnesion, page size and style
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
'draw string 4.25 10.5 OCN Forecasted DJF Temp(K)'
nframe=8
nframe2=4
xmin0=0.5;  xlen=3.5;  xgap=0.5
ymax0=10.; ylen=-2.25;  ygap=-0.
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.5
  titly=ymax-2.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set xlab off'
'set ylab off'
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
 if(iframe = 1); 'draw string 'titlx' 'titly' 03/04'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' 04/05'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' 05/06'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' 06/07'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' 07/08'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly' 08/09'; endif
 if(iframe = 7); 'draw string 'titlx' 'titly' 09/10'; endif
 if(iframe = 8); 'draw string 'titlx' 'titly' STDV'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 1 0 4.25 0.5'
endwhile
'print'
'printim gocnv1_temp.ind_season.03-09.png gif x600 y800'
*'c'
* 'set vpage off'
*----------
