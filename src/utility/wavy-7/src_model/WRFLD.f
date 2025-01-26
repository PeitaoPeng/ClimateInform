      SUBROUTINE WRFLD
     1(FIELD,NWV,LEV,IUDIAG,ixwave,iywave)
C
      DIMENSION FIELD(NWV,LEV)
      DIMENSION temp(2,16,16)
      CHARACTER*8 ON84LB(6)
      SAVE ON84LB
      DATA ON84LB/6*'        '/
C
       do 30 nlv=1,lev
       ict=1
       do 20 i=1,2
       do 20 ik=1,16
       do 20 ij=1,16
       temp(i,ik,ij)=0.0
20     continue
C
      do 10 lj=1,ixwave
      do 10 lk=1,iywave
      do 10 i=1,2
        temp(i,lk,lj)=field(ict,nlv)
       ict=ict+1
10    continue
C
      write(iudiag) ON84LB,temp
30     continue
C
      RETURN
      END
