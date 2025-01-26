'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/prd_test/gocn.acc_t.vs.cd_ss.rms.ctl'
*
*'enable print meta.rms.ltp_vs_time'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.18 0.18'
'draw string 4.45 10.25 Forecast Skill for K=OCN(t,s)'
*---------------------------set dimsnesion, page size and style
nframe=8
nframe2=4
nframe3=8
nframe4=8
xmin0=1.;  xlen=3.5;  xgap=0.1
ymax0=9.65; ylen=-2; ygap=-0.
'set t 1'
'define acc12=acc(t=12)'
'define acc3=acc(t=3)'
'define acc6=acc(t=6)'
'define acc9=acc(t=9)'
'define rms12=rms(t=12)'
'define rms3=rms(t=3)'
'define rms6=rms(t=6)'
'define rms9=rms(t=9)'
'define ac12=aave(acc12,x=1,x=36,y=1,y=19)'
'define ac3=aave(acc3,x=1,x=36,y=1,y=19)'
'define ac6=aave(acc6,x=1,x=36,y=1,y=19)'
'define ac9=aave(acc9,x=1,x=36,y=1,y=19)'
'define rm12=aave(rms12,x=1,x=36,y=1,y=19)'
'define rm3=aave(rms3,x=1,x=36,y=1,y=19)'
'define rm6=aave(rms6,x=1,x=36,y=1,y=19)'
'define rm9=aave(rms9,x=1,x=36,y=1,y=19)'
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
  tlx=xmin-0.35
  tly=ymin+1
  tlx2=xmin+1.75
  tly2=ymax+0.2
  tlx3=xmin+1.75
  tly3=ymin-0.35
  tlx4=xmin+3.1
  tly4=ymin+0.5
*
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set xlab off'
'set ylab off'
'set lat 24 50'
'set x 3 33'
'set gxout shaded'
'set clevs  20 30 40 50 60'
'set ccols  0 21 23 25 27 29' 
if(iframe > 4)
'set clevs  0.5 0.75 1.0'
'set ccols  0 22 24 26' 
endif
if(iframe = 1); 'd 100*acc12'; endif;
if(iframe = 2); 'd 100*acc3'; endif;
if(iframe = 3); 'd 100*acc6'; endif;
if(iframe = 4); 'd 100*acc9'; endif;
if(iframe = 5); 'd rms12'; endif;
if(iframe = 6); 'd rms3'; endif;
if(iframe = 7); 'd rms6'; endif;
if(iframe = 8); 'd rms9'; endif;
'set string 1 tc 5 90'
if(iframe = 1); 'draw string 'tlx' 'tly' DJF'; endif;
if(iframe = 2); 'draw string 'tlx' 'tly' MAM'; endif;
if(iframe = 3); 'draw string 'tlx' 'tly' JJA'; endif;
if(iframe = 4); 'draw string 'tlx' 'tly' SON'; endif;
'set string 1 tc 5 0'
if(iframe = 1); 'draw string 'tlx2' 'tly2' CORR(%)'; endif;
if(iframe = 5); 'draw string 'tlx2' 'tly2' RMSE(C)'; endif;
if(iframe = 4);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.6 0 'tlx3' 'tly3''; endif
if(iframe = 8);'run /cpc/home/wd52pp/bin/cbarn2.gs 0.6 0 'tlx3' 'tly3''; endif
*
'set string 4 tc 6'
'set strsiz 0.15 0.15'
if(iframe = 1); 'draw string 'tlx4' 'tly4' 39'; endif;
if(iframe = 2); 'draw string 'tlx4' 'tly4' 36'; endif;
if(iframe = 3); 'draw string 'tlx4' 'tly4' 33'; endif;
if(iframe = 4); 'draw string 'tlx4' 'tly4' 33'; endif;
if(iframe = 5); 'draw string 'tlx4' 'tly4' 0.86'; endif;
if(iframe = 6); 'draw string 'tlx4' 'tly4' 0.88'; endif;
if(iframe = 7); 'draw string 'tlx4' 'tly4' 0.86'; endif;
if(iframe = 8); 'draw string 'tlx4' 'tly4' 0.89'; endif;
iframe=iframe+1
'set strsiz 0.18 0.18'
endwhile
'print'
'printim skill.cd_ss.png gif x600 y800'
*'set vpage off'
