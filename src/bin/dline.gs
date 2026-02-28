function dline(args)
x1=subwrd(args,1)
y1=subwrd(args,2)
x2=subwrd(args,3)
y2=subwrd(args,4)
*
*
'query ll2xy 'x1' 'y1
line=sublin(result,1)
x1pos=subwrd(line,1)
y1pos=subwrd(line,2)
say "x1 is "x1
say "x1pos="x1pos
say "y1 is "y1
say "y1pos="y1pos
*
'query ll2xy 'x2' 'y2
line=sublin(result,1)
x2pos=subwrd(line,1)
y2pos=subwrd(line,2)
say "x2 is "x2
say "x2pos="x2pos
say "y2 is "y2
say "y2pos="y2pos
*
'set line 1 1 4'
'draw line 'x1pos' 'y1pos' 'x2pos' 'y2pos
