'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
var=SSHem
clim=2c
nlead=7
nt=12+nlead
#model=NMME
model=CFSv2
'open /cpc/consistency/nn/cfsv2_ww/skill.'var'_2_nino34.ld1-'nlead'.'clim'.ctl'
'open /cpc/consistency/nn/cfsv2_ww/skill.'var'_2_nino34.ld1-'nlead'.1c.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print skill.meta'
*
*---------------------------string/caption
*
'set string 1 tc 4'
'set strsiz 0.18 0.18'
*'draw string 5.5 8.0 AC Skill of NMME NINO3.4 FCST (1982-2019)'
'draw string 5.5 8.0 AC Skill of CFSv2 NINO3.4 FCST (1982-2019)'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.;  xlen=9.5;  xgap=0.75
ymax0=7.7; ylen=-7;  ygap=-0.65
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.15
  titly=ymax+0.2
  xstr=xmin-0.5
  ystr=ymin+2.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
ic=1
while ( ic <= 12 )
'set e 'ic''
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
'set xlabs JFM | FMA | MAM | AMJ | MJJ | JJA | JAS | ASO | SON | OND | NDJ | DJF | JFM | FMA | MAM | AMJ | MJJ | JJA |'
*'set xlabs | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec | Jan | Feb | Mam | Apr | May | Jun | Jul | Aug | Sep | Oct |'
*'set ylab off'
'set vrange 0.2 1 0.05'
'set gxout line'
'set t 1 'nt''
'set cmark 2'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd acm'
'set cmark 2'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'd acn.2'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
 'define zero=0.'
 'set cstyle 1'
 'set cthick 5'
 'set cmark 0'
 'set ccolor 1'
 'd zero'
*----------
  ic=ic+1
endwhile
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.15 0.15'
'set string 1 tl 5'
'draw string 5.8 3.4 'model'(2_clim)'
'set string 2 tl 4'
'draw string 5.8 3.1 ANN(1_clim),SSH input'
'set string 1 tc 5 '
'set strsiz 0.18 0.18'
'draw xlab Target Season'
'draw ylab AC'
'print'
'printim skill.'model'.ssh.png gif x800 y600'
*'c'
'set vpage off'
*----------
