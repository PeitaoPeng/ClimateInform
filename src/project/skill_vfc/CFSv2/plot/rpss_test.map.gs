'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/rpss_test.temp.95-cur.cfsv1_v2.no_mix.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/rpss_test.prec.95-cur.cfsv1_v2.no_mix.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/rpss_test.temp.95-cur.cfsv1_v2.mix.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/rpss_test.prec.95-cur.cfsv1_v2.mix.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print rpss_test.mega'
*
*---------------------------string/caption
*
'define sk1=nsig1'
'define sk2=nsig1.2'
'define sk3=nsig2'
'define sk4=nsig2.2'
'define sk5=nsigdf.3'
'define sk6=nsigdf.4'

'set string 1 tc 6 0'
'set strsiz 0.14 0.14'
'draw string 5.5 8.0 Regions where RPSS Passes 5% Significance Level'
'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=2
nframe3=4
xmin0=1.;  xlen=3.;  xgap=0.1
ymax0=7.25; ylen=-2.;  ygap=-0.3
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
  titlx=xmin+2.
  titly=ymax+0.050
  t2x=xmin-0.4
  t2y=ymax-1.
  t3x=xmin+1.5
  t3y=ymax+0.4
  t4x=xmin+1.5
  t4y=ymax+0.1
  xbar=xmin+1.375
  ybar=ymin-1.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set xlab off'
'set ylab off'
'set grads off'
'set grid off'
'set gxout grfill'
'set mpdset mres'
'set rgb 80 125 125 125'
'set clevs  0'
'set ccols  0 80'
'd sk'%iframe
 'set string 1 tc 6 0'
 'set strsiz 0.14 0.14'
*----------
 if(iframe = 1); 'draw string 't3x' 't3y'  CFSv1'; endif
 if(iframe = 3); 'draw string 't3x' 't3y'  CFSv2'; endif
 if(iframe = 5); 'draw string 't3x' 't3y'  CFSv2-CFSv1'; endif
 'set strsiz 0.10 0.10'
 if(iframe = 1); 'draw string 't4x' 't4y'  24% passed'; endif
 if(iframe = 2); 'draw string 't4x' 't4y'  22% passed'; endif
 if(iframe = 3); 'draw string 't4x' 't4y'  66% passed'; endif
 if(iframe = 4); 'draw string 't4x' 't4y'  36% passed'; endif
 if(iframe = 5); 'draw string 't4x' 't4y'  56% passed'; endif
 if(iframe = 6); 'draw string 't4x' 't4y'  25% passed'; endif
 'set string 1 tc 6 90'
 'set strsiz 0.14 0.14'
 if(iframe = 1); 'draw string 't2x' 't2y'  Temp'; endif
 if(iframe = 2); 'draw string 't2x' 't2y'  Prec'; endif
*
  iframe=iframe+1
endwhile
 'set string 1 tc 5 0'
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 2.0'
'print'
'printim rpss_test.map.png gif x800 y600'
*'c'
 'set vpage off'
*----------
