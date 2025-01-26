'reinit'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/sst_-SESAT_select_jfm.31-02.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
'define ff1=z(t=1)'
'define ff2=z(t=3)'
'define ff3=z(t=5)'
'define ff4=z(t=7)'
'define ff5=z(t=9)'
'define ff6=z(t=11)'
'define ff7=z(t=13)'
*
'define ff8=z(t=2)'
'define ff9=z(t=4)'
'define ff10=z(t=6)'
'define ff11=z(t=8)'
'define ff12=z(t=10)'
'define ff13=z(t=12)'
'define ff14=z(t=14)'
*
'define ff15=z(t=15)'
'define ff16=z(t=17)'
'define ff17=z(t=19)'
'define ff18=z(t=21)'
'define ff19=z(t=23)'
*
'define ff20=z(t=16)'
'define ff21=z(t=18)'
'define ff22=z(t=20)'
'define ff23=z(t=22)'
'define ff24=z(t=24)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.9 1931-2002 JFM SST for US T`bsfc`n RPC2 < -stdv'
 'set strsiz 0.10 0.10'
 'draw string 4.25 10.7 anom wrt clim 31-66 & 67-02 respectively'
*---------------------------set dimsnesion, page size and style
nframe=14
nframe2=7
xmin0=1.5;  xlen=2.5;  xgap=0.2
ymax0=10.0; ylen=-1.00;  ygap=-0.2
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
  titly=ymax+0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
  'set xlab off'
  'set ylab off'
*
'set lat -30 70'
'set ylint 5'
'set lon 0 360'
'set xlint 10'
'set grads off'
'set grid off'
'set poli on'
'set mpdset mres'
'set map 1 1 1'
*
'set gxout shaded'
'set grads off'
'set clevs  -1.25 -1.0 -0.75 -0.5 -0.25 0.25 0.5 0.75 1.0 1.25';
'set ccols  49 47 45 43 41 0 21 23 25 27 29';
'd  ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
if(iframe = 1); 'draw string 'titlx' 'titly' 1932'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' 1935'; endif
if(iframe = 3); 'draw string 'titlx' 'titly' 1938'; endif
if(iframe = 4); 'draw string 'titlx' 'titly' 1949'; endif
if(iframe = 5); 'draw string 'titlx' 'titly' 1950'; endif
if(iframe = 6); 'draw string 'titlx' 'titly' 1952'; endif
if(iframe = 7); 'draw string 'titlx' 'titly' 1953'; endif
if(iframe = 8); 'draw string 'titlx' 'titly' 1933'; endif
if(iframe = 9); 'draw string 'titlx' 'titly' 1936'; endif
if(iframe = 10); 'draw string 'titlx' 'titly' 1939'; endif
if(iframe = 11); 'draw string 'titlx' 'titly' 1950'; endif
if(iframe = 12); 'draw string 'titlx' 'titly' 1951'; endif
if(iframe = 13); 'draw string 'titlx' 'titly' 1953'; endif
if(iframe = 14); 'draw string 'titlx' 'titly' 1954'; endif
*
  iframe=iframe+1
if(iframe = 14); 'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.6 0 4.25 1.25'; endif
endwhile
'print'
'c'
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.9 1931-2002 JFM SST for US T`bsfc`n RPC2 < -stdv'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.7 anom wrt clim 31-66 & 67-02 respectively'
*
nframe=10
nframe2=5
xmin0=1.5;  xlen=2.5;  xgap=0.2
ymax0=10.0; ylen=-1.00;  ygap=-0.2
*
iframe=1
while ( iframe <= nframe )
iplot=iframe+14
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.25
  titly=ymax+0.15
* say xmin; say xmax; say ymin; say ymax
 'set vpage off'
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
  'set xlab off'
  'set ylab off'
*
'set lat -30 70'
'set ylint 5'
'set lon 0 360'
'set xlint 10'
'set grads off'
'set grid off'
'set poli on'
'set mpdset mres'
'set map 1 1 1'
*
'set gxout shaded'
'set grads off'
'set clevs  -1.25 -1.0 -0.75 -0.5 -0.25 0.25 0.5 0.75 1.0 1.25';
'set ccols  49 47 45 43 41 0 21 23 25 27 29';
'd  ff'%iplot
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
if(iframe = 1); 'draw string 'titlx' 'titly' 1957'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' 1974'; endif
if(iframe = 3); 'draw string 'titlx' 'titly' 1976'; endif
if(iframe = 4); 'draw string 'titlx' 'titly' 1990'; endif
if(iframe = 5); 'draw string 'titlx' 'titly' 2000'; endif
if(iframe = 6); 'draw string 'titlx' 'titly' 1958'; endif
if(iframe = 7); 'draw string 'titlx' 'titly' 1975'; endif
if(iframe = 8); 'draw string 'titlx' 'titly' 1977'; endif
if(iframe = 9); 'draw string 'titlx' 'titly' 1991'; endif
if(iframe = 10); 'draw string 'titlx' 'titly' 2001'; endif
*
  iframe=iframe+1
if(iframe = 10); 'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.6 0 4.25 3.75'; endif
endwhile
'print'
*'c'
