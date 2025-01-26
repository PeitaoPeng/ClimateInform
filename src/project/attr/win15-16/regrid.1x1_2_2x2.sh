#!/bin/sh
set -eaux
#
# interpolate 1x1 data to 2x2
#
tmax=70 # djf of 79/80 to 98/99  

inpfile=hadoisst.djf.49-cur
outfile=hadoisst.djf.49-cur.2x2

tmpdir=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/attr/djf15-16

cd $tmpdir

cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $datadir/$inpfile.ctl'
'open $datadir/hadoisst.djf.49-cur.2x2.ctl'
'set gxout fwrite'
'set fwrite $outfile.gr'
nt=1
while ( nt <= $tmax)

'set t 'nt
say 'time='nt
'set lon 0.5 357.5'
'set lat -89.5 89.5'
'd lterp(sst,sst.2(t=1))'

nt=nt+1
endwhile
gsEOF

grads -pb <int

cat>$outfile.ctl<<EOF
dset ^$outfile.gr
options little_endian
undef -999000000
TITLE  3mon avg
XDEF 180 LINEAR    0.  2
YDEF  89 LINEAR  -88.  2.0
ZDEF 1 LEVELS 1
tdef 999 linear jan1950 1yr
VARS 1
sst  0 99     anom
ENDVARS
EOF

mv $outfile.*  $datadir

