#average the pressure sfc history data of GCM in NERSC     
# QSUB -eo -o log.gtwv87qg -lM 10Mw -lT 20:00 -q medium
# QSUB -ln 8
cd /work2/u70260/batchdir1
set echo
set timestamp
ja ja.out
cp /work2/u70260/gtwv87qg.f gtwv87qg.f      
chmod g+r,o+r gtwv87qg.f
chmod g+w,o+w gtwv87qg.f
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
cp  /work2/u70260/genpnme.o genpnme.o
cp /work2/u70260/fft.o fft.o
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
cft77 -ei -a static gtwv87qg.f
segldr -o gtwv87qg.x glats.o genpnme.o fft.o  fft991.o gtwv87qg.o
gtwv87qg.x 
#
# ftp data to cola peng       
#
ftp -n -v << -- 
 open cola.umd.edu               
 user peng 4daves    
 binary
 put fort.40 /homes/cola/peng/ppt/gcm1/gtwv87qg.hp 
 quit
--
rm *.dat fort.*
rm gtwv87qg.x *.o *.f 
ja -cst ja.out
