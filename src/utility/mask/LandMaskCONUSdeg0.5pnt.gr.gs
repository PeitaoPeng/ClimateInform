  'reinit'
  'enable print fig.meta'
  'open LandMaskCONUSdeg0.5pnt.gr.ctl'
  'set gxout fwrite'
  'set fwrite LandMaskCONUSdeg0.5pnt.big'
  'set t 1'
  'set z 1'
  'set 
  'set grid off'
  'set grads off'
  'set gxout grfill'
  'set t 1'
  'set z 1'
  'set lat -90 90'
  'set lon -20 380'
*  'set mpdset mres'
*
xmin=0.5
xmax=8.0
ymin=0.5
ymax=10.5
b=1.0
dy=(ymax-ymin-b)/2
*
xstr=8.5/2
ystr=10.8
  'set strsiz 0.20'
  'set string 1 c 6 0'
*  'draw string 'xstr' 'ystr' Land Mask'
*
x1=xmin
x2=xmax
y2=ymax
y1=y2-dy
  'set parea 'x1' 'x2' 'y1' 'y2
  'set ccols  1 2 3 4'
  'set clevs -1 0 1'
  'd land.1'
  'run cbarhov1.gs'
  'draw title land mask (0.125x0.125 original)'
*
y2=y1-b
y1=y2-dy
  'set parea 'x1' 'x2' 'y1' 'y2
  'set ccols  1 2 3 4'
  'set clevs -1 0 1'
  'd land_ext.1'
  'run cbarhov1.gs'
  'draw title land mask (extension of 6 grids)'
  'print' 
****************************
