#!/bin/sh
set -eaux
#================================================
# have html file and scp to datadir
#================================================

lcdir=/home/ppeng/ClimateInform/src/opr/src
tmp=/home/ppeng/data/tmp_opr
bindir=/home/ppeng/ClimateInform/src/bin
#
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
#
cd $tmp
#
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst

#curyr=2025

curyr=2025
for curmo in 01 02 03 04 05 06 07 08 09 10 11 12; do

pasyr=`expr $curyr - 1`
#
if [ $curmo = 01 ]; then icmon=12 ; icyr=$pasyr ; icmonc=December; curmon=Jan; fss=JFM; fi 
if [ $curmo = 02 ]; then icmon=1 ; icyr=$curyr ; icmonc=January;  curmon=Feb; fss=FMA; fi
if [ $curmo = 03 ]; then icmon=2 ; icyr=$curyr ; icmonc=February; curmon=Mar; fss=MAM; fi
if [ $curmo = 04 ]; then icmon=3 ; icyr=$curyr ; icmonc=March;    curmon=Apr; fss=AMJ; fi
if [ $curmo = 05 ]; then icmon=4 ; icyr=$curyr ; icmonc=April;    curmon=May; fss=MJJ; fi
if [ $curmo = 06 ]; then icmon=5 ; icyr=$curyr ; icmonc=May;      curmon=Jun; fss=JJA; fi
if [ $curmo = 07 ]; then icmon=6 ; icyr=$curyr ; icmonc=June;     curmon=Jul; fss=JAS; fi
if [ $curmo = 08 ]; then icmon=7 ; icyr=$curyr ; icmonc=July;     curmon=Aug; fss=ASO; fi
if [ $curmo = 09 ]; then icmon=8 ; icyr=$curyr ; icmonc=August;   curmon=Sep; fss=SON; fi
if [ $curmo = 10 ]; then icmon=9 ; icyr=$curyr ; icmonc=September;curmon=Oct; fss=OND; fi
if [ $curmo = 11 ]; then icmon=10 ; icyr=$curyr ; icmonc=October;  curmon=Nov; fss=NDJ; fi
if [ $curmo = 12 ]; then icmon=11 ; icyr=$curyr ; icmonc=November; curmon=Dec; fss=DJF; fi
#
#if [ $icmon = 12 ]; then icyr=`expr $icyr - 1`; fi
#
datadir=/home/ppeng/data/ss_fcst/pcr/$icyr/$icmon
#
cat>fcst_skill_maps.html<<EOF
<HTML>

<HEAD>
<TITLE>Forecast Leads</TITLE>
<style>
.centered-table {
    margin-left: auto !important;
    margin-right: auto !important;
    display: table !important;
}
</style>
</HEAD>

<BODY>

<CENTER>
<p> <h1><font color=blue>Real-time Seasonal Climate Forecast</font></h12></P>
<p> <h2><font color=red>Last data through $icmonc $icyr; Issuance in early $curmon; LEAD0 = $fss</font></h2></P>
</CENTER>

<div style="width:100%; text-align:center;">
  <table class="centered-table" border="5" cellpadding="10" cellspacing="12" style="width:900px;">

<TR>
<TH COLSPAN=4 ><P>SST</P></TH>
<TH COLSPAN=4 ><P>Temperature</P></TH>
<TH COLSPAN=4 ><P>Precipitation</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='sst_anom.0.png'>LEAD0</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_anom.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_anom.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_anom.3.png'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m.ld0.html'>LEAD0</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m.ld1.html'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m.ld2.html'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m.ld3.html'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec.ld0.html'>LEAD0</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec.ld1.html'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec.ld2.html'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec.ld3.html'>LEAD3</P></TH>
</TR>
<TR>
<TH COLSPAN=1 ><P><A HREF='sst_anom.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_anom.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_anom.6.png'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_anom.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m.ld4.html'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m.ld5.html'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m.ld6.html'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m.ld7.html'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec.ld4.html'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec.ld5.html'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec.ld6.html'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec.ld7.html'>LEAD7</P></TH>
</TR>
</TABLE>
</div>

<br><br>

<CENTER>
<p> <h1><font color=blue>Corresponding Skill from Hindcast Data</font></h1></P>
<p> <h2><font color=blue>Verification Period: 1981-last year</FONT></h2></P>
</CENTER>

<div style="width:100%; text-align:center;">
<table class="centered-table" border="5" cellpadding="10" cellspacing="12" style="width:900px;">

<TR>
<TH COLSPAN=4 ><P>SST</P></TH>
<TH COLSPAN=4 ><P>Temperature</P></TH>
<TH COLSPAN=4 ><P>Precipitation</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='sst_ACC.0.png'>LEAD0</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_ACC.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_ACC.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_ACC.3.png'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m_skill.ld0.html'>LEAD0</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m_skill.ld1.html'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m_skill.ld2.html'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m_skill.ld3.html'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec_skill.ld0.html'>LEAD0</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec_skill.ld1.html'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec_skill.ld2.html'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec_skill.ld3.html'>LEAD3</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='sst_ACC.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_ACC.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_ACC.6.png'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='sst_ACC.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m_skill.ld4.html'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m_skill.ld5.html'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m_skill.ld6.html'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='t2m_skill.ld7.html'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec_skill.ld4.html'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec_skill.ld5.html'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec_skill.ld6.html'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='prec_skill.ld7.html'>LEAD7</P></TH>
</TR>
</TABLE>
</div>

<br><br>
<br><br>
<br><br>

<div style="width:100%; text-align:center;">
<table class="centered-table" border="5" cellpadding="10" cellspacing="12" style="width:400px;">
<TR>
<TH COLSPAN="1">
  <P>
    <A HREF="nino34.html" style="font-size:22px; font-weight:bold;">
      Nino3.4 SST Index Forecast
    </A>
  </P>
</TH>
</TR>
</TABLE>
</div>
EOF
#
for var in t2m prec; do
for ld in 0 1 2 3 4 5 6 7; do

cat>${var}.ld$ld.html<<EOF
<!DOCTYPE html>
<html>
<head>
    <title>LEAD$ld Forecast Maps</title>
</head>
<body>

<h2 style="text-align:center;"> LEAD$ld Deterministic (left) and Tercile Probabilistic (right) Forecasts </h2> 
<h3 style="text-align:center;"> Enlarge a map by clicking on it </h3>

<div style="display: flex; justify-content: center; gap: 20px;">

  <a href="${var}_det.$ld.png" target="_blank">
    <img src="${var}_det.$ld.png" width="600">
  </a>

  <a href="${var}_prob.$ld.png" target="_blank">
    <img src="${var}_prob.$ld.png" width="600">
  </a>

</div>

</body>
</html>
EOF

cat>${var}_skill.ld$ld.html<<EOF
<!DOCTYPE html>
<html>
<head>
    <title>LEAD$ld Skill Maps</title>
</head>
<body>

<h2 style="text-align:center;"> LEAD$ld Anomaly Correlation (AC), Heidke Skill Score (HSS) & Ranked Probability Skill Score(RPSS)</h2> 
<h3 style="text-align:center;"> Enlarge a map by clicking on it </h3>

<div style="display:flex; justify-content:center; gap:20px; margin-top:20px;">

  <a href="${var}_ACC.$ld.png" target="_blank">
    <img src="${var}_ACC.$ld.png" width="400">
  </a>

  <a href="${var}_HSS.$ld.png" target="_blank">
    <img src="${var}_HSS.$ld.png" width="400">
  </a>

  <a href="${var}_RPSS.$ld.png" target="_blank">
    <img src="${var}_RPSS.$ld.png" width="400">
  </a>

</div>

</body>
</html>
EOF

done # var loop
done # ld loop

cat>nino34.html<<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Nino3.4 Index</title>
</head>
<body>

<h2 style="text-align:center;">Nino3.4 SST Index Forecast(left) and Corresponding AC Skill (right)</h2>

<div style="display:flex; justify-content:center; gap:20px;">

  <a href="nino34_fcst.png" target="_blank">
    <img src="nino34_fcst.png" width="800">
  </a>

  <a href="skill_nino34.png" target="_blank">
    <img src="skill_nino34.png" width="800">
  </a>

</div>

</body>
</html>
EOF

scp *.html $datadir/.
scp *.html /home/ppeng/web_test/.

done # mcur loop
