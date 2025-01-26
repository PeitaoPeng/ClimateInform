*  Script to draw an XY plot.
*  Does no Error checking on the input file at all.
*  Assumes the input file is set up as follows:
*
*    Line 1:  Title
*    Line 2:  X Axis Label
*    Line 3:  Y Axis Label (not drawn; needs a GrADS mod)
*    Line 4:  Axes Limits:  xmin xmax ymin ymax
*    Line 5:  Axes Labels:  xlow xint ylow yint
*    Line 6:  Data distribution: npairs ngroup diagline (1=yes)
*    Rest of lines:  X Y points
*
*  Also assumes that a file has been opened (any file, doesn't
*  matter -- the set command doesn't work until a file has been
*  opened).
*
function main(args)

'set display color white'
*'clear'

if (args='')
  say 'Enter File Name:'
  pull fname
else
  fname = args
endif

*  Read the 1st record: Title

ret = read(fname)
rc = sublin(ret,1)
if (rc>0)
  say 'read title'
  say 'File Error'
  return
endif
title = sublin(ret,2)

*  Read the 2nd record: X Label

ret = read(fname)
rc = sublin(ret,1)
if (rc>0)
  say 'read X lable'
  say 'File Error'
  return
endif
xlab = sublin(ret,2)

*  Read the 3rd record: Y Label

ret = read(fname)
rc = sublin(ret,1)
if (rc>0)
  say 'read Y lable'
  say 'File Error'
  return
endif
ylab = sublin(ret,2)

*  Read the 4th record: xmin xmax ymin ymax

ret = read(fname)
rc = sublin(ret,1)
if (rc>0)
  say 'File Error'
  return
endif
rec = sublin(ret,2)
xmin = subwrd(rec,1)
xmax = subwrd(rec,2)
ymin = subwrd(rec,3)
ymax = subwrd(rec,4)

*  Read the 5th record: xlow xint ylow yint

ret = read(fname)
rc = sublin(ret,1)
if (rc>0)
  say 'File Error'
  return
endif
rec = sublin(ret,2)
xlow = subwrd(rec,1)
xint = subwrd(rec,2)
ylow = subwrd(rec,3)
yint = subwrd(rec,4)

* Read the 6th record: npairs ngroup dialin

ret = read(fname)
rc = sublin(ret,1)
if (rc>0)
  say 'File Error'
  return
endif
rec = sublin(ret,2)
npairs = subwrd(rec,1)
ngroup = subwrd(rec,2)
dialin = subwrd(rec,3)

* Loop on the rest of the records: x y

*lx = 2.0
*by = 1.0
*rx = 9.0
*ty = 8.0

lx = 2.0
by = 1.0
rx = 9.0
ty = 8.0

xdif = xmax - xmin
xdif = (rx - lx)/xdif
ydif = ymax - ymin
ydif = (ty - by)/ydif

'set ccolor 1'
'set parea 'lx' 'rx' 'by' 'ty
'set line 1 1 6'
'draw line 'lx' 'by' 'rx' 'by
'draw line 'lx' 'by' 'lx' 'ty
'draw line 'lx' 'ty' 'rx' 'ty
'draw line 'rx' 'by' 'rx' 'ty
if (dialin=1)
 'set line 1 1 3'
 'draw line 'lx' 'by' 'rx' 'ty
endif
'set line 1 1 3'

jcnt = 1

while (jcnt<=ngroup)
 jcnt = jcnt+1
 icnt = 1
 first = 0
 'set ccolor 'jcnt
 pct = 110
 while (icnt<=npairs & 1)
   icnt = icnt+1
   ret = read(fname)
   rc = sublin(ret,1)
   if (rc>0)
    if (rc!=2)
      say 'File I/O Error'
      return
    endif
    break
   endif
   rec = sublin(ret,2)
   x = subwrd(rec,1)
   y = subwrd(rec,2)
   x = lx+(x-xmin)*xdif
   y = by+(y-ymin)*ydif
   say x' 'y
   if (first)
    'set line 'jcnt' 1 8'
    'draw line 'xold' 'yold' 'x' 'y
    
* draw penctile
    pct = pct-10
    if(pct<100)
    xm1 = xold - 0.4
    xm2 = xold + 0.2
    ym = yold + 0.075
    'set string 1 tl 4'
    if (jcnt=2)
    'draw string 'xm1' 'ym' 'pct'%'
    endif
    if (jcnt=3)
    'draw string 'xm2' 'ym' 'pct'%'
    endif
    endif

    'draw mark 'jcnt' 'xold' 'yold' 0.1'
    'set line 1'
    'draw mark 'jcnt' 'xold' 'yold' 0.1'
   endif
   first = 1
   xold = x
   yold = y
 endwhile

endwhile
'set line 0'
'draw mark 3 'xold' 'yold' 0.1'
'set line 1'
'draw mark 2 'xold' 'yold' 0.1'

* draw label numbers

'set line 1 1 5'
'set string 1 tc 5'
'set strsiz 0.15 0.17'
say xlow' 'xint' 'ylow' 'yint
xx = xlow*'1.0'
byi = by-0.04
bys = by-0.12
while (xx<=xmax & xx>=xmin)
  x = lx+(xx-xmin)*xdif
  'draw line 'x' 'by' 'x' 'byi
  'draw string 'x' 'bys' 'xx
  xx = xx + xint
endwhile
yy = ylow*'1.0'
lxi = lx-0.04
lxs = lx-0.10
'set string 1 r 5'
while (yy<=ymax & yy>=ymin)
  y = by+(yy-ymin)*ydif
  'draw line 'lxi' 'y' 'lx' 'y
  'draw string 'lxs' 'y' 'yy
  yy = yy + yint
endwhile

tx = (lx+rx)/2.0
ty = ty + 0.25
xx = (lx+rx)/2.0
yy = (ty+by)/2.0
xy = by - 0.5
yx = lx - 0.8
'set string 1 c 6'
'set strsiz 0.23 0.26'
'draw string 'tx' 'ty' 'title
'set strsiz 0.23 0.25'
'draw string 'xx' 'xy' 'xlab
'set string 1 tc 6 90'
'set strsiz 0.23 0.25'
'draw string 'yx' 'yy' 'ylab

* draw caption

* Read the last row: ROC areas

ret = read(fname)
rc = sublin(ret,1)
if (rc>0)
  say 'File Error'
  return
endif
rec = sublin(ret,2)
aroa = subwrd(rec,1)
arob = subwrd(rec,2)


'draw rec 5.75 1 9 2'
'set line 2 1 6'
'set string 1 tl 6 0'
'set strsiz 0.2 0.2'
'draw string 6. 1.5 ROC area: 'aroa
'printim roc_temp.cfs.upper.png gif x800 y600'



