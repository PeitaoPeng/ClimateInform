'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/prd_test/gocn.acc_t.vs.cd_ss.rms.ctl'
'open /cpc/home/wd52pp/data/prd_test/eocn.acc_t.vs.cd_ss.rms.sm.ctl'
'open /cpc/home/wd52pp/data/prd_test/gocn.acc_t.vs.cd_ss.rms.ss.ctl'
*
*'enable print meta.rms.ltp_vs_time'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.18 0.18'
'draw string 5.5 7.9 MSE/MSE`bWMO`n for 1991-2012'
*---------------------------set dimsnesion, page size and style
nframe=16
nframe2=4
nframe3=8
nframe4=12
xmin0=0.5;  xlen=2.5;  xgap=0.0
ymax0=7.25; ylen=-1.4; ygap=-0.
'set t 1'
'define sk1=rms10(t=12)'
'define sk2=rms10(t=3)'
'define sk3=rms10(t=6)'
'define sk4=rms10(t=9)'
'define sk5=rms15(t=12)'
'define sk6=rms15(t=3)'
'define sk7=rms15(t=6)'
'define sk8=rms15(t=9)'
'define sk9=rms.3(t=12)'
'define sk10=rms.3(t=3)'
'define sk11=rms.3(t=6)'
'define sk12=rms.3(t=9)'
'define sk13=1.023*rms.2(t=12)'
'define sk14=1.023*rms.2(t=3)'
'define sk15=1.023*rms.2(t=6)'
'define sk16=1.023*rms.2(t=9)'
'define s1=aave(sk1,x=1,x=36,y=1,y=19)'
'define s2=aave(sk2,x=1,x=36,y=1,y=19)'
'define s3=aave(sk3,x=1,x=36,y=1,y=19)'
'define s4=aave(sk4,x=1,x=36,y=1,y=19)'
'define s5=aave(sk5,x=1,x=36,y=1,y=19)'
'define s6=aave(sk6,x=1,x=36,y=1,y=19)'
'define s7=aave(sk7,x=1,x=36,y=1,y=19)'
'define s8=aave(sk8,x=1,x=36,y=1,y=19)'
'define s9=aave(sk9,x=1,x=36,y=1,y=19)'
'define s10=aave(sk10,x=1,x=36,y=1,y=19)'
'define s11=aave(sk11,x=1,x=36,y=1,y=19)'
'define s12=aave(sk12,x=1,x=36,y=1,y=19)'
'define s13=aave(sk13,x=1,x=36,y=1,y=19)'
'define s14=aave(sk14,x=1,x=36,y=1,y=19)'
'define s15=aave(sk15,x=1,x=36,y=1,y=19)'
'define s16=aave(sk16,x=1,x=36,y=1,y=19)'
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
  tlx=xmin-0.3
  tly=ymin+0.7
  tlx2=xmin+1.25
  tly2=ymax+0.2
  tlx3=xmin+1.75
  tly3=ymin-0.35
  tlx4=xmin+2.3
  tly4=ymin+0.3
*
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set xlab off'
'set ylab off'
'set lat 24 50'
'set x 3 33'
'set gxout shaded'
'set clevs  0.5 0.75 1.0'
'set ccols  0 22 24 27'
'd sk'%iframe
'set string 1 tc 5 90'
if(iframe = 1); 'draw string 'tlx' 'tly' DJF'; endif;
if(iframe = 2); 'draw string 'tlx' 'tly' MAM'; endif;
if(iframe = 3); 'draw string 'tlx' 'tly' JJA'; endif;
if(iframe = 4); 'draw string 'tlx' 'tly' SON'; endif;
'set string 1 tc 5 0'
if(iframe = 1); 'draw string 'tlx2' 'tly2' K=10'; endif;
if(iframe = 5); 'draw string 'tlx2' 'tly2' K=15'; endif;
if(iframe = 9); 'draw string 'tlx2' 'tly2' K(t)'; endif;
if(iframe = 13); 'draw string 'tlx2' 'tly2' EOCN'; endif;
*
'set string 4 tc 6'
'set strsiz 0.15 0.15'
if(iframe = 1); 'draw string 'tlx4' 'tly4' .91'; endif;
if(iframe = 2); 'draw string 'tlx4' 'tly4' .99'; endif;
if(iframe = 3); 'draw string 'tlx4' 'tly4' .96'; endif;
if(iframe = 4); 'draw string 'tlx4' 'tly4' .94'; endif;
if(iframe = 5); 'draw string 'tlx4' 'tly4' .92'; endif;
if(iframe = 6); 'draw string 'tlx4' 'tly4' .92'; endif;
if(iframe = 7); 'draw string 'tlx4' 'tly4' .91'; endif;
if(iframe = 8); 'draw string 'tlx4' 'tly4' .94'; endif;
if(iframe = 9); 'draw string 'tlx4' 'tly4' .92'; endif;
if(iframe = 10); 'draw string 'tlx4' 'tly4' .91'; endif;
if(iframe = 11); 'draw string 'tlx4' 'tly4' .90'; endif;
if(iframe = 12); 'draw string 'tlx4' 'tly4' .94'; endif;
if(iframe = 13); 'draw string 'tlx4' 'tly4' .83'; endif;
if(iframe = 14); 'draw string 'tlx4' 'tly4' .99'; endif;
if(iframe = 15); 'draw string 'tlx4' 'tly4' .87'; endif;
if(iframe = 16); 'draw string 'tlx4' 'tly4' .83'; endif;
iframe=iframe+1
'set strsiz 0.18 0.18'
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 1.2'
'print'
'printim skill_rms.4p.png gif x800 y600'
*'set vpage off'
