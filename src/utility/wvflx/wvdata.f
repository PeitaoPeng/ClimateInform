      dimension rin(128,102,7),rout(128,102)
      OPEN(10,FILE='~peng/data/gcm/pbhpwv88f',FORM='UNFORMATTED',
     +ACCESS='DIRECT',RECL=91392)
      OPEN(80,FILE='~peng/data/gcm/test.dat',FORM='FORMATTED')
      read(10,rec=1) rin
      do 100 j=1,102
      do 100 i=1,128
         rout(i,j)=rin(i,j,4)
  100 continue
      write(80,999) rout
  999 format(8e10.3)
      stop
      end
