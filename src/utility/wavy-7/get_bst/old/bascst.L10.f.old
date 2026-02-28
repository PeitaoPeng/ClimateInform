      PROGRAM basic_state    
C=====calculate basic state and verifications
c
      include "ptrunk.h"
c
      PARAMETER ( NW =20, NLV=10, NLIN=18)
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
      open(unit=10,form='unformatted',access='direct',recl=8*NWP1*NWP1,
     *convert="BIG_ENDIAN")
      open(unit=20,form='unformatted',access='direct',recl=8*NWP1*NWP1,
     *convert="BIG_ENDIAN")
c     open(unit=20,form='unformatted',access='direct',recl=8*NWP1*NWP1)
c     open(unit=20,form='unformatted',access='direct',recl=8*NWP1*NWP1)
c     open(unit=10,form='unformatted',recl=8*NWP1*NWP1)
c     open(unit=20,form='unformatted',recl=8*NWP1*NWP1)
      open(unit=30,form='unformatted',recl=8*NXOUT*NYOUT)
      open(unit=35,form='unformatted',access='direct',recl=8*16*16)
      open(unit=40,form='unformatted',recl=8*NXOUT*NYOUT)
      open(unit=50,form='unformatted',access='direct',recl=8*16*16)
C.......................................................................
C
C....READ SPECTRAL FIELDS
      INFILE = 10
      IREAD=0
      CALL READ85 (INFILE,BUFR,IREAD,1,AVGP1,NWP1)
      IREAD=IREAD+1
      CALL READ85 (INFILE,BUFR,IREAD,NLIN,WORK,NWP1)
           CALL INTPBST(WORK,AVGD1)
      IREAD=IREAD+NLIN
      CALL READ85 (INFILE,BUFR,IREAD,NLIN,WORK,NWP1)
           CALL INTPBST(WORK,AVGV1)
      IREAD=IREAD+NLIN
      CALL READ85 (INFILE,BUFR,IREAD,NLIN,WORK,NWP1)
           CALL INTPBST(WORK,AVGT1)
      IREAD=IREAD+NLIN
      CALL READ85 (INFILE,BUFR,IREAD,1,TSFC1,NWP1)
      IREAD=IREAD+1
      CALL READ85 (INFILE,BUFR,IREAD,1,TOPOG,NWP1)
C
      write(6,*) 'have read unit 10'
      INFILE = 20
      IREAD=0
      CALL READ85 (INFILE,BUFR,IREAD,1,AVGP2,NWP1)
      IREAD=IREAD+1
      CALL READ85 (INFILE,BUFR,IREAD,NLIN,WORK,NWP1)
           CALL INTPBST(WORK,AVGD2)
      IREAD=IREAD+NLIN
      CALL READ85 (INFILE,BUFR,IREAD,NLIN,WORK,NWP1)
           CALL INTPBST(WORK,AVGV2)
      IREAD=IREAD+NLIN
      CALL READ85 (INFILE,BUFR,IREAD,NLIN,WORK,NWP1)
           CALL INTPBST(WORK,AVGT2)
      IREAD=IREAD+NLIN
      CALL READ85 (INFILE,BUFR,IREAD,1,TSFC2,NWP1)
      write(6,*) 'have read unit 20'
c
      NOUT1=30
      NOUT2=40
      NOUT3=50
      NOUT4=35
      iwrite=0
C.......lnPs
      do 110 j=1,NWP1
      do 110 i=1,NWP1
c        BUFR(1,i,j)=0.5*(AVGP1(1,i,j,1)+AVGP2(1,i,j,1))
c        BUFR(2,i,j)=0.5*(AVGP1(2,i,j,1)+AVGP2(2,i,j,1))
         BUFR2(1,i,j)=AVGP1(1,i,j,1)-AVGP2(1,i,j,1)
         BUFR2(2,i,j)=AVGP1(2,i,j,1)-AVGP2(2,i,j,1)
         BUFR(1,i,j)=AVGP2(1,i,j,1)
         BUFR(2,i,j)=AVGP2(2,i,j,1)
  110 CONTINUE
          iw15=0
          CALL WRTOUT1(NOUT1,BUFR,FLDOUT1,NYOUT,NXOUT,NWP1)
          iw15=iw15+1
          CALL WRTR15(NOUT4,BUFR,NYOUT,NXOUT,NWP1,iw15)
          CALL WRTOUT1(NOUT2,BUFR2,FLDOUT1,NYOUT,NXOUT,NWP1)
          write(6,*) 'have written out AVGP'
           iwrite=iwrite+1
           write(6,*) 'iwrite=',iwrite
           write(6,*) 'lnPs'
C.......Divergence
      do 220 k=1,NLV
      do 120 j=1,NWP1
      do 120 i=1,NWP1
c        BUFR(1,i,j)=0.5*(AVGD1(1,i,j,k)+AVGD2(1,i,j,k))
c        BUFR(2,i,j)=0.5*(AVGD1(2,i,j,k)+AVGD2(2,i,j,k))
	 BUFR2(1,i,j)=AVGD1(1,i,j,k)-AVGD2(1,i,j,k)
         BUFR2(2,i,j)=AVGD1(2,i,j,k)-AVGD2(2,i,j,k)
         BUFR(1,i,j)=AVGD2(1,i,j,k)
         BUFR(2,i,j)=AVGD2(2,i,j,k)
  120 CONTINUE
          CALL WRTOUT1(NOUT1,BUFR,FLDOUT1,NYOUT,NXOUT,NWP1)
          iw15=iw15+1
          CALL WRTR15(NOUT4,BUFR,NYOUT,NXOUT,NWP1,iw15)
          CALL WRTOUT1(NOUT2,BUFR2,FLDOUT1,NYOUT,NXOUT,NWP1)
           iwrite=iwrite+1
           write(6,*) 'iwrite=',iwrite
220   continue
           write(6,*) 'divergence'
C.......vorticity 
      do 230 k=1,NLV
      do 130 j=1,NWP1
      do 130 i=1,NWP1
c        BUFR(1,i,j)=0.5*(AVGV1(1,i,j,k)+AVGV2(1,i,j,k))
c        BUFR(2,i,j)=0.5*(AVGV1(2,i,j,k)+AVGV2(2,i,j,k))
	 BUFR2(1,i,j)=AVGV1(1,i,j,k)-AVGV2(1,i,j,k)
         BUFR2(2,i,j)=AVGV1(2,i,j,k)-AVGV2(2,i,j,k)
         BUFR(1,i,j)=AVGV2(1,i,j,k)
         BUFR(2,i,j)=AVGV2(2,i,j,k)
  130 CONTINUE
          CALL WRTOUT1(NOUT1,BUFR,FLDOUT1,NYOUT,NXOUT,NWP1)
          iw15=iw15+1
          CALL WRTR15(NOUT4,BUFR,NYOUT,NXOUT,NWP1,iw15)
          CALL WRTOUT1(NOUT2,BUFR2,FLDOUT1,NYOUT,NXOUT,NWP1)
           iwrite=iwrite+1
           write(6,*) 'iwrite=',iwrite
230   continue
           write(6,*) 'vorticity'
C.....dummy moisture field
      do 250 k=1,NLV
      do 150 j=1,NWP1
      do 150 i=1,NWP1
         BUFR(1,i,j)=0.                                   
         BUFR(2,i,j)=0.                                    
         BUFR2(1,i,j)=0.                                   
         BUFR2(2,i,j)=0.                                    
  150 CONTINUE
          CALL WRTOUT1(NOUT1,BUFR,FLDOUT1,NYOUT,NXOUT,NWP1)
          iw15=iw15+1
          CALL WRTR15(NOUT4,BUFR,NYOUT,NXOUT,NWP1,iw15)
          CALL WRTOUT1(NOUT2,BUFR2,FLDOUT1,NYOUT,NXOUT,NWP1)
           iwrite=iwrite+1
           write(6,*) 'iwrite=',iwrite
250   CONTINUE
           write(6,*) 'moisture'
C.....virtual temp
      do 240 k=1,NLV
      do 140 j=1,NWP1
      do 140 i=1,NWP1
c        BUFR(1,i,j)=0.5*(AVGT1(1,i,j,k)+AVGT2(1,i,j,k))
c        BUFR(2,i,j)=0.5*(AVGT1(2,i,j,k)+AVGT2(2,i,j,k))
	 BUFR2(1,i,j)=AVGT1(1,i,j,k)-AVGT2(1,i,j,k)
         BUFR2(2,i,j)=AVGT1(2,i,j,k)-AVGT2(2,i,j,k)
         BUFR(1,i,j)=AVGT2(1,i,j,k)  
         BUFR(2,i,j)=AVGT2(2,i,j,k)  
  140 CONTINUE
          CALL WRTOUT1(NOUT1,BUFR,FLDOUT1,NYOUT,NXOUT,NWP1)
          iw15=iw15+1
          CALL WRTR15(NOUT4,BUFR,NYOUT,NXOUT,NWP1,iw15)
          CALL WRTOUT1(NOUT2,BUFR2,FLDOUT1,NYOUT,NXOUT,NWP1)
           iwrite=iwrite+1
           write(6,*) 'iwrite=',iwrite
240   CONTINUE
           write(6,*) 'virtual temp'
C
C.......Tsfc anomaly
      do 300 j=1,NWP1
      do 300 i=1,NWP1
         BUFR(1,i,j)=TSFC1(1,i,j,1)-TSFC2(1,i,j,1)
         BUFR(2,i,j)=TSFC1(2,i,j,1)-TSFC2(2,i,j,1)
  300 CONTINUE
          CALL WRTOUT1(NOUT1,BUFR,FLDOUT1,NYOUT,NXOUT,NWP1)
          iw15=iw15+1
          CALL WRTR15(NOUT4,BUFR,NYOUT,NXOUT,NWP1,iw15)
           iwrite=iwrite+1
           write(6,*) 'iwrite=',iwrite
           write(6,*) 'TSFC anomaly'
C.......topography
          CALL WRTOUT1(NOUT1,TOPOG,FLDOUT1,NYOUT,NXOUT,NWP1)
          iw15=iw15+1
          CALL WRTR15(NOUT4,TOPOG,NYOUT,NXOUT,NWP1,iw15)
           iwrite=iwrite+1
           write(6,*) 'iwrite=',iwrite
          CALL WRTR15(NOUT3,TOPOG,NYOUT,NXOUT,NWP1,1)
           write(6,*) 'topog'
      STOP
      END

*DECK READ85
      SUBROUTINE READ85 (NSFILE,fldin,IS,LEV,FIELD,NW1)
      DIMENSION FIELD(2,NW1,NW1,LEV),fldin(2,NW1,NW1)
       IRS=IS+1
       IRE=IS+LEV
       DO 1 K=IRS,IRE
         READ(NSFILE,rec=K) fldin
c     write(6,*) 'iread=',k,'  IRS=',IRS,'  IRE=',IRE, fldin(2,21,21)
         
      do 2 j=1,nw1
      do 2 i=1,nw1
         FIELD(1,i,j,k-IS)=fldin(1,i,j)   
         FIELD(2,i,j,k-IS)=fldin(2,i,j)   
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
      SUBROUTINE WRTR15(NOUT,FLDIN,NY,NX,NW1,iw)
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
      WRITE(NOUT,rec=iw) FLDOUT
      RETURN
      END
