* clim of itcz prate
'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/LF_prd/corr.temp.vs.rsd_rcoef.z200_5002jfm.ntd_ifrc_2.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/corr.temp.vs.trend.ctl'
'enable print  meta.clim'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define vsst=corr(t=1)*corr(t=1)+corr(t=2)*corr(t=2)'
  'define vz2001=corr(t=3)*corr(t=3)+corr(t=4)*corr(t=4)'
  'define vz2002=corr(t=6)*corr(t=6)+corr(t=9)*corr(t=9)'
  'define vtrd=corr.2(t=1)*corr.2(t=1)'
  'define stdv1=100*vtrd'
  'define stdv3=100*vsst'
  'define stdv2=100*(vz2001+vz2002)'
  'define stdv4=100*(vtrd+vsst+vz2001+vz2002)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 variance fraction (%) explained by major indices'
'draw string 4.25 10.2 2mt JFM 1950-2002'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.5;  xlen=3.25;  xgap=0.5
ymax0=9.0; ylen=-2.50;  ygap=-0.0
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.0
  titly=ymax+0.0
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj nps'
'set lat 25 80'
'set lon 190 310'
*'set yaxis -25 25 10'
*if(iframe > 8); 'set lat 0 80'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs  10 20 30 40 50 60 70'
'set ccols  0 22 23 24 25 26 27 29'
'set xlab off'
'set ylab off'
'd stdv'%iframe
'set gxout contour'
'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*if(iframe > 8); 'set clevs -1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1'; endif
'set clopts -1 3 0.05'
'set cthick 4'
*'d stdv'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' linear trend'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' 2 SST modes'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' 4 Z200 modes'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' SUM'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 3.5'
endwhile
'print'
*'c'
 'set vpage off'
*----------
