set -x
#
#  calculate clim for calculating decadal trend
#                
#---------

model=b9x

y1s=50
y1e=67
mn1s=0
mn1e=216
y2s=85
y2e=94
mn2s=432
mn2e=540

datadir=/export-6/cacsrv1/wd52pp/$model
cd $datadir

for vname in z500 2mt prcp; do

imax=128
jmax=64
dx=2.8125

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

'open 'var'_5094.esm.ctl'
'set gxout fwrite'
'set fwrite 'var'_'y1s''y1e'clim.gr'
'set x 1 'imax''
'set y 1 'jmax''
'set t 1 12'
'define clim=ave(z,t+'mn1s',t='mn1e',1yr)'
'modify clim seasonal'
'd clim'
'reinit'
'open 'var'_5094.esm.ctl'
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
undef -9.99E+33
title EXP1
xdef  $imax linear  0.0  $dx
ydef  $jmax levels
 -87.864 -85.097 -82.313 -79.526 -76.737 -73.948 -71.158 -68.368 -65.578 -62.787
 -59.997 -57.207 -54.416 -51.626 -48.835 -46.045 -43.254 -40.464 -37.673 -34.883
 -32.092 -29.301 -26.511 -23.720 -20.930 -18.139 -15.348 -12.558  -9.767  -6.977
  -4.186  -1.395   1.395   4.186   6.977   9.767  12.558  15.348  18.139  20.930
  23.720  26.511  29.301  32.092  34.883  37.673  40.464  43.254  46.045  48.835
  51.626  54.416  57.207  59.997  62.787  65.578  68.368  71.158  73.948  76.737
  79.526  82.313  85.097  87.864
zdef    1 levels 200
tdef 99 linear     jan1950   1mon
vars  1
z     1 99 500mb height
endvars
EOF

cat>${vname}_$y2s${y2e}clim.ctl<<EOF
dset ^${vname}_$y2s${y2e}clim.gr
undef -9.99E+33
title EXP1
xdef  $imax linear  0.0  $dx
ydef  $jmax levels
 -87.864 -85.097 -82.313 -79.526 -76.737 -73.948 -71.158 -68.368 -65.578 -62.787
 -59.997 -57.207 -54.416 -51.626 -48.835 -46.045 -43.254 -40.464 -37.673 -34.883
 -32.092 -29.301 -26.511 -23.720 -20.930 -18.139 -15.348 -12.558  -9.767  -6.977
  -4.186  -1.395   1.395   4.186   6.977   9.767  12.558  15.348  18.139  20.930
  23.720  26.511  29.301  32.092  34.883  37.673  40.464  43.254  46.045  48.835
  51.626  54.416  57.207  59.997  62.787  65.578  68.368  71.158  73.948  76.737
  79.526  82.313  85.097  87.864
zdef    1 levels 200
tdef 99 linear     jan1950   1mon
vars  1
z     1 99 500mb height
endvars
EOF

done
exit
