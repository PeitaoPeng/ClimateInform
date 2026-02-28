'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/ca_prd/ac_1d_ca_olr_pent.7980-0102DJFM.mm10.ctl'
'enable print  meta.ac'
'run /export/hobbes/wd52pp/bin/rgbset.gs'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Skill (Anom Pattern Corr) of 2 Pentad Lead CA Prd'
*---------------------------set dimsnesion, page size and style
*
  'define sd1=ac(z=1,t=4)'
  'define sd2=ac(z=2,t=4)'
  'define sd3=ac(z=3,t=4)'
  'define sd4=ac(z=4,t=4)'
  'define sd5=ac(z=5,t=4)'
  'define sd6=ac(z=6,t=4)'
  'define sd7=ac(z=7,t=4)'
  'define sd8=ac(z=8,t=4)'
  'define sd9=ac(z=9,t=4)'
  'define sd10=ac(z=10,t=4)'
  'define sd11=ac(z=11,t=4)'
  'define sd12=ac(z=12,t=4)'
  'define sd13=ac(z=13,t=4)'
  'define sd14=ac(z=14,t=4)'
  'define sd15=ac(z=15,t=4)'
  'define sd16=ac(z=16,t=4)'
  'define sd17=ac(z=17,t=4)'
  'define sd18=ac(z=18,t=4)'
  'define sd19=ac(z=19,t=4)'
  'define sd20=ac(z=20,t=4)'
  'define sd21=ac(z=21,t=4)'
  'define sd22=ac(z=22,t=4)'
  'define sd23=ac(z=23,t=4)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=23
nframe2=12
xmin0=0.5;  xlen=3.5;  xgap=0.5
ymax0=10.2; ylen=-0.75;  ygap=-0.0
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
  titly=ymax-0.1
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set z 1'
'set x 1 18'
'set xlab off'
if(iframe = 12); 'set xlab on'; endif
if(iframe = 23); 'set xlab on'; endif
'set grads off'
*'set grid off'
'set gxout bar'
'set bargap 50'
'set barbase 0.'
'set ccolor 11'
'set xaxis 1 18 2'
'set vrange 0. 0.99'
'set ylint 0.5'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  79/80'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  80/81'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  81/82'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  82/83'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  83/84'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly'  84/85'; endif
 if(iframe = 7); 'draw string 'titlx' 'titly'  85/86'; endif
 if(iframe = 8); 'draw string 'titlx' 'titly'  86/87'; endif
 if(iframe = 9); 'draw string 'titlx' 'titly'  87/88'; endif
 if(iframe = 10); 'draw string 'titlx' 'titly'  88/89'; endif
 if(iframe = 11); 'draw string 'titlx' 'titly'  89/90'; endif
 if(iframe = 12); 'draw string 'titlx' 'titly'  90/91'; endif
 if(iframe = 13); 'draw string 'titlx' 'titly'  91/92'; endif
 if(iframe = 14); 'draw string 'titlx' 'titly'  92/93'; endif
 if(iframe = 15); 'draw string 'titlx' 'titly'  93/94'; endif
 if(iframe = 16); 'draw string 'titlx' 'titly'  94/95'; endif
 if(iframe = 17); 'draw string 'titlx' 'titly'  95/96'; endif
 if(iframe = 18); 'draw string 'titlx' 'titly'  96/97'; endif
 if(iframe = 19); 'draw string 'titlx' 'titly'  97/98'; endif
 if(iframe = 20); 'draw string 'titlx' 'titly'  98/99'; endif
 if(iframe = 21); 'draw string 'titlx' 'titly'  99/00'; endif
 if(iframe = 22); 'draw string 'titlx' 'titly'  00/01'; endif
 if(iframe = 23); 'draw string 'titlx' 'titly'  01/02'; endif
*
  iframe=iframe+1
endwhile
'print'
*
*'c'
 'set vpage off'
