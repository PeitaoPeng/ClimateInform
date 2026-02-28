'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
 'open /export-6/cacsrv1/wd52pp/obs/olr/olr_pent.7980-0102DJFM.trop.anom.ctl'
 'open /export-6/cacsrv1/wd52pp/ca_prd/olr_pent.7980-0102DJFM.trop.prd3.ctl'
'enable print  meta.ac'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*'draw string 4.25 10.5 Hovmoller Diagram of Tropical (10S-10N) OLR'
 'draw string 4.25 10.0 Equatorial OLR (1989/90 winter)'
*'draw string 4.25 10.0 Equatorial OLR (2000/01 winter)'
* 'draw string 4.25 10.0 Equatorial OLR (1997/98 winter)'
'draw string 2.7 9.5 Observed'
'draw string 6.4 9.5 2P-Lead PRD'
*---------------------------set dimsnesion, page size and style
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=1
xmin0=1.0;  xlen=3.4;  xgap=0.2
ymax0=9.2; ylen=-6;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx1=xmin-0.5
  titly1=ymax-0.0
  titlx2=xmin-0.5
  titly2=ymax-5.8
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set lon 0 360'
'set lat 0'
*'set xlab off'
'set grads off'
*'set grid off'
'set ylab off'
'set vrange 1 18'
'set ylint 1 1'
'set gxout shaded'
'set clevs  -20 -15 -10 -5 0 5 10 15 20'
'set ccols   49 47 45 43 41 21 23 25 27 29'
 if(iframe = 1); 'set t 244 261'; endif
 if(iframe = 2); 'set t 181 198'; endif
*if(iframe = 1); 'set t 508 526'; endif
*if(iframe = 2); 'set t 379 396'; endif
*if(iframe = 1); 'set t 432 450'; endif
*if(iframe = 2); 'set t 324 342'; endif
 if(iframe = 1); 'd tloop(ave(olr,lat=-10,lat=5))'; endif
 if(iframe = 2); 'd tloop(ave(olr.2,lat=-10,lat=5))'; endif
'set ylint 1 1'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx1' 'titly1' 15Mar90'; endif
 if(iframe = 1); 'draw string 'titlx2' 'titly2' 15Dec89'; endif
*if(iframe = 1); 'draw string 'titlx1' 'titly1' 15Mar01'; endif
*if(iframe = 1); 'draw string 'titlx2' 'titly2' 15Dec00'; endif
*if(iframe = 1); 'draw string 'titlx1' 'titly1' 15Mar98'; endif
*if(iframe = 1); 'draw string 'titlx2' 'titly2' 15Dec97'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.5 2.5'
endwhile
'print'
*
*'c'
 'set vpage off'
