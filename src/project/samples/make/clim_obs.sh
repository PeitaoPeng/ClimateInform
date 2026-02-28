set -x
#
#  calculate clim for calculating decadal trend
#                
#---------

model=reanl

y1s=50
y1e=67
mn1s=0
mn1e=216
y2s=85
y2e=94
mn2s=432
mn2e=540

datadir=/export-6/cacsrv1/wd52pp/obs/$model
cd $datadir

#for vname in temp prcp; do
for vname in z500; do

imax=144
jmax=73
dx=2.5

>intt
echo $vname>>intt  
echo $y1s>>intt  
echo $y1e>>intt  
echo $mn1s>>intt  
echo $mn1e>>intt  
echo $y2s>>intt  
echo $y2e>>intt  
echo $mn2s>>intt  
echo $mn2e>>intt  
echo $imax>>intt    ;# grid # in x
echo $jmax>>intt    ;# grid # in y

cat >int<<fEOF
reinit
run temp.gs
fEOF

cat intt>>int

cat >temp.gs<<EOF
    'reinit'
    'set display color white'
    'c'
    'run /export/sun10/wd01ak/grd/rgbset.gs'

pull var
pull y1s
pull y1e
pull mn1s
pull mn1e
pull y2s
pull y2e
pull mn2s
pull mn2e
pull imax
pull jmax

*'open 'var'_50cur.ctl'
'open /export/sgi57/wd52pp/data/z500_50019812.ctl'
'set gxout fwrite'
'set fwrite 'var'_'y1s''y1e'clim.gr'
'set x 1 'imax''
'set y 1 'jmax''
'set t 1 12'
'define clim=ave(z,t+'mn1s',t='mn1e',1yr)'
'modify clim seasonal'
'd clim'
'reinit'
*'open 'var'_50cur.ctl'
'open /export/sgi57/wd52pp/data/z500_50019812.ctl'
'set gxout fwrite'
'set fwrite 'var'_'y2s''y2e'clim.gr'
'set x 1 'imax''
'set y 1 'jmax''
'set t 1 12'
'define clim=ave(z,t+'mn2s',t='mn2e',1yr)'
'modify clim seasonal'
'd clim'
EOF

/home/sgi90/wd23mk/GrADS-1.7Beta3/bin/grads -pb <int
\rm intt int temp.gs

# control file for the above data

cat>${vname}_$y1s${y1e}clim.ctl<<EOF
dset ^${vname}_$y1s${y1e}clim.gr
undef -9999
title EXP1
xdef  $imax linear   0.0  $dx
ydef  $jmax linear -90.0  $dx
zdef    1 levels 200
tdef 99 linear     jan1950   1mon
vars  1
z     1 99 500mb height
endvars
EOF

cat>${vname}_$y2s${y2e}clim.ctl<<EOF
dset ^${vname}_$y2s${y2e}clim.gr
undef -9999
title EXP1
xdef  $imax linear  0.0  $dx
ydef  $jmax linear -90.0  $dx
zdef    1 levels 200
tdef 99 linear     jan1950   1mon
vars  1
z     1 99 500mb height
endvars
EOF

done
exit
