#!/bin/sh
set -eaux

# interpolate 2d 2.5x2.5 data to 5x5 grid
model=R1
tmax=40  
var=z
vin=u10m
vout=u10m

inpfile=$vin.$model.anom.djf    #for simple, use 1-var ctl for input data
outfile=$vout.$model.anom.djf.5x5

tmpdir=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/CFSv2_bias

cd $tmpdir

cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $datadir/$inpfile.ctl'
'open $datadir/out.5x5.ctl'
'set gxout fwrite'
'set fwrite $outfile.gr'
nt=1
while ( nt <= $tmax)

'set t 'nt
say 'time='nt
'set lon 0 355.0'
'set lat -90 90'
'd lterp(z,z.2(t=1))'

nt=nt+1
endwhile
gsEOF

grads -pb <int

cat>$outfile.ctl<<EOF
dset ^$outfile.gr
undef 9.999E+20
*
options little_endian
*
ydef  37 linear -90.  5
xdef  72 linear   0.  5
tdef 999 linear jan1979 1mo
*
zdef 1 levels 1
*
VARS 1
z 1  99   hgt
ENDVARS
EOF

#mv $outfile.gr  $datadir
#mv $outfile.ctl $datadir
