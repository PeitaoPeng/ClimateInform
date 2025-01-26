*
'reinit'
'set font 1'
'run /cmb/d09/cgcm/cmp14/plots/lib/white.gs'
*
imo=01
'open /export-6/sgi9/wd20wq/projx/obs/mjo/mjoEQeofpcs.ctl'

'enable print fig.meta'

time='Jan2000 31Jul2002'
axlim='-40 40'

'set font 1'

xmin0=1.75
ymin0=10.0
xlen=5.
ylen=-9.0
xgap=0.05
ygap=-0.8
'set xlopts 1 2 0.10'
'set ylopts 1 2 0.10'

'set rgb  70  255 255 255'
'run /export-6/sgi9/wd20wq/common/rgbset.gs'

ifm=1
while ( ifm <= 1 )
 if (ifm = 1);ic=1;jc=1;endif
 if (ifm = 2);ic=1;jc=2;endif
 if (ifm = 1);'set xlab on ';'set ylab on ';endif
 if (ifm = 2);'set xlab on ';'set ylab on ';endif
 xpos=xmin0+(ic-1)*(xlen+xgap)
 xpos1=xpos+xlen
 ypos=ymin0+(jc-1)*(ylen+ygap)
 ypos1=ypos+ylen
 xpos1=xpos+xlen
 xposw=(xpos+xpos1)/2.-0.225
 yposw=ypos+0.12
 'set parea  'xpos' 'xpos1' 'ypos1' 'ypos
 'set grads off'
 'set grid on '
 'set mproj scaled'
 'set time 'time
 'set z 'ifm
 'set ylpos 0 l'
 'set xyrev on'
 'set yflip on'
 'set axlim 'axlim
 'set ylint 0.03'
 'set ccolor 2'
 'set cstyle 1'
 'set cthick 3'
 'set cmark 0'
 'd pc(z=1)'
 'set ccolor 4'
 'set cstyle 1'
 'set cthick 3'
 'set cmark 0'
 'd pc(z=2)'
 'set ccolor 2'
 'set cstyle 1'
 'set cthick 3'
 'set cmark 0'
  'define zero=8.8'
*'define zero=13.2'
 'd zero'
 'set ccolor 2'
 'set cstyle 1'
 'set cthick 3'
 'set cmark 0'
 'define zero=-8.8'
*'define zero=-13.2'
 'd zero'
 'set ccolor 4'
 'set cstyle 1'
 'set cthick 3'
 'set cmark 0'
 'define zero=10.3'
*'define zero=15.45'
 'd zero'
 'set ccolor 4'
 'set cstyle 1'
 'set cthick 3'
 'set cmark 0'
 'define zero=-10.3'
*'define zero=-15.45'
 'd zero'
 'set ccolor 1'
 'set cstyle 1'
 'set cthick 1'
 'set cmark 0'
 'define zero=0'
 'd zero'
 ifm=ifm+1
endwhile

yh=ypos+0.3
yht=yh+0.02
xl=2.4
dl=0.5
dvar=2.4
'set line 2 1 3'
'draw line 'xl' 'yht' 'xl+dl ' 'yht
'set strsiz .12'
'set string 2 bl 5'
'draw string 'xl+dl+0.1' 'yh' pc1'
xl=xl+dvar
'set line 4 1 3'
'draw line 'xl' 'yht' 'xl+dl ' 'yht
'set strsiz .12'
'set string 4 bl 5'
'draw string 'xl+dl+0.1' 'yh' pc2'

'set line 1 1 6'
 xrec1=xpos
 yrec1=yh-0.2
 xrec2=xpos+xlen
 yrec2=yh+0.2 
'draw rec 'xrec1' 'yrec1' 'xrec2' 'yrec2

*'set strsiz 0.14'
*'set string 1 bc 4 0'
*'draw string 4.25 10 EOFs'

'print'
'disable print fig.meta'
