C
C                     Calculate response function
C
C   FRESPONSE: output file
C
c     PARAMETER (NT=2000,IPM=500)
      PARAMETER (NT=2000,IPM=50)

      DIMENSION U0(NT),U2(NT)
      DIMENSION WK(NT),ATMP(NT),ARF(IPM),ARFS(IPM)

      open(91,file='FRESPONSEband',form='formatted',status='unknown')
C
      PI=4.*ATAN(1.)
      DO IP=1,IPM
       PERIOD=IP
       DO N=1,NT
        U0(N)=SIN(2.*PI*N/PERIOD)
       enddo

       CALL FLTM(U0,U2,WK,NT)
       DO N=1,NT
        ATMP(N)=U2(N)
       enddo

       ARF(IP)=0.
       N1=NT/2-200
       N2=NT/2+200
       DO N=N1,N2
        ABSF=ABS(ATMP(N))
        IF(ARF(IP).LT.ABSF) ARF(IP)=ABSF
       ENDDO

      ENDDO

      WRITE(91,1000)
      DO IP=1,IPM
       ARFS(IP)=ARF(IP)
       PERIOD=IP
       WRITE(91,1001) PERIOD,ARFS(IP)
      ENDDO

 1001 FORMAT(2F10.4)
 1000 FORMAT(4x,18Hperiod    response)
      STOP
      END
 
      SUBROUTINE FLTM(U0,U2,WK,NT)
C
C U0:    input time series
C U2:    output time series
C

c     parameter(np1=18,np2=12)  ! 6yr LP
      parameter(np1=5,np2=1)
      DIMENSION U0(NT),U2(NT)
      DIMENSION WK(NT)
      call runmean(U0,NT,U2,np1)
c     call runmean(U0,NT,WK,np1)
c     call runmean(WK,NT,U2,np2)
      RETURN
      END
 
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  runing mean
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine runmean(a,n,b,m)
      real a(n),b(n)
c
      do i=1,m
        b(i)=a(i)
        b(n-i+1)=a(n-i+1)
      enddo
c
      do 5 i=m+1,n-m
        avg=0
        do 6 j=i-m,i+m
        avg=avg+a(j)/float(2*m+1)
  6   continue
        b(i)=avg
  5   continue
      return
      end
C
