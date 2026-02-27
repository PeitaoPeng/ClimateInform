'reinit'
'open /export-6/cacsrv1/wd52pp/ca_prd/ca_prd_opi_ic_nov.mm10.ctl'
*
*  change "set t", "mon" in title
*
ICmon=Nov
tgtmon=Jan
tgtyr=2004
tset=2
monlead=1
*
'enable print 'tgtmon'.gr'
*
'set display color white'
'clear'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
'set t 'tset''
'define ff1=1.5*ca'
'define ff2=100*ff1/sdo'
'define ff3=ac+0.05'
'define ff4=maskout(ff2,ff3-0.3)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
  'draw string 5.5 8.0 CA Prate Forecast for 'tgtmon' 'tgtyr''
  'draw string 5.5 7.7 OPI data through 'ICmon' is used ('monlead' month lead)'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.75;  xlen=4.5;  xgap=0.75
ymax0=7.0; ylen=-1.75;  ygap=-1.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx1=xmin+2.2
  titlx2=xmin+2.2
  titlx3=xmin+2.3
  titlx4=xmin+2.3
  titly=ymax+0.3
  barx=xmin+2.25
  bary=ymax-2.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set lat -20 50'
'set ylint 10'
'set lon 0 360'
'set xlint 60'
'set grads off'
'set grid off'
'set poli on'
'set mpdset mres'
'set map 1 1 1'
*
'set gxout shaded'
'set grads off'
if(iframe = 1);
'set clevs  -3 -2 -1.0 0 1 2 3'
'set ccols  28 26 24 22 32 34 36 38';
endif
if(iframe = 2);
'set clevs  -90 -60 -30 30 60 90'
'set ccols  26 24 22 0 32 34 36';
endif
if(iframe = 3);
'set clevs  0.3 0.4 0.5 0.6';
'set ccols  0 21 23 25 27';
endif
if(iframe = 4);
'set clevs  -90 -60 -30 30 60 90'
'set ccols  26 24 22 0 32 34 36';
endif
'set csmooth on'
'd ff'%iframe
 'set gxout contour'
if(iframe = 2);
'set clevs 0.3 0.4 0.5 0.6';
endif
if(iframe = 3);
'set clevs 1.0 1.5 2.0 2.5';
endif
* 'd ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
if(iframe = 1); 'draw string 'titlx1' 'titly' (a) Precip Rate (mm/day)'; endif
if(iframe = 2); 'draw string 'titlx2' 'titly' (b) Precip Rate (% of stdv)'; endif
if(iframe = 3); 'draw string 'titlx3' 'titly' (c) Historical Skill (AC over 1979-2002)'; endif
if(iframe = 4); 'draw string 'titlx4' 'titly' (d) Skill Masked (b)'; endif
*
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.6 0'
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.5 0 'barx' 'bary''
endwhile

'print'
*'c'
 'set vpage off'
