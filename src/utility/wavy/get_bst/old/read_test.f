      PROGRAM basic_state    
C=====calculate basic state and verifications
c
      include "ptrunk.h"
c
      PARAMETER ( NW =20, NLV=10, NLIN=57)
      PARAMETER ( NWP1=NW+1)                        
c     PARAMETER ( NYOUT =16,NXOUT=7)
c     PARAMETER ( NYOUT =16,NXOUT=16)
      DIMENSION BUFR(2,NWP1,NWP1)
      DIMENSION BUFR2(2,NWP1,NWP1)
      DIMENSION FLDOUT1(2,NYOUT,NXOUT)
      DIMENSION FLDOUT2(2,NWP1,NWP1)
      DIMENSION AVGV1(2,NWP1,NWP1,NLV), AVGD1(2,NWP1,NWP1,NLV),
     *        AVGT1(2,NWP1,NWP1,NLV), AVGP1(2,NWP1,NWP1,1),
     *        AVGV2(2,NWP1,NWP1,NLV), AVGD2(2,NWP1,NWP1,NLV),
     *        AVGT2(2,NWP1,NWP1,NLV), AVGP2(2,NWP1,NWP1,1),
     *        TSFC1(2,NWP1,NWP1,1), TSFC2(2,NWP1,NWP1,1),
     *        TOPOG(2,NWP1,NWP1,1), WORK(2,NWP1,NWP1,NLIN)
      open(unit=10,form='unformatted',access='direct',recl=8*NWP1*NWP1)
      open(unit=20,form='unformatted',access='direct',recl=8*NWP1*NWP1)
c     open(unit=10,form='unformatted',recl=8*NWP1*NWP1)
c     open(unit=20,form='unformatted',recl=8*NWP1*NWP1)
      open(unit=30,form='unformatted',recl=8*NXOUT*NXOUT)
      open(unit=40,form='unformatted',recl=8*NXOUT*NXOUT)
      open(unit=50,form='unformatted',recl=8*NXOUT*NXOUT)
C.......................................................................
C
C....READ SPECTRAL FIELDS
      INFILE = 10
      IR=0
      CALL READ85(INFILE,BUFR,IR,57,WORK,NWP1)
C
      STOP
      END

*DECK READ85
      SUBROUTINE READ85(INFILE,fldin,IR,LEV,FIELD,NW1)
      DIMENSION FIELD(2,NW1,NW1,LEV),fldin(2,NW1,NW1)
       IRS=IR+1
       IRE=IR+LEV
       DO 1 K=IRS,IRE
       READ(INFILE,rec=K) fldin
      write(6,*) 'iread=', k, 'fldin(2,NW1,NW1)=',fldin(2,21,21)
      do 2 j=1,nw1
      do 2 i=1,nw1
         FIELD(1,i,j,k)=fldin(1,i,j)   
         FIELD(2,i,j,k)=fldin(2,i,j)   
  2   CONTINUE
  1   CONTINUE
      RETURN
      END

*DECK WRTOUT
      SUBROUTINE WRTOUT1(NOUT,FLDIN,FLDOUT,NY,NX,NW1)
      DIMENSION FLDIN(2,NW1,NW1)
      dimension FLDOUT(2,NY,NX)
      DO 1 J=1,NX 
      DO 1 I=1,NY
         FLDOUT(1,I,J)=FLDIN(1,I,J)
         FLDOUT(2,I,J)=FLDIN(2,I,J)
 1    CONTINUE
      WRITE(NOUT) FLDOUT
      RETURN
      END
c
      SUBROUTINE WRTR15(NOUT,FLDIN,NY,NX,NW1)
      DIMENSION FLDIN(2,NW1,NW1)
      dimension FLDOUT(2,16,16)
      DO I=1,16
      DO J=1,16
         FLDOUT(1,I,J)=0.0
         FLDOUT(2,I,J)=0.0
      END DO
      END DO
C        
      DO 1 J=1,NX 
      DO 1 I=1,NY
         FLDOUT(1,I,J)=FLDIN(1,I,J)
         FLDOUT(2,I,J)=FLDIN(2,I,J)
 1    CONTINUE
      WRITE(NOUT) FLDOUT
      RETURN
      END
