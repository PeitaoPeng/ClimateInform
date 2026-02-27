#
# QSUB -eo -o log.sgave5 -mb -me -lM 8Mw -lT 24:00 -q medium
#
cd /work1/u70260/batchdir1           
set echo
set timestamp
ja ja.out
set prid $$
# init=0 if initialized data is to be skipped
set init=1
set daybeg=30   ; set dayend=30
set monbeg=06   ; set monend=09
set yearbeg=79 ; set yearend=79     
setenv FILENV fileuniq
set dsout=s${monbeg}${daybeg}${yearbeg}e${monend}${dayend}${yearend}
#                  
set mobg1=06 ; set mobg2=07 ; set mobg3=08
set dabg1=30 ; set dabg2=31 ; set dabg3=31
set yrbg1=79 ; set yrbg2=79 ; set yrbg3=79
set moen1=07 ; set moen2=08 ; set moen3=09
set daen1=31 ; set daen2=31 ; set daen3=30
set yren1=79 ; set yren2=79 ; set yren3=79
#
# GET OBJECT DECKS
#
#
set dsp1=s${mobg1}${dabg1}${yrbg1}e${moen1}05${yren1}
set dsp2=s${moen1}05${yren1}e${moen1}10${yren1}
set dsp3=s${moen1}10${yren1}e${moen1}15${yren1}
set dsp4=s${moen1}15${yren1}e${moen1}20${yren1}
set dsp5=s${moen1}20${yren1}e${moen1}25${yren1}
set dsp6=s${moen1}25${yren1}e${moen1}${daen1}${yren1}
#
set dsq1=s${mobg2}${dabg2}${yrbg2}e${moen2}05${yren2}
set dsq2=s${moen2}05${yren2}e${moen2}10${yren2}
set dsq3=s${moen2}10${yren2}e${moen2}15${yren2}
set dsq4=s${moen2}15${yren2}e${moen2}20${yren2}
set dsq5=s${moen2}20${yren2}e${moen2}25${yren2}
set dsq6=s${moen2}25${yren2}e${moen2}${daen2}${yren2}
#
set dsr1=s${mobg3}${dabg3}${yrbg3}e${moen3}05${yren3}
set dsr2=s${moen3}05${yren3}e${moen3}10${yren3}
set dsr3=s${moen3}10${yren3}e${moen3}15${yren3}
set dsr4=s${moen3}15${yren3}e${moen3}20${yren3}
set dsr5=s${moen3}20${yren3}e${moen3}25${yren3}
set dsr6=s${moen3}25${yren3}e${moen3}${daen3}${yren3}
#
 cfs get "p1:/000733/colamodwgne/sghist/runw1/"$dsp1
 cfs get "p2:/000733/colamodwgne/sghist/runw1/"$dsp2
 cfs get "p3:/000733/colamodwgne/sghist/runw1/"$dsp3
 cfs get "p4:/000733/colamodwgne/sghist/runw1/"$dsp4
 cfs get "p5:/000733/colamodwgne/sghist/runw1/"$dsp5
 cfs get "p6:/000733/colamodwgne/sghist/runw1/"$dsp6
  unform p1 fort.21
  unform p2 fort.22
  unform p3 fort.23
  unform p4 fort.24
  unform p5 fort.25
  unform p6 fort.26
 cfs get "q1:/000733/colamodwgne/sghist/runw1/"$dsq1
 cfs get "q2:/000733/colamodwgne/sghist/runw1/"$dsq2
 cfs get "q3:/000733/colamodwgne/sghist/runw1/"$dsq3
 cfs get "q4:/000733/colamodwgne/sghist/runw1/"$dsq4
 cfs get "q5:/000733/colamodwgne/sghist/runw1/"$dsq5
 cfs get "q6:/000733/colamodwgne/sghist/runw1/"$dsq6
  unform q1 fort.27
  unform q2 fort.28
  unform q3 fort.29
  unform q4 fort.30
  unform q5 fort.31
  unform q6 fort.32
 cfs get "r1:/000733/colamodwgne/sghist/runw1/"$dsr1
 cfs get "r2:/000733/colamodwgne/sghist/runw1/"$dsr2
 cfs get "r3:/000733/colamodwgne/sghist/runw1/"$dsr3
 cfs get "r4:/000733/colamodwgne/sghist/runw1/"$dsr4
 cfs get "r5:/000733/colamodwgne/sghist/runw1/"$dsr5
 cfs get "r6:/000733/colamodwgne/sghist/runw1/"$dsr6
  unform r1 fort.33
  unform r2 fort.34
  unform r3 fort.35
  unform r4 fort.36
  unform r5 fort.37
  unform r6 fort.38
 cfs get glats.o:/000733/unicos/object/glats.o
 cfs get genncr.o:/000733/unicos/object/genpnm.o
 cfs get fft991.o:/000733/unicos/object/fftgcm.o
#
# DEFINE NAMELIST
#
if ( $init == 0 ) then
cat > sgnml << --
 &SGNML
 HRBG=6.0,IDAYBG=$daybeg,MONBG=$monbeg,IYRBG=$yearbeg,
 HREN=0.0,IDAYEN=$dayend,MONEN=$monend,IYREN=$yearend,
 LINIT=.TRUE. &END
--
else
cat > sgnml << --
 &SGNML
 HRBG=0.0,IDAYBG=$daybeg,MONBG=$monbeg,IYRBG=$yearbeg,
 HREN=0.0,IDAYEN=$dayend,MONEN=$monend,IYREN=$yearend,
 LINIT=.FALSE. &END
--
endif
#
# ISSUE ASSIGNS   
#
assign -F null -N ieee fort.60
#
# COMPILE PROGRAM
#
cp /work1/u70260/sgave5.f sgave5.f
cft77 -ei -a static sgave5.f 
#
# LOAD PROGRAM
#
segldr -o sgave5.x sgave5.o glats.o genncr.o fft991.o
#
# RUN JOB
#
# executable_filename < nml.name_of_namelist
sgave5.x < sgnml
#
# STORE OUTPUT
#
mv fort.60 cola.$dsout         
ftp -n -v << --
 open rainbow.ldgo.columbia.edu
 user cliner mbovary
 binary
 put cola.$dsout /room/niyunqi/cola.$dsout
 quit
--
#
# END JOB ACCOUNTING
#
rm fort.* p* q* r*
rm sgave5.x sgave5.o glats.o genncr.o fft991.o sgave5.f
ja -cst ja.out
