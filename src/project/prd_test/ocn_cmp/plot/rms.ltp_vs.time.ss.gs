'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.djf.prog.rms.ctl'
'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.mam.prog.rms.ctl'
'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.jja.prog.rms.ctl'
'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.son.prog.rms.ctl'
*
*'enable print meta.rms.ltp_vs_time'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.5 RMSE of Temp(C) Forecast'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
nframe3=4
nframe4=4
xmin0=1.;  xlen=3.;  xgap=0.75
ymax0=9.75; ylen=-3.5;  ygap=-1.
*
'set t 1 22'
'define e1=rms'
'define e3=rms.2'
'define e2=rms.3'
'define e4=rms.4'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  if (iframe > nframe4); icx=4; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  if (iframe > nframe4); icy=iframe-nframe4; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin+1.5
  tly=ymin-0.3
  tlx2=xmin+1.5
  tly2=ymax+0.2
*
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set x 5 30'
'set xaxis 5 30 5'
'set gxout shaded'
'set clevs  0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0'
'set ccols  0 21 23 25 27 29 72 73 75 77 79' 
'd e'%iframe
'draw string 'tlx' 'tly' LTP(years)'
if(iframe = 1); 'draw string 'tlx2' 'tly2' DJF'; endif;
if(iframe = 2); 'draw string 'tlx2' 'tly2' JJA'; endif;
if(iframe = 3); 'draw string 'tlx2' 'tly2' MAM'; endif;
if(iframe = 4); 'draw string 'tlx2' 'tly2' SON'; endif;
iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1.0 0 4.25 0.9'
'print'
'printim rms.ltp_vs_time.png gif x600 y800'
*'set vpage off'
