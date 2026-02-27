#!/bin/sh

set -eaux

lcdir=/cpc/home/wd52pp/project/LF_prd/ocn_prd
tmp=/cpc/home/wd52pp/tmp
datadir=/cpc/home/wd52pp/data/LF_prd
#
tgtyr=2013  #target year (NDJ&DJF should be in the same year as JFM, FMA et al)
nyear=82  # number of years of data to be loaded (1931-present)
#
mode=6    # number of modes kept for EOCN
mrot=8    # number of modes for rotation
#
cp $lcdir/eocn_prd_hss.f $tmp/eocnprd_hss.f
cp $lcdir/reof.s.f $tmp/reof.s.f
cp $lcdir/CD102_2_2x2.s.f $tmp/CD102_2_2x2.s.f
cd $tmp
#
#for season in jfm fma mam amj mjj jja jas aso son ond ndj djf; do
 for season in jfm; do
#
if [ "$season" = jfm ]; then mons=1; ssw=JFM; fi
if [ "$season" = fma ]; then mons=2; ssw=FMA; fi
if [ "$season" = mam ]; then mons=3; ssw=MAM; fi
if [ "$season" = amj ]; then mons=4; ssw=AMJ; fi
if [ "$season" = mjj ]; then mons=5; ssw=MJJ; fi
if [ "$season" = jja ]; then mons=6; ssw=JJA; fi
if [ "$season" = jas ]; then mons=7; ssw=JAS; fi
if [ "$season" = aso ]; then mons=8; ssw=ASO; fi
if [ "$season" = son ]; then mons=9; ssw=SON; fi
if [ "$season" = ond ]; then mons=10; ssw=OND; fi
if [ "$season" = ndj ]; then mons=11; ssw=NDJ; fi
if [ "$season" = djf ]; then mons=12; ssw=DJF; fi
#
lt=$nyear
if [ "$mons" -gt 10 ]; then lt=`expr $nyear - 1`; fi
ntprd=`expr $lt - 30`
ntvfc=`expr $lt - 60`  # number of years for verfication
curyr=`expr $tgtyr - 1`
yyp=`expr $tgtyr + 1`
yyp2=`echo $yyp|cut -c 3-4`
ytitle=$tgtyr
if [ "$mons" -gt 10 ]; then ytitle=${tgtyr}/$yyp2; fi
echo "lt=" $lt
echo "ntprd=" $ntprd
echo "ntvfc=" $ntvfc
#
cat > parm.h << feof
       parameter(nyear=$nyear)
       parameter(ltime=$lt)
       parameter(imax=102)
       parameter(mmax=$mode)
       parameter(mrot=$mrot)   !mode # to rotate
       parameter(ntprd=$ntprd)
       parameter(iseason=$mons)
       parameter(ndx=36,ndy=19)
       parameter(kp=7)
       parameter(ndec=6)  !# of wmo clim for the whole data length
feof
#
gfortran -o eocnprd_hss.x reof.s.f CD102_2_2x2.s.f eocnprd_hss.f
#gfortran -ff2c -o eocnprd_hss.x reof.s.f CD102_2_2x2.s.f eocnprd_hss.f
echo "done compiling"
#
/bin/rm $tmp/fort.*         
#
#
 ln -s $datadir/temp_102.txt           fort.10
#
 ln -s $datadir/eocnprd_temp.$season.hss_map.gr                 fort.15
 ln -s $datadir/eocnprd_temp.$season.hss_ts.gr                  fort.16
#
eocnprd_hss.x > $datadir/eocnprd_hss.$season.out
#

cat>$datadir/eocnprd_temp.$season.hss_map.ctl<<EOF
dset $datadir/eocnprd_temp.$season.hss_map.gr
undef -9999.0
title prd and hss
xdef    36 LINEAR  -130 2
ydef    19 LINEAR    20 2
zdef    1 levels 500
tdef $ntvfc linear jan1991  1yr
vars   3
prd   0 99 unnormalized prd
prdn  0 99 normalized prd
hs    0 99  map of hss over 1991-present
endvars
EOF
#
cat>$datadir/eocnprd_temp.$season.hss_ts.ctl<<EOF2
dset $datadir/eocnprd_temp.$season.hss_ts.gr
undef -9999.0
title Realtime Surface Obs
xdef    1 linear    -130 2
ydef    1 linear      20 2
zdef    1 levels 500
tdef $ntvfc linear jan1991 1yr
vars   1 
hs   0 99 time series of CONUS hss
endvars
EOF2
#
#d have plots for forecast and historical skills
#---------------------------
# Create the parameter file
#---------------------------

cat >intparm<<EOF3
run temp_fcst.gs
EOF3

#cat intparm

#----------------
# Plot the temp fcst and hss
#----------------

cat >temp_fcst.gs<<EOF4
    'reinit'
    'set display color white'
    'c'
    'run /cpc/home/wd52pp/bin/rgbset.gs'

'open $datadir/eocnprd_temp.$season.hss_map.ctl'
'open $datadir/eocnprd_temp.$season.hss_ts.ctl'
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 5.5 8 EOF adjusted OCN (EOCN) forecast for surface T of $ssw $ytitle'
 'set strsiz 0.12 0.12'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.75;  xlen=4.5;  xgap=0.75
ymax0=7.25; ylen=-2.5;  ygap=-1.0
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx1=xmin+2.2
  titlx2=xmin+2.2
  titlx3=xmin+2.2
  titlx4=xmin+2.2
  titly=ymax+0.1
  if(iframe = 4); titly=ymax+0.2; endif
  barx=xmin+2.25
  bary=ymax-2.8
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set lat 24 51'
'set ylint 5'
'set lon -129 -65'
'set xlint 10'
'set grads off'
'set grid off'
'set poli on'
'set mpdset mres'
'set gxout grfill'
if(iframe = 1);
'set clevs  -1.5 -1.0 -0.5 0 0.5 1.0 1.5'
'set ccols  47 45 43 41 21 23 25 27';
'd prd'
endif
if(iframe = 2);
'set clevs   -0.42 0.42'
'set ccols   47 0 27';
'd prdn'
endif
if(iframe = 3);
'set clevs   10 20 30 40 50';
'set ccols  0 21 23 25 27 29';
'd hs'
endif
if(iframe = 4);
'set gxout line'
'set vrange -50 100'
'set ylint 10'
'set x 1'
'set y 1'
'set t 1 last'
'define zero=0.'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'd hs.2'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd zero'
endif
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
if(iframe = 1); 'draw string 'titlx1' 'titly' Forecasted T anom (K)'; endif
if(iframe = 2); 'draw string 'titlx2' 'titly' 3-tercile (above,normal,below) forecast'; endif
if(iframe = 3); 'draw string 'titlx3' 'titly' HSS map for $ssw of 1991-$curyr'; endif
if(iframe = 4); 'draw string 'titlx4' 'titly' HSS time series for $ssw of 1991-$curyr'; endif
*
if(iframe = 1); 'run /cpc/home/wd52pp/bin/cbarn.gs 0.55 0 'barx' 'bary''; endif
if(iframe = 3); 'run /cpc/home/wd52pp/bin/cbarn.gs 0.55 0 'barx' 'bary''; endif

iframe=iframe+1

endwhile

'printim $season$tgtyr.png gif x800 y600'

'print'
EOF4

/usr/local/bin/grads -l <intparm
cp $season$tgtyr.png $lcdir/plot

done
