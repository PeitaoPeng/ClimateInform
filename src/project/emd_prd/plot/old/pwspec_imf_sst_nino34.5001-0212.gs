'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/emd/pwspec_imf_ersst_nino34.5001-0212.ctl'
'enable print  meta.imf'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define ps1=ps(t=1)'
  'define ps2=ps(t=5)'
  'define ps3=ps(t=4)'
  'define ps4=ps(t=6)'
  'define rt1=rt(t=1)'
  'define rt2=rt(t=5)'
  'define rt3=rt(t=4)'
  'define rt4=rt(t=6)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Fourier power spectrum of monthly nino3.4 ERSST index'
 'draw string 4.25 10.2 1950-2002'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.75;  xlen=3.5;  xgap=0.5
ymax0=9.25; ylen=-2.5;  ygap=-0.75
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
  titly=ymax+0.20
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
 'set xflip on'
 'set zlog on'
 'set xyrev on'
 'set z 7 120'
 'set ccolor 0'
 'd ps(t=1)'
 'set cmark 0'
 'set ccolor 1'
 'd ps'%iframe
 'set ccolor 1'
 'set cmark 3'
 if(iframe = 1);'d rt'%iframe; endif
 'define zero=0.0'
 'set cmark 0'
 'set ccolor 1'
 'd zero'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  Nino3.4'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  IMF 3'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  IMF 4'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  IMF 5'; endif
*
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 2.3'
endwhile
'print'
*'c'
 'set vpage off'
*----------
