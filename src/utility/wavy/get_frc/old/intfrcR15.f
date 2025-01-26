CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  PROGRAM TO interpolate 28 v level data to 18 v level           
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE INTPFRC(FRCL18, FRCL9)
      PARAMETER ( NW =15, NLV=18,NLO=10)
      PARAMETER ( NWP1=NW+1)
      COMPLEX FRCL18(NWP1,NWP1,NLV,5),FRCL9(NWP1,NWP1,NLO,5)
      COMPLEX Z1(NLV), Z2(NLO)
      REAL    sig1(NLV),sig2(NLO)
      data sig1/995,981,960,920,856,777,688,594,497,
     &425,375,325,275,225,175,124,74,21/
c     data sig2/986,933,813,639,472,349,249,148,41/ 
      data sig2/950,850,750,650,550,450,350,250,150,50/
C
      do 20 I=1,NWP1
      do 20 J=1,NWP1
      do 20 L=1,5
	do 30 k=1,NLV
	Z1(k)=FRCL18(I,J,k,L)
30      continue
      call lintp(NLV,Z1,sig1,NLO,Z2,sig2)
	do 40 k=1,NLO
	FRCL9(I,J,k,L)=Z2(k)
40      continue
20    continue
C
      RETURN
      END

      SUBROUTINE LINTP (N1,RIN,SIG1,N2,ROUT,SIG2)
      COMPLEX RIN(N1),ROUT(N2)
      REAL    sig1(N1),sig2(N2)
      do 10 i=1,N2
      do 20 j=1,N1
      IF(sig2(i).LE.sig1(j).and.sig2(i).gt.sig1(j+1)) then
      ROUT(i)=RIN(j)+(sig2(i)-sig1(j))*
     &        (RIN(j+1)-RIN(j))/(sig1(j+1)-sig1(j))
      GO TO 10
      ELSE
      go to 20
      end if
  20  continue
  10  continue
      return
      end
