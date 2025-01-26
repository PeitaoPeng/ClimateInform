'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print temp_stdv_avgts.mega'
*
*---------------------------string/caption
*
'set string 1 tc 4'
'set strsiz 0.13 0.13'
*'draw string 5.5 8.25 CONUS Temp Variability'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.35;  xlen=4.5;  xgap=1.25
ymax1=7.75; ylen1=-3.;  ygap1=0.2
ylen2=-2.3; ymax2=7.4; ygap2=-0.5
*
iframe=1
while ( iframe <= nframe )

if(iframe=1 | iframe=2); ylen=ylen1; ymax0=ymax1; ygap=ygap1; endif
if(iframe=3 | iframe=4); ylen=ylen2; ymax0=ymax2; ygap=ygap2; endif

  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  ymin2=ymax+ylen
  titlx=xmin+2.25
  titly1=ymax-0.15
  titly2=ymax+0.17
if(iframe=1);
'open /cpc/home/wd52pp/data/prd_skill/temp_anom_1931-2011.jfm.2x2.ctl'
endif
if(iframe=2);
'open /cpc/home/wd52pp/data/prd_skill/temp_anom_1931-2011.jas.2x2.ctl'
endif
if(iframe=3);
'open /cpc/home/wd52pp/data/prd_skill/temp_usavg_1931-2011.jfm.ctl'
endif
if(iframe=4);
'open /cpc/home/wd52pp/data/prd_skill/temp_usavg_1931-2011.jas.ctl'
endif
*'set vpage 'xmin' 'xmax' 'ymin' 'ymax''
'set vpage 0 11 0 8.5'
'set parea 'xmin' 'xmax' 'ymin' 'ymax''
*
if(iframe=1 | iframe=2);
'set t 1'
*'set frame off'
'set grads off'
'set grid off'
'set xlab off'
'set ylab off'
'set y 3 16'
'set x 3 33'
'set gxout shaded'
'set clevs   0.5 0.75 1.0 1.25 1.5 2.0 2.5 3.0'
'set ccols   21 22 23 24 25 26 27 28 29'
'd sqrt(ave(t*t,t=1,t=81))'
'close 1'
endif
*----------
if(iframe=2);
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 1 5.2 4.85'
endif
'set string 1 tc 4'
'set strsiz 0.12 0.12'
if(iframe=1); 'draw string 'titlx' 'titly1' STDV of JFM Temp'; endif
if(iframe=2); 'draw string 'titlx' 'titly1' STDV of JAS Temp'; endif
if(iframe=3 | iframe=4);
'set t 1'
*'set frame off'
'set grads off'
'set vrange -2.5 2.5'
'set xlab on'
'set ylab on'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 5 77'
'define tm=ave(t,t-4,t+4)'
'set t 1 81'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'define zero=0.'
'd zero'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd t'
'set cmark 0'
'set cstyle 1'
'set cthick 8'
'set ccolor 3'
'd tm'
'close 1'
'set string 1 tc 4'
'set strsiz 0.12 0.12'
if(iframe=3); 'draw string 'titlx' 'titly2' CONUS Averaged JFM Temp'; endif
if(iframe=4); 'draw string 'titlx' 'titly2' CONUS Averaged JAS Temp'; endif
endif
*
iframe=iframe+1
endwhile
'print'
'printim temp_stdv_avgts.png gif x800 y600'
* 'c'  
 'set vpage off'
*----------
