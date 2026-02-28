#!/bin/sh
set -eaux
#
# interpolate flx data to the grid of corresponding obs data
# don't need to do shift even start/end lons are different
#
#tmax=1354   #jfm1900-ond2012
 tmax=766     #jfm1949-ond2012

#inpfile=ersst.3mon_mean.jfm1900-mam2013
#outfile=ersst.3mon_mean.jfm1900-ond2012.4x2
inpfile=ersst.3mon_mean.jfm1949-mam2013
outfile=ersst.3mon_mean.jfm1949-ond2012.4x2

tmpdir=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/obs/sst

cd $tmpdir

cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $datadir/$inpfile.ctl'
'open $datadir/out4x2.ctl'
'set gxout fwrite'
'set fwrite $outfile.gr'
nt=1
while ( nt <= $tmax)

'set t 'nt
say 'time='nt
'set lon 0 356.0'
'set lat -88 88'
'd lterp(sst,t.2(t=1))'

nt=nt+1
endwhile
gsEOF

grads -pb <int

cat>$outfile.ctl<<EOF
dset ^$outfile.gr
undef -999000000
*
options little_endian
*
xdef  90 linear   0.  4.
ydef  89 linear -88   2.
tdef 9999 linear jan1949 1mo
*
ZDEF 1 LEVELS 1
*
VARS 1
sst  1  99   had sst 
ENDVARS
EOF

mv $outfile.gr  $datadir
mv $outfile.ctl $datadir
