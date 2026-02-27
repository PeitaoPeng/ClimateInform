  'reinit'
  'open land.mask.global.gri0.500m.lnx.ctl'
  'set grid off'
  'set grads off'
  'set gxout grfill'
  'set t 1'
  'set z 1'
  'set lat -90 90'
  'set lon -30 360'
*
xmin=1.0
xmax=10.0
ymin=1.0
ymax=8.0
*
xstr=11/2
ystr=8.3
  'set strsiz 0.20'
  'set string 1 c 6 0'
*  'draw string 'xstr' 'ystr' Land Mask'
*
x1=xmin
x2=xmax
y2=ymax
y1=ymin
  'set parea 'x1' 'x2' 'y1' 'y2
  'set ccols  1 2 3 4'
  'set clevs -1 0 1'
  'd land.1'
  'run cbarhov1.gs'
  'draw title land mask (0.50x0.50 box)'
********************************
