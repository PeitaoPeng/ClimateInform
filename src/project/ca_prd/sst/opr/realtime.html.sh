#!/bin/sh

set -eaux
#================================================
# have html file and scp to rzdm
#================================================

lcdir=/cpc/home/wd52pp/project/ca_prd/sst/opr
tmp=/cpc/home/wd52pp/tmp/opr2
if [ ! -d $tmp ] ; then
  mkdir -p $tmp
fi
datadir=/cpc/home/wd52pp/data/ca_prd
#
cd $tmp
#
#======================================
curyr=`date --date='today' '+%Y'`  # yr of making fcst
curmo=`date --date='today' '+%m'`  # mo of making fcst
#curyr=2022  # yr of making fcst
#curmo=12  # mo of making fcst
pasyr=`expr $curyr - 1`
#
if [ $curmo = 01 ]; then icmon=12 ; icyr=$pasyr ; icmonc=December; curmon=Jan; fss=FMA; fi 
if [ $curmo = 02 ]; then icmon=01 ; icyr=$curyr ; icmonc=January;  curmon=Feb; fss=MAM; fi
if [ $curmo = 03 ]; then icmon=02 ; icyr=$curyr ; icmonc=February; curmon=Mar; fss=AMJ; fi
if [ $curmo = 04 ]; then icmon=03 ; icyr=$curyr ; icmonc=March;    curmon=Apr; fss=MJJ; fi
if [ $curmo = 05 ]; then icmon=04 ; icyr=$curyr ; icmonc=April;    curmon=May; fss=JJA; fi
if [ $curmo = 06 ]; then icmon=05 ; icyr=$curyr ; icmonc=May;      curmon=Jun; fss=JAS; fi
if [ $curmo = 07 ]; then icmon=06 ; icyr=$curyr ; icmonc=June;     curmon=Jul; fss=ASO; fi
if [ $curmo = 08 ]; then icmon=07 ; icyr=$curyr ; icmonc=July;     curmon=Aug; fss=SON; fi
if [ $curmo = 09 ]; then icmon=08 ; icyr=$curyr ; icmonc=August;   curmon=Sep; fss=OND; fi
if [ $curmo = 10 ]; then icmon=09 ; icyr=$curyr ; icmonc=September;curmon=Oct; fss=NDJ; fi
if [ $curmo = 11 ]; then icmon=10 ; icyr=$curyr ; icmonc=October;  curmon=Nov; fss=DJF; fi
if [ $curmo = 12 ]; then icmon=11 ; icyr=$curyr ; icmonc=November; curmon=Dec; fss=JFM; fi
#
rzdmdir=/home/people/cpc/www/htdocs/products/people/wd52pp/sst/$icyr$icmon
lcdata=/cpc/home/wd52pp/data/season_fcst/ca/$icyr/$icmon

cat>sst.html<<EOF
<HTML>

<HEAD>
<TITLE>Climate Prediction Center, NWS</TITLE>
<!--Created by Applixware HTML Authoring System, Release 4.3 on Thu Aug 13 22:38:05 1998-->
<!--Ax:WP:DocVar:HTMLOriginalPath@:"/tmp/ex03302c.aw"-->
</HEAD>

<BODY>

<CENTER>
<P> <h3><FONT COLOR=red>$icmonc $icyr </font></h3></P>
<p> <h3><font color=blue>GLOBAL SEA SURFACE TEMPERATURE FORECASTS </font></h3></P>
<p> <h3><font color=blue>USING THE CONSTRUCTED ANALOG METHOD</FONT></h3></P>
</CENTER>

<table align="center">
<table border=5 cellpadding=5 cellspacing=10>

<TR>
<TH COLSPAN=1 ><P>SEASONAL PREDICTION</P></TH>
</TR>
<TR>
<TH COLSPAN=1 <P><A HREF='ca_weight_avg.tp_ml.out'>TABLE OF WEIGHTS</A></P></TH>
</TR>
<TR>
<TH COLSPAN=1 <P><A HREF='real.nino34.ca_fcst.png'>NINO 3.4 - plume</A></P></TH>
</TR>
<TR>
<TH COLSPAN=1 <P><A HREF='ca.nino34.out'>NINO 3.4 - table</A></P></TH>
</TR>
<TR>
<TH COLSPAN=1 <P><A HREF='casst_anom.-2_to_1.png'>LEADS -2 TO 1</A></P></TH>
</TR>
<TR>
<TH COLSPAN=1 <P><A HREF='casst_anom.2_to_5.png'>LEADS 2 TO 5</A></P></TH>
</TR>
<TR>
<TH COLSPAN=1 <P><A HREF='casst_anom.6_to_9.png'>LEADS 6 TO 9</A></P></TH>
</TR>
<TR>
<TH COLSPAN=1 <P><A HREF='casst_anom.10_to_13.png'>LEADS 10 TO 13</A></P></TH>
</TR>
</TR>
</TABLE>

<table align="center">
<table border=5 cellpadding=5 cellspacing=10>
<TR>
</TR>
<TR>
<TH COLSPAN=1 <P><A HREF='carealtime.html'>Real Time Z200,T2m,Prate,SST</A></P></TH>
</TR>
</TABLE>

</BODY>
</HTML>
EOF
#
cat>carealtime.html<<EOF
<HTML>

<HEAD>
<TITLE>Environmental Modeling Center, NWS</TITLE>
<!--Created by Applixware HTML Authoring System, Release 4.3 on Thu Aug 13 22:38:05 1998-->
<!--Ax:WP:DocVar:HTMLOriginalPath@:"/tmp/ex03302c.aw"-->
</HEAD>

<BODY>

<CENTER>
<p> <h3><font color=blue>Real Time CA-SST Seasonal Predictions</font></h3></P>
<p> <h3><font color=red>Last data thru $icmonc$icyr; Issuance in mid-$curmon; First lead=$fss</font></h3></P>
</CENTER>

<table align="center">
<table border=5 cellpadding=5 cellspacing=10>

<TR>
<TH COLSPAN=3 ><P>SST REAL TIME PREDICTION</P></TH>
<TH COLSPAN=3 ><P>200mb Height REAL TIME PREDICTION</P></TH>
<TH COLSPAN=3 ><P>Precipitation REAL TIME PREDICTION</P></TH>
<TH COLSPAN=3 ><P>Temperature REAL TIME PREDICTION</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='casst_anom.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst_anom.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst_anom.3.png'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.3.png'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.3.png'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.3.png'>LEAD3</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='casst_anom.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst_anom.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst_anom.6.png'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.6.png'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.6.png'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.6.png'>LEAD6</P></TH>
</TR>
<TR>
<TH COLSPAN=1 ><P><A HREF='casst_anom.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst_anom.8.png'>LEAD8</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst_anom.9.png'>LEAD9</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.8.png'>LEAD8</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.9.png'>LEAD9</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.8.png'>LEAD8</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.9.png'>LEAD9</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.8.png'>LEAD8</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.9.png'>LEAD9</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='casst_anom.10.png'>LEAD10</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst_anom.11.png'>LEAD11</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst_anom.12.png'>LEAD12</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.10.png'>LEAD10</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.11.png'>LEAD11</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt_anom.12.png'>LEAD12</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.10.png'>LEAD10</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.11.png'>LEAD11</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec_anom.12.png'>LEAD12</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.10.png'>LEAD10</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.11.png'>LEAD11</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m_anom.12.png'>LEAD12</P></TH>
</TR>
<TR>
<TH COLSPAN=1 ><P><A HREF='https://www.cpc.ncep.noaa.gov/products/people/wd52pp/sst/$icyr$icmon/caskill.html'>GO TO Matching Skill Maps</P></TH>
</TR>

</TABLE>
EOF
#

cat>caskill.html<<EOF
<HTML>

<HEAD>
<TITLE>Environmental Modeling Center, NWS</TITLE>
<!--Created by Applixware HTML Authoring System, Release 4.3 on Thu Aug 13 22:38:05 1998-->
<!--Ax:WP:DocVar:HTMLOriginalPath@:"/tmp/ex03302c.aw"-->
</HEAD>

<BODY>

<CENTER>
<p> <h3><font color=blue>A-PRIORI SKILL ESTIMATES OF GLOBAL CONSTRUCTED SST ANALOGUE METHOD</font></h3></P>
<p> <h3><font color=blue>Period of evaluation : 1981-last year</FONT></h3></P>
</CENTER>
<CENTER>

<table align="center">
<table border=5 cellpadding=5 cellspacing=10>

<TR>
<TH COLSPAN=3 ><P>SST</P></TH>
<TH COLSPAN=3 ><P>200mb Height</P></TH>
<TH COLSPAN=3 ><P>Precipitation</P></TH>
<TH COLSPAN=3 ><P>Temperature</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='casst.ac.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst.ac.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst.ac.3.png'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.3.png'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.3.png'>LEAD3</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.1.png'>LEAD1</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.2.png'>LEAD2</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.3.png'>LEAD3</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='casst.ac.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst.ac.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst.ac.6.png'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.6.png'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.6.png'>LEAD6</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.4.png'>LEAD4</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.5.png'>LEAD5</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.6.png'>LEAD6</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='casst.ac.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst.ac.8.png'>LEAD8</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst.ac.9.png'>LEAD9</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.8.png'>LEAD8</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.9.png'>LEAD9</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.8.png'>LEAD8</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.9.png'>LEAD9</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.7.png'>LEAD7</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.8.png'>LEAD8</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.9.png'>LEAD9</P></TH>
</TR>

<TR>
<TH COLSPAN=1 ><P><A HREF='casst.ac.10.png'>LEAD10</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst.ac.11.png'>LEAD11</P></TH>
<TH COLSPAN=1 ><P><A HREF='casst.ac.12.png'>LEAD12</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.10.png'>LEAD10</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.11.png'>LEAD11</P></TH>
<TH COLSPAN=1 ><P><A HREF='cahgt.ac.12.png'>LEAD12</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.10.png'>LEAD10</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.11.png'>LEAD11</P></TH>
<TH COLSPAN=1 ><P><A HREF='caprec.ac.12.png'>LEAD12</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.10.png'>LEAD10</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.11.png'>LEAD11</P></TH>
<TH COLSPAN=1 ><P><A HREF='cat2m.ac.12.png'>LEAD12</P></TH>
</TR>

</TABLE>
EOF
scp *.html wd52pp@vm-cprk-rzdm01:$rzdmdir/.
