'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
nt=7
'open /cpc/home/wd52pp/data/nn/nmme/skill.vs.lead.nino34.djf.ctl'
'open /cpc/home/wd52pp/data/nn/nmme/skill.vs.lead.n34_only.djf.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print Fig1.meta'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*'draw string 5.5 7.5 Skill of NINO3.4 Index FCST for DJF 1983-2020'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=3.;  xlen=4.5;  xgap=0.75
ymax0=7.2; ylen=-2.5;  ygap=-1.
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tx=xmin
  ty=ymax+0.25
  lx1=xmin+0.3
  lx2=xmin+0.3
  lx3=xmin+0.5
  ly11=ymin+0.75
  ly21=ymin+0.5
  ly31=ymin+0.9
  ly12=ymin+2.3
  ly22=ymin+2.05
  ly32=ymin+2.7
  xlabx=xmin+2.25
  xlaby=ymin-0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set x 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set xlabs 1 | 2 | 3 | 4 | 5 | 6 | 7 '
 'set string 1 tc 4'
'draw string 'xlabx' 'xlaby' Lead Time (month)'
if(iframe = 1);'set vrange 0.75 1';endif
if(iframe = 2);'set vrange 0. 1';endif
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 'nt''
'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
if(iframe = 1); 'd acm'; endif
if(iframe = 2); 'd rmsm'; endif
'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
if(iframe = 1); 'd acn'; endif
if(iframe = 2); 'd rmsn'; endif
'set ccolor 4'
*if(iframe = 1); 'd acn.2'; endif
*if(iframe = 2); 'd rmsn.2'; endif
*----------
'set strsiz 0.14 0.14'
'set string 1 tl 5'
if(iframe = 1);'draw string 'lx1' 'ly11' NMME'; endif
if(iframe = 2);'draw string 'lx1' 'ly12' NMME'; endif
'set string 4 tl 5'
*if(iframe = 1);'draw string 'lx2' 'ly21' ANN (NINO3.4 index input)';endif
*if(iframe = 2);'draw string 'lx2' 'ly22' ANN (NINO3.4 index input)';endif
'set string 2 tl 5'
if(iframe = 1);'draw string 'lx2' 'ly21' ANN (TP SST input)';endif
if(iframe = 2);'draw string 'lx2' 'ly22' ANN (TP SST input)';endif
'set string 1 tl 5'
if(iframe = 1); 'draw string 'tx' 'ty' a) AC'; endif
if(iframe = 2); 'draw string 'tx' 'ty' b) RMS Error'; endif
iframe=iframe+1
endwhile
'print'
'printim Fig1.png gif x800 y600'
*'c'
 'set vpage off'
*----------
