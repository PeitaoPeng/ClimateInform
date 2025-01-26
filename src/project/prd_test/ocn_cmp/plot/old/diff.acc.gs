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
'draw string 4.45 10.25 CORR(%) Diff wrt K10'
*---------------------------set dimsnesion, page size and style
nframe=8
nframe2=4
nframe3=8
nframe4=8
xmin0=1.;  xlen=3.5;  xgap=0.1
ymax0=9.65; ylen=-2; ygap=-0.
'set t 1'
'define sk1=acc(t=12)-acc10(t=12)'
'define sk2=acc(t=3)-acc10(t=3)'
'define sk3=acc(t=6)-acc10(t=6)'
'define sk4=acc(t=9)-acc10(t=9)'
'define sk5=acc15(t=12)-acc10(t=12)'
'define sk6=acc15(t=3)-acc10(t=3)'
'define sk7=acc15(t=6)-acc10(t=6)'
'define sk8=acc15(t=9)-acc10(t=9)'
'define s1=aave(sk1,x=1,x=36,y=1,y=19)'
'define s2=aave(sk2,x=1,x=36,y=1,y=19)'
'define s3=aave(sk3,x=1,x=36,y=1,y=19)'
'define s4=aave(sk4,x=1,x=36,y=1,y=19)'
'define s5=aave(sk5,x=1,x=36,y=1,y=19)'
'define s6=aave(sk6,x=1,x=36,y=1,y=19)'
'define s7=aave(sk7,x=1,x=36,y=1,y=19)'
'define s8=aave(sk8,x=1,x=36,y=1,y=19)'
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
'set clevs  -25 -20 -15 -10 -5 0 5 10 15 20 25'
'set ccols  49 47 46 45 43 41 21 23 25 26 27 29' 
'd 100*sk'%iframe
'set string 1 tc 5 90'
if(iframe = 1); 'draw string 'tlx' 'tly' DJF'; endif;
if(iframe = 2); 'draw string 'tlx' 'tly' MAM'; endif;
if(iframe = 3); 'draw string 'tlx' 'tly' JJA'; endif;
if(iframe = 4); 'draw string 'tlx' 'tly' SON'; endif;
'set string 1 tc 5 0'
if(iframe = 1); 'draw string 'tlx2' 'tly2' K(t,s)-K10'; endif;
if(iframe = 5); 'draw string 'tlx2' 'tly2' K15-K10'; endif;
*
'set string 4 tc 6'
'set strsiz 0.15 0.15'
if(iframe = 1); 'draw string 'tlx4' 'tly4'  7'; endif;
if(iframe = 2); 'draw string 'tlx4' 'tly4' 20'; endif;
if(iframe = 3); 'draw string 'tlx4' 'tly4' 17'; endif;
if(iframe = 4); 'draw string 'tlx4' 'tly4'  8'; endif;
if(iframe = 5); 'draw string 'tlx4' 'tly4' -4'; endif;
if(iframe = 6); 'draw string 'tlx4' 'tly4' 11'; endif;
if(iframe = 7); 'draw string 'tlx4' 'tly4'  7'; endif;
if(iframe = 8); 'draw string 'tlx4' 'tly4' -5'; endif;
iframe=iframe+1
'set strsiz 0.18 0.18'
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 4.55 1.2'
'print'
'printim diff.acc.png gif x600 y800'
*'set vpage off'
