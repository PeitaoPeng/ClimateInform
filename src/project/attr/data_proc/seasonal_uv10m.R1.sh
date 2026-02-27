#!/bin/sh
set -eaux

# have 4 season sst and nino34 index
#
var=v10m
tmax=1   # from jan1979
tmax=490   # 41yrs*12mon

tmpdir=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/CFSv2_bias

cd $tmpdir

inpfile=$var.R1.2.5x2.5
outfile=$var.R1.anom.djf
outfile2=$var.R1.djf

cat >int<<fEOF
reinit
run season.gs
fEOF

cat >season.gs<<gsEOF
'reinit'
'open $inpfile.ctl'
'set gxout fwrite'
'set fwrite $outfile.gr'
'set x 1 144'
'set y 1  73'
'set t 1 12'
* clim calculation
'define clim=ave(z,t+0,t=492,1yr)'
'modify clim seasonal'
'set t 1'
*1st is jf of 1st year
'd ave(z-clim,t=1,t=2)'
k=11
while(k<=$tmax)
ks=k+1
ke=k+3
'd ave(z-clim,t='ks',t='ke')'
k=k+12
endwhile
'd ave(clim,t=12,t=14)'
gsEOF

grads -pb <int

cat>$outfile.ctl<<EOF
dset ^$outfile.gr
*
undef 9.999E+20
*
options little_endian
*
ydef  73 linear -90.  2.5
xdef 144 linear   0.  2.5
tdef 1200 linear 00Z01jan1979 1mo
*
ZDEF 1 LEVELS 1
*
VARS 1
z 1  99   uv10m
ENDVARS
EOF

#mv $outfile.gr  $datadir
#mv $outfile.ctl $datadir

cat >int2<<fEOF2
reinit
run season.gs
fEOF2

cat >season.gs<<gsEOF2
'reinit'
'open $inpfile.ctl'
'set gxout fwrite'
'set fwrite $outfile2.gr'
'set x 1 144'
'set y 1  73'

'set t 1'
*1st is jf of 1st year
'd ave(z,t=1,t=2)'
k=11
while(k<=$tmax)
ks=k+1
ke=k+3
'd ave(z,t='ks',t='ke')'
k=k+12
endwhile
gsEOF2

grads -pb <int2

cat>$outfile2.ctl<<EOF2
dset ^$outfile2.gr
UNDEF  -999.0
TITLE monthly  z200
*
xdef 144 linear 0. 2.5
*
ydef  73 linear -90. 2.5
*
ZDEF 1 LEVELS 1
*
TDEF 9999 LINEAR  jan1979 1yr
*
VARS 1
z  1   99   djf avg
ENDVARS
EOF2
#mv $outfile2.gr  $datadir
#mv $outfile2.ctl $datadir
