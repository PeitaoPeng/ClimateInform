#average the pressure sfc history data of GCM in NERSC     
# QSUB -eo -o log.gtseasonmn -lM 4Mw -lT 40:00 -q medium
# QSUB -ln 8
cd /work1/u3197/batchdir1
set echo
set timestamp
ja ja.out
cp /work1/u3197/gtseasonmn.f gtseasonmn.f      
chmod g+r,o+r gtseasonmn.f
chmod g+w,o+w gtseasonmn.f
#
# get old (CTSS) files 
#
cfs get prhst1.dat:/000733/ppr40l18/config2/run3/s120187e121587
cfs get prhst2.dat:/000733/ppr40l18/config2/run3/s121687e123187
cfs get prhst3.dat:/000733/ppr40l18/config2/run3/s010188e011588
cfs get prhst4.dat:/000733/ppr40l18/config2/run3/s011688e013188
cfs get prhst5.dat:/000733/ppr40l18/config2/run3/s020188e021588
cfs get prhst6.dat:/000733/ppr40l18/config2/run3/s021688e022988
cfs get glats.o:/000733/unicos/object/glats.o
cfs get fft991.o:/000733/unicos/object/fftgcm.o
cp  /work1/u3197/genpnme.o genpnme.o
#
# convert CTSS files to UNICOS files
#
unform prhst1.dat fort.61
unform prhst2.dat fort.62
unform prhst3.dat fort.63
unform prhst4.dat fort.64
unform prhst5.dat fort.65
unform prhst6.dat fort.66
ls -l *.dat
ls -l fort.* 
#
# ISSUE ASSIGNS
#
assign -F null -N ieee fort.40
#
# compile,load and excute the program
#
cft77 -ei -a static gtseasonmn.f
segldr -o gtseasonmn.x glats.o genpnme.o fft991.o gtseasonmn.o
gtseasonmn.x 
#
# ftp data to cola peng       
#
ftp -n -v << -- 
 open cola.umd.edu               
 user peng 4daves    
 binary
 put fort.40 /homes/cola/peng/ppt/gcm1/djfmn8788 
 quit
--
mv fort.50 djfmn8788
rm *.dat fort.*
rm gtseasonmn.x *.o *.f 
ja -cst ja.out
