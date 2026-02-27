* z200 regr to nino34
'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/bias_skill/skill_bias.amip.z200.jfm.51-99.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print Fig_14'
*
*---------------------------string/caption
*
'define stdv1=rms(t=1)'
'define stdv2=rms(t=2)'
'define stdv3=rms(t=3)'
'define stdv4=rms(t=4)'
'define stdv5=rms(t=5)'
'define stdv6=rms(t=6)'
'define stdv7=rms(t=7)'
'define stdv8=rms(t=8)'
'define stdv9=rms(t=9)'
'define stdv10=rms(t=10)'
'define stdv11=rms(t=11)'

'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 5.5 8. Skill (RMS error) of AMIP JFM Z200'
*---------------------------set dimsnesion, page size and style
nframe=11
nframe2=4
nframe3=8
xmin0=0.75;  xlen=3.;  xgap=0.25
ymax0=7.5; ylen=-1.75;  ygap= 0.2
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
  titlx=xmin+1.
  titly=ymax-0.1
  numbx=xmin+2.
  numby=ymax-0.1
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lat 20 70'
'set lon 150 300'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs  10 20 30 40 50 60'
'set ccols   0 21 22 23 24 25 26'
'set xlab off'
'set ylab off'
*'set yaxis 80 80 10'
 'd stdv'%iframe
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
*'run /export/hobbes/wd52pp/bin/dline.gs 180 -80 180 80'
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
 'set strsiz 0.12 0.12'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' CAM2'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' CCM3'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' ECHAM3'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' ECHAM4.5'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' GFDL v1'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly' GFDL v2'; endif
 if(iframe = 7); 'draw string 'titlx' 'titly' GFDL v3'; endif
 if(iframe = 8); 'draw string 'titlx' 'titly' NSIPP'; endif
 if(iframe = 9); 'draw string 'titlx' 'titly' SFM v1'; endif
 if(iframe = 10); 'draw string 'titlx' 'titly' SFM v2'; endif
 if(iframe = 11); 'draw string 'titlx' 'titly' SFM v3'; endif
'set strsiz 0.12 0.12'
 if(iframe = 1); 'draw string 'numbx' 'numby' 47'; endif
 if(iframe = 2); 'draw string 'numbx' 'numby' 45'; endif
 if(iframe = 3); 'draw string 'numbx' 'numby' 49'; endif
 if(iframe = 4); 'draw string 'numbx' 'numby' 46'; endif
 if(iframe = 5); 'draw string 'numbx' 'numby' 47'; endif
 if(iframe = 6); 'draw string 'numbx' 'numby' 46'; endif
 if(iframe = 7); 'draw string 'numbx' 'numby' 44'; endif
 if(iframe = 8); 'draw string 'numbx' 'numby' 45'; endif
 if(iframe = 9); 'draw string 'numbx' 'numby' 49'; endif
 if(iframe = 10); 'draw string 'numbx' 'numby' 50'; endif
 if(iframe = 11); 'draw string 'numbx' 'numby' 48'; endif
*
 'run /export/hobbes/wd52pp/bin/cbarn2.gs 1. 0 5.5 0.75'
  iframe=iframe+1
endwhile
*'print'
'printim skill_rms.png gif x800 y600'
*'c'
 'set vpage off'
*----------
