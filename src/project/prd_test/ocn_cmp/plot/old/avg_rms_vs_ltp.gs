'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
*'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.djf.prog.rms.ctl'
'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.prog.rms.ctl'
'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.mam.prog.rms.ctl'
'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.jja.prog.rms.ctl'
'open /cpc/home/wd52pp/data/prd_skill/gocn_skill.vs.ltp.son.prog.rms.ctl'
*
*'enable print meta.avgrms.vs.ltp'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.5 AVG RMSE of Temp(C) Forecast over 1991-2012'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
nframe3=4
nframe4=4
xmin0=1.;  xlen=3.;  xgap=0.75
ymax0=9.75; ylen=-2.5;  ygap=-1.
*
'set t 1'
'define e1=sqrt(ave(rms*rms,t=1,t=22))'
'define e3=sqrt(ave(rms.2*rms.2,t=1,t=22))'
'define e2=sqrt(ave(rms.3*rms.3,t=1,t=22))'
'define e4=sqrt(ave(rms.4*rms.4,t=1,t=22))'
'define ee1=sqrt(ave(wrms*wrms,t=1,t=22))'
'define ee3=sqrt(ave(wrms.2*wrms.2,t=1,t=22))'
'define ee2=sqrt(ave(wrms.3*wrms.3,t=1,t=22))'
'define ee4=sqrt(ave(wrms.4*wrms.4,t=1,t=22))'
'define ac1=ave(acc,t=1,t=22)'
'define ac2=ave(acc.2,t=1,t=22)'
'define ac3=ave(acc.3,t=1,t=22)'
'define ac4=ave(acc.4,t=1,t=22)'
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
'set ylab on'
'set x 5 30'
'set xaxis 5 30 5'
*if(iframe = 1); 'set vrange 1.6 1.9'; endif;
if(iframe = 2); 'set vrange 0.9 1.1'; endif;
if(iframe = 3); 'set vrange 1.2 1.4'; endif;
if(iframe = 4); 'set vrange 0.9 1.1'; endif;
'd e'%iframe
'd ee'%iframe
'set vrange 0.0 1.0'
'set ylpos 0. r'
'd ac'%iframe
'draw string 'tlx' 'tly' LTP(years)'
if(iframe = 1); 'draw string 'tlx2' 'tly2' DJF'; endif;
if(iframe = 2); 'draw string 'tlx2' 'tly2' JJA'; endif;
if(iframe = 3); 'draw string 'tlx2' 'tly2' MAM'; endif;
if(iframe = 4); 'draw string 'tlx2' 'tly2' SON'; endif;
iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1.0 0 4.25 0.9'
'print'
'printim avgrms.vs.ltp.png gif x600 y800'
*'set vpage off'
