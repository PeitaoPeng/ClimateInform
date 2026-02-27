      PROGRAM totfrc
      include "ptrunk.h"
      PARAMETER ( NW =15, NLV=18,NLO=10)
      PARAMETER ( NWP1=NW+1)                        
c     PARAMETER ( NX=11,NY=16)                        
c     PARAMETER ( NX=7,NY=16)                        
c     PARAMETER ( NX=16,NY=16)                        
      PARAMETER ( INLH=NWP1*NWP1*NLV*5)                        
      PARAMETER ( NOTLH=NX*NY*5)                        
      COMPLEX     CBUFR(NX,NY,5)
      COMPLEX HIDEA(16,16,NLO)
      COMPLEX VIDEA(16,16,NLO)
      COMPLEX WRKIN(NWP1,NWP1,NLV,5),WRK15(16,16,NLO,5)
      COMPLEX WRKIN2(NWP1,NWP1,NLV,5)
      COMPLEX FRC(16,16,NLO,5)
      COMPLEX Z1(NLV), Z2(NLO)
      REAL    BUFR(2,16,16)
      LOGICAL zset,ideah,ideafv,smooth
C
      open(unit=43,form='unformatted',recl=4*INLH)
      open(unit=46,form='unformatted',recl=4*INLH)
      open(unit=80,form='unformatted',recl=8*NOTLH) !complex, so 8*
c     open(unit=85,form='unformatted',recl=4*2*16*16)
c     open(unit=85,form='unformatted')
C
C.......................................................................
C
c     DATA zset /.true./
      DATA zset /.false./
c
      DATA ideah/.true./
c     DATA ideah/.false./
c
      DATA ideafv/.false./
c     DATA ideafv/.true./
c
c     DATA smooth/.true./
      DATA smooth/.false./
C
C.....readin totfrc from unit 43 & 46 and do vertical intpolation
c     read(43) WRKIN
c     read(46) WRKIN2
      do L=1,5
      do K=1,NLV
      do J=1,NWP1
      do I=1,NWP1
c       WRKIN(I,J,K,L)=WRKIN(I,J,K,L)-WRKIN2(I,J,K,L)
        WRKIN(I,J,K,L)=WRKIN2(I,J,K,L)
        if(L.eq.5.and.K.gt.15) WRKIN(I,J,K,L)=0.
      end do
      end do
      CALL hsmooth(WRKIN(1,1,K,L),WRKIN2(1,1,K,L),15,6,2,smooth)
      end do
      end do
      CALL INTPFRC(WRKIN2,WRK15)
      call zero(WRK15,FRC,zset)
C.....have idealized heating or vorticity frc
      if(ideah) then
      call heatidea(HIDEA)
      end if
      if(ideafv) then
      call fvidea(VIDEA)
      write(6,*)'VIDEA=',VIDEA(1,1,5)
      end if
CCCC..calculate anom frc
      do 50 k=1,5
      do 50 j=1,NY
      do 50 i=1,NX
         CBUFR(i,j,k)=(0.,0.)
   50 CONTINUE
      iwrite=0
      do 100 k=1,NLO
C..vorticity frc
      do 110 j=1,NY
      do 110 i=1,NX
c     do 110 i=1,1
      if(ideafv) then
         CBUFR(i,j,1)=VIDEA(i,j,k)
      else
         CBUFR(i,j,1)=FRC(i,j,k,1)
         CBUFR(i,j,1)=0.
      endif
  110 CONTINUE
C..divergence frc
      do 120 j=1,NY
      do 120 i=1,NX
c        CBUFR(i,j,2)=FRC(i,j,k,2)
         CBUFR(i,j,2)=0.                               
  120 CONTINUE
C..temperature frc
      do 130 j=1,NY
      do 130 i=1,NX
      if(ideah) then
         CBUFR(i,j,3)=HIDEA(i,j,k)
      else
c        CBUFR(i,j,3)=FRC(i,j,k,3)
C..diabatic heating only
c        CBUFR(i,j,3)=FRC(i,j,k,5)
c        CBUFR(i,j,3)=FRC(i,j,k,5)+FRC(i,j,k,3)
c        CBUFR(i,j,3)=0.
      end if
  130 CONTINUE
      do 140 j=1,NY
      do 140 i=1,NX
         CBUFR(i,j,4)=0.                               
  140 CONTINUE
C..continuity  frc
      do 150 j=1,NY
      do 150 i=1,NX
c        CBUFR(i,j,5)=FRC(i,j,k,4)
         CBUFR(i,j,5)=0.                               
  150 CONTINUE
           WRITE(80) CBUFR
           iwrite=iwrite+1
           write(6,*) 'iwrite=',iwrite
           write(6,*) 'level=',k
  100 CONTINUE
C
      do 180 k=1,2
      do 180 j=1,16  
      do 180 i=1,16  
         BUFR(k,i,j)=0.0
  180 CONTINUE
C
      do 200 n=1,5  
      do 200 k=1,NLO
      do 160 j=1,NY
      do 160 i=1,NX
         if(n.eq.1.and.ideafv) then
           BUFR(1,j,i)=REAL(VIDEA(i,j,k))
           BUFR(2,j,i)=AIMAG(VIDEA(i,j,k))
         else
         if(n.eq.3.and.ideah) then
           BUFR(1,j,i)=REAL(HIDEA(i,j,k))
           BUFR(2,j,i)=AIMAG(HIDEA(i,j,k))
         else
         BUFR(1,j,i)=REAL(FRC(i,j,k,n))
         BUFR(2,j,i)=aIMAG(FRC(i,j,k,n))
         end if
         end if
  160 CONTINUE
      WRITE(85) BUFR
      write(6,*) 'level=',k
      if (n.eq.3) then
         write(6,*) 'hidea= ',HIDEA(1,1,k)
      end if
  200 CONTINUE
C
      STOP
      END

