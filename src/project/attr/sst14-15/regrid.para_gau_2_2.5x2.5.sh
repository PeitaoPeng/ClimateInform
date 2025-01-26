#!/bin/sh
set -eaux
#
# interpolate flx data to the grid of corresponding obs data
#
tmax=704  #704=aug2015

inpfile1=u10m.esm.amip.para
inpfile2=v10m.esm.amip.para
outfile=uv10m.esm.amip.para.mon.2.5x2.5
outfile2=uv10m.esm.amip.para.mon.anom.2.5x2.5
outfile3=uv10m.esm.amip.para.3mon.anom.2.5x2.5

tmpdir=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/attr/sst14-15

cd $tmpdir

cat >int<<fEOF
reinit
run regrid.gs
fEOF

cat >regrid.gs<<gsEOF
'reinit'
'open $datadir/$inpfile1.ctl'
'open $datadir/$inpfile2.ctl'
'open /cpc/home/wd52pp/data/attr/sst14-15/out2.2.5x2.5.ctl'
'set gxout fwrite'
'set fwrite $outfile.gr'
nt=1
while ( nt <= $tmax)

'set t 'nt
say 'time='nt
'set lon 0 357.5'
'set lat -90 90'
'd lterp(z,z.3(t=1))'
'd lterp(z.2,z.3(t=1))'

nt=nt+1
endwhile
gsEOF

grads -pb <int

cat>$outfile.ctl<<EOF
dset ^$outfile.gr
undef -9.99E+8
*
options little_endian
*
ydef  73 linear -90.  2.5
xdef 144 linear   0.  2.5
tdef 1200 linear jan1957 1mo
*
ZDEF 1 LEVELS 1
*
VARS 2
u 1  99   u10m
v 1  99   v10m
ENDVARS
EOF
#=======================================
# have 3-mon avg anomalies
#=======================================
cat >anom<<fEOF
reinit
run anom.gs
fEOF

cat >anom.gs<<gsEOF
'reinit'
'open $outfile.ctl'
'set x 1 144'
'set y 1  73'
'set t 1 12'
'define uc=ave(u,t+288,t=648,1yr)'
'define vc=ave(v,t+288,t=648,1yr)'
'modify uc seasonal'
'modify vc seasonal'
'set t 1'
'set gxout fwrite'
'set fwrite $outfile2.gr'
nt=1
while ( nt <= $tmax)

'set t 'nt
say 'time='nt
'd u-uc'
'd v-vc'

nt=nt+1
endwhile
gsEOF

grads -pb <anom

cat>$outfile2.ctl<<EOF
dset ^$outfile2.gr
undef -9.99E+8
*
options little_endian
*
ydef  73 linear -90.  2.5
xdef 144 linear   0.  2.5
tdef 1200 linear jan1957 1mo
*
ZDEF 1 LEVELS 1
*
VARS 2
u 1  99   u10m
v 1  99   v10m
ENDVARS
EOF

#=======================================
# have 3-mon avg anomalies
#=======================================
ts=2
te=`expr $tmax - 1`
#
cat >3mavg<<EOF
run have3mavg.gs
EOF
#
cat >have3mavg.gs<<EOF
'reinit'
'open $outfile2.ctl'
'set x 1 144'
'set y 1  73'
'set gxout fwrite'
'set fwrite $outfile3.gr'
k=$ts
while ( k <= $te)
'set t 'k''
'd ave(u,t-1,t+1)'
'd ave(v,t-1,t+1)'
k=k+1
endwhile
'c'
EOF
#
grads -l <3mavg
#
cat>$outfile3.ctl<<EOF
dset ^$outfile3.gr
undef -9.99E+8
ydef  73 linear -90.  2.5
xdef 144 linear   0.  2.5
tdef 1200 linear feb1957 1mo
zdef 1 linear 1 1
vars 2
u  0 99 u10m
v  0 99 v10m
ENDVARS
EOF

mv $outfile2.*  $datadir
mv $outfile3.* $datadir

