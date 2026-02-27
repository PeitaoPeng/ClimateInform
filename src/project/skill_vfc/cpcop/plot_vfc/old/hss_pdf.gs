'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss-pdf.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print Fig_12'
*
*---------------------------string/caption
*
'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 4.25 10.5 MC Test for HSS of US Seasonal SFC Temp Forecast'
*'draw string 4.25 10.15 (All data in time and grid points)'
 'draw string 4.25 10.15 (A Grid Point in SW USA)'
* 'draw string 4.25 10.15 (A Grid Point in Mid USA)'

*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.;  xlen=6.5;  xgap=0.75
ymax0=9.25; ylen=-3.5;  ygap=-1.25
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.25
  titly=ymax+0.25
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
 'set strsiz 0.18 0.18'
if(iframe = 1); 'draw string 'titlx' 'titly' All Data'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' Non-EC Only'; endif
'set t 1'
*'set frame off'
'set grads off'
'set grid off'
*'set xlab off'
*'set ylab off'
'set xaxis -20 100 5'
'set vrange 0.0 1.0'
'set ccolor 1'
'set gxout bar'
'set bargap 80'
*if(iframe = 1);'d hss1_all/50000'; endif
*if(iframe = 2);'d hss2_all/50000'; endif
 if(iframe = 1);'d hss1_sw/50000'; endif
 if(iframe = 2);'d hss2_sw/50000'; endif
*if(iframe = 1);'d hss1_md/50000'; endif
*if(iframe = 2);'d hss2_md/50000'; endif
'draw ylab PDF'
'draw xlab HSS'
*----------
  iframe=iframe+1
endwhile
'print'
*'printim hss_pdf_all.png gif x600 y800'
 'printim hss_pdf_sw.png gif x600 y800'
*'printim hss_pdf_md.png gif x600 y800'
*'c'
 'set vpage off'
*----------
