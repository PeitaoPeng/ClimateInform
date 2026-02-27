'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/prd_test/gocn.prog.skill.vs.ltp.1991-2012.rms.ctl'
*
*'enable acc_vs_t.ltp'
*
*---------------------------string/caption
'set string 1 tc 5'
'set strsiz 0.18 0.18'
*'draw string 5.5 7.3 Skill vs Number of Training-data Windows(NTW)'
'draw string 5.5 7.3 Skill vs Length of Training Period(LTP)'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
nframe4=1
xmin0=1.5;  xlen=8.;  xgap=0.75
ymax0=7; ylen=-5;  ygap=-1.
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
  tlx=xmin+1.
  tly=ymax-0.3
  tlx2=xmin+1
  tly2=ymax-0.6
  tlx3=xmin+1
  tly3=ymax-0.9
  xl1=xmin-0.7
  yl1=ymax-2.5
  xl2=xmax+0.7
  yl2=ymax-2.5
*
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set vrange 0.2 0.3'
'set yaxis 0.2 0.3 0.01'
'set xaxis 1 30'
if(iframe = 1) 
'd acc' 
'set vrange 0.9 1.0'
'set yaxis 0.9 1.0 0.01'
'set ylpos 0. r'
'set ccolor 2'
'd (rms/wrms)*(rms/wrms)' 
endif
*
*'draw xlab Number of Training-data Windows'
'draw xlab Length of Training Period (years)'
'set strsiz 0.18 0.18'
'set string 1 tl 5'
'draw string 'tlx' 'tly'   ACC'
'set string 2 tl 5'
'draw string 'tlx2' 'tly2' MSE/MSE`bWMO`n'
'set string 3 tl 5'
*'draw string 'tlx3' 'tly3' RMS of WMO climate'
'set string 1 tc 5 90'
'draw string 'xl1' 'yl1' ACC'
'set string 1 tc 5 270'
'draw string 'xl2' 'yl2' MSE/MSE`bWMO`n'
iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1.0 0 4.25 0.9'
'print'
'printim skill_vs_ltp.png gif x800 y600'
*'set vpage off'
