'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
clm=1c
nt=7
'open /cpc/home/wd52pp/data/nn/cfsv2/skill.vs.lead.nino34.djf.1c.ctl'
'open /cpc/home/wd52pp/data/nn/cfsv2/skill.vs.lead.nino34.djf.2c.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.cons.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Skill of NINO3.4 Index FCST for DJF 1983-2018'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.;  xlen=6.5;  xgap=0.75
ymax0=9.75; ylen=-3.75;  ygap=-1.
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
  lx1=xmin+0.5
  lx2=xmin+3.
  ly11=ymin+1.5
  ly21=ymin+1.2
  ly31=ymin+0.9
  ly41=ymin+0.6
  ly12=ymin+1.5
  ly22=ymin+1.2
  ly32=ymin+0.9
  ly42=ymin+0.6
  xlabx=xmin+3.25
  xlaby=ymin-0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
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
if(iframe = 1);'set vrange 0.60 1';endif
if(iframe = 2);'set vrange 0. 1';endif
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 'nt''
'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
if(iframe = 1); 'd acm.2'; endif
if(iframe = 2); 'd rmsm.2'; endif
'set ccolor 4'
if(iframe = 1); 'd acm'; endif
if(iframe = 2); 'd rmsm'; endif
'set ccolor 2'
if(iframe = 1); 'd acn.2'; endif
if(iframe = 2); 'd rmsn.2'; endif
'set ccolor 1'
*if(iframe = 1); 'd acm.2'; endif
*if(iframe = 2); 'd rmsm.2'; endif
'set ccolor 9'
if(iframe = 1); 'd acn'; endif
if(iframe = 2); 'd rmsn'; endif
*----------
'set strsiz 0.14 0.14'
'set string 4 tl 6'
if(iframe = 1);'draw string 'lx1' 'ly11' CFSv2(1 Clim)'; endif
if(iframe = 2);'draw string 'lx2' 'ly12' CFSv2(1 Clim)'; endif
'set string 1 tl 6'
if(iframe = 1);'draw string 'lx1' 'ly21' CFSv2(2 Clim)'; endif
if(iframe = 2);'draw string 'lx2' 'ly22' CFSv2(2 Clim)'; endif
'set string 9 tl 6'
if(iframe = 1);'draw string 'lx1' 'ly31' ANN(1_Clim input)';endif
if(iframe = 2);'draw string 'lx2' 'ly32' ANN(1_Clim input)';endif
'set string 2 tl 6'
if(iframe = 1);'draw string 'lx1' 'ly41' ANN(2_Clim input)';endif
if(iframe = 2);'draw string 'lx2' 'ly42' ANN(2_Clim input)';endif
'set string 1 tl 5'
if(iframe = 1); 'draw string 'tx' 'ty' a) AC'; endif
if(iframe = 2); 'draw string 'tx' 'ty' b) RMSE'; endif
iframe=iframe+1
endwhile
'print'
'printim cfsv2.skill_vs_ld.ts.grd.djf.png gif x600 y800'
*'c'
 'set vpage off'
*----------
