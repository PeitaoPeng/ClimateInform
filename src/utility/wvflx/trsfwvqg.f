C
C  PROGRAM TO write the output of WVFLX.F to              
C  modILES INTO A DIRECT ACCESS DATA SET
C  APPROPRIATE FOR GRADS VIEWING.
C
      parameter(nlon=128,nlat=102,nlev1=7,nlev2=5,nlev3=3)
      parameter(lonout=48,latout=40)
      DIMENSION R1(nlon,nlat,nlev1),fild(nlon,nlat)
      DIMENSION ROUT(lonout,latout),fld2(lonout,latout)
      DIMENSION R2(nlon,nlat,nlev2),R3(nlon,nlat,nlev3)
      OPEN(10,FILE='/data/pool/peng/pbhpwv87qg',FORM='UNFORMATTED')
C    +RECORDTYPE='STREAM',CONVERT='BIG_ENDIAN')
      OPEN(80,FILE='/data/pool/peng/pbhp1587qg',FORM='UNFORMATTED',
     +ACCESS='DIRECT',RECL=lonout*latout)
      UNDEF = -2.56E33               
      IREC=0
      CALL XSTGRD                                                       
C.....read and write 7 level data
      do 100 iread=1,4
      read(10) R1
      WRITE (6,*) ' NUMBER OF READ = ',iread
      do 130 k=1,nlev1
      do 120 J=1,nlat
      do 120 I=1,nlon
        fild(I,J)=R1(I,J,k)
120    CONTINUE
      call G40G15(fild,fld2)
      call norsou(fld2,ROUT)
      IREC=IREC+1
      WRITE (80,REC=IREC) ROUT
      WRITE (6,*) ' NUMBER OF RECORDS = ',IREC
130   continue
100   continue
C.....read and write 5 level data
      do 215 k=1,nlev1
      do 215 j=1,nlat
      do 215 i=1,nlon
        R1(i,j,k)=0.       
215    continue
      do 200 iread=1,24
      read(10) R2
      WRITE (6,*) ' NUMBER OF RREAD = ',iread
      do 225 k=1,nlev2
      do 225 j=1,nlat
      do 225 i=1,nlon
        R1(i,j,k+1)=R2(i,j,k)
225    continue
      do 230 k=1,nlev1
      do 220 J=1,nlat
      do 220 I=1,nlon
        fild(I,J)=R1(I,J,k)
220    CONTINUE
      call G40G15(fild,fld2)
      call norsou(fld2,ROUT)
      IREC=IREC+1
      WRITE (80,REC=IREC) ROUT
      WRITE (6,*) ' NUMBER OF RECORDS = ',IREC
230    continue
200   continue
C.....read and write 3 level data
      do 315 k=1,nlev1
      do 315 j=1,nlat
      do 315 i=1,nlon
        R1(i,j,k)=0.       
315    continue
      do 300 iread=1,5 
      read(10) R3
      WRITE (6,*) ' NUMBER OF RREAD = ',iread
      do 325 k=1,nlev3
      do 325 j=1,nlat
      do 325 i=1,nlon
        R1(i,j,k+2)=R3(i,j,k)
325    continue
      do 330 k=1,nlev1
      do 320 J=1,nlat
      do 320 I=1,nlon
        fild(I,J)=R1(I,J,k)
320    CONTINUE
      call G40G15(fild,fld2)
      call norsou(fld2,ROUT)
      IREC=IREC+1
      WRITE (80,REC=IREC) ROUT
      WRITE (6,*) ' NUMBER OF RECORDS = ',IREC
330    continue
300   continue
      STOP
      END
     
      SUBROUTINE norsou(fldin,fldot)
      parameter (lat=40,lon=48) 
      dimension fldin(lon,lat),fldot(lon,lat)
      do 100 j=1,lat
      do 100 i=1,lon
         fldot(i,j)=fldin(i,lat+1-j)
  100 continue
      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCGAU00010
C REGTOGAU - PROGRAM TO INTERPOLATE FROM REGULAR TO GAUSSIAN GRID      CGAU00020
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCGAU00030
      SUBROUTINE G40G15(ARRAYP,ARRAYG)
      PARAMETER (LATIN=102,LONIN=128, LATOUT=40, LONOUT=48,             GAU00040
     *LATINP=LATIN+1,LONINP=LONIN+1,LATOUP=LATOUT+1,LONOUP=LONOUT+1,    GAU00050
     *LNALNB=(LONIN-1)/LONOUT+3,LTALTB=(LATIN-1)/LATOUT+3)              GAU00060
      COMMON/XGRDNT/                                                    GAU00070
     1 ALONP(LONIN),ALATP(LATIN),ALONE(LONINP),ALATE(LATINP),           GAU00080
     A          BLONP(LONOUT),BLATP(LATOUT),BLONE(LONOUP),BLATE(LATOUP),GAU00090
     B          TRPLON(LNALNB,LONOUT),TRPLAT(LTALTB,LATOUT),            GAU00100
     C          LONTRP(LNALNB,LONOUT),LATTRP(LTALTB,LATOUT),            GAU00110
     D          NLNTRP(LONOUT),NLTTRP(LATOUT)                           GAU00120
      DIMENSION ARRAYP(LONIN,LATIN),ARRAYG(LONOUT,LATOUT)               GAU00130
C     CALL XSTGRD                                                       GAU00220
      CALL XINTRP(ARRAYP,ARRAYG)                                        GAU00280
      RETURN                                                            GAU00330
      END                                                               GAU00340
                                                                        GAU00350
      SUBROUTINE XSTGRD                                                 GAU00360
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC GAU00370
C  THIS PROGRAM SETS UP INTERPOLATION ARRAYS                            GAU00380
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC GAU00390
      PARAMETER (LATIN=102,LONIN=128, LATOUT=40, LONOUT=48,             GAU00400
     *LATINP=LATIN+1,LONINP=LONIN+1,LATOUP=LATOUT+1,LONOUP=LONOUT+1,    GAU00410
     *LNALNB=(LONIN-1)/LONOUT+3,LTALTB=(LATIN-1)/LATOUT+3)              GAU00420
      COMMON/XGRDNT/                                                    GAU00430
     1 ALONP(LONIN),ALATP(LATIN),ALONE(LONINP),ALATE(LATINP),           GAU00440
     A          BLONP(LONOUT),BLATP(LATOUT),BLONE(LONOUP),BLATE(LATOUP),GAU00450
     B          TRPLON(LNALNB,LONOUT),TRPLAT(LTALTB,LATOUT),            GAU00460
     C          LONTRP(LNALNB,LONOUT),LATTRP(LTALTB,LATOUT),            GAU00470
     D          NLNTRP(LONOUT),NLTTRP(LATOUT)                           GAU00480
C   ##############################################################      GAU00490
C                                                                       GAU00500
C    GENERAL PURPOSE HORIZONTAL INTERPOLATOR                            GAU00510
C    CAN INTERPOLATE REGULAR TO REGULAR (COARSE OR FINE)                GAU00520
C                    REGULAR TO GAUSSIAN                                GAU00530
C                    GAUSSIAN TO REGULAR (SET UP THIS WAY HERE)         GAU00540
C                    GAUSSIAN TO GAUSSIAN                               GAU00550
C    WILL REORIENT REGULAR INPUT DATA AS NEEDED AND PUT DATA OUT ON     GAU00560
C    GRID ORIENTED WITH THE NORTH POLE AND GREENWICH AS THE FIRST POINT GAU00570
C    DATA CAN BE SUBSEQUENTLY MASKED FOR LAND-SEA DEPENDENCE OR         GAU00580
C    OTHER RELATIONSHIPS                                                GAU00590
C                                                                       GAU00600
C                                                                       GAU00610
C     UNDERFLOWS MAY HAVE TO BE SUPPRESSED                              GAU00620
C                                                                       GAU00630
C     CALL ERRSET(201,256,-1,1,0)                                       GAU00640
C                                                                       GAU00650
C     SET UNDEFINED VALUE FOR INPUT DATA FOUND AT LOCATIONS WHICH       GAU00660
C     ARE NOT TO BE INCLUDED IN INTERPOLATION AND WHICH WILL BE         GAU00670
C     USE ON OUTPUT DATA IF NO VALID DATA LOCATIONS ARE FOUND WITHIN    GAU00680
C     OUTPUT LOCATION                                                   GAU00690
      UNDEF=-999.0                                                      GAU00700
C                                                                       GAU00710
C     HPINEG IS FOR FIRST LATITUDE IN RADIANS                           GAU00720
C     PINEG IS FOR FIRST LONGITUDE IN RADIANS                           GAU00730
C                                                                       GAU00740
      PI=4.0*ATAN(1.0)                                                  GAU00750
      HPINEG =PI/2.0                                                    GAU00760
      PINEG =0.                                                         GAU00770
C                                                                       GAU00780
C     USE SETLON FOR BOTH REGULAR AND GAUSSIAN GRIDS                    GAU00790
C     USE SETLAT FOR REGULAR GRIDS AND GLTTS FOR GAUSSIAN GRIDS         GAU00800
C     USE SETLON AND SETLAT/GLTTS FOR BOTH INPUT AND OUTPUT FIELDS      GAU00810
C                                                                       GAU00820
      CALL SETLON(PINEG,LONIN,ALONP)                                    GAU00830
      CALL GLTTS(LATIN,ALATP)                                           GAU00840
C     CALL SETLAT(HPINEG,LATIN,ALATP)                                   GAU00850
      CALL SETLON(0.0,LONOUT,BLONP)                                     GAU00860
      CALL GLTTS(LATOUT,BLATP)                                          GAU00870
C                                                                       GAU00880
C     CALL TERPWT ONCE TO SETUP WEIGHTING FACTORS AND INDICES FOR       GAU00890
C     GRID INTERPOLATION                                                GAU00900
C                                                                       GAU00910
      CALL TERPWT(ALONP,ALATP,LONIN,LATIN,ALONE,ALATE,                  GAU00920
     A            BLONP,BLATP,LONOUT,LATOUT,BLONE,BLATE,                GAU00930
     B            TRPLON,LONTRP,NLNTRP,TRPLAT,LATTRP,NLTTRP)            GAU00940
      RETURN                                                            GAU00950
      END                                                               GAU00960
                                                                        GAU00970
      SUBROUTINE XINTRP(FIELDA,FIELDB)                                  GAU00980
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC GAU00990
C  THIS PROGRAM INTERPOLATES FROM GAUSSIAN TO REGULAR GRID              GAU01000
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC GAU01010
      PARAMETER (LATIN=102,LONIN=128, LATOUT=40,LONOUT=48,              GAU01020
     *LATINP=LATIN+1,LONINP=LONIN+1,LATOUP=LATOUT+1,LONOUP=LONOUT+1,    GAU01030
     *LNALNB=(LONIN-1)/LONOUT+3,LTALTB=(LATIN-1)/LATOUT+3)              GAU01040
      COMMON/XGRDNT/                                                    GAU01050
     1 ALONP(LONIN),ALATP(LATIN),ALONE(LONINP),ALATE(LATINP),           GAU01060
     A          BLONP(LONOUT),BLATP(LATOUT),BLONE(LONOUP),BLATE(LATOUP),GAU01070
     B          TRPLON(LNALNB,LONOUT),TRPLAT(LTALTB,LATOUT),            GAU01080
     C          LONTRP(LNALNB,LONOUT),LATTRP(LTALTB,LATOUT),            GAU01090
     D          NLNTRP(LONOUT),NLTTRP(LATOUT)                           GAU01100
      DIMENSION FIELDA(LONIN,LATIN),FIELDB(LONOUT,LATOUT)               GAU01110
      CALL TERPLT(FIELDA,LONIN,LATIN,UNDEF,FIELDB,LONOUT,LATOUT,        GAU01120
     A            TRPLON,LONTRP,NLNTRP,TRPLAT,LATTRP,NLTTRP)            GAU01130
C                                                                       GAU01140
C     SET VALUES AT POLES TO THEIR ZONAL AVERAGE                        GAU01150
C                                                                       GAU01160
      CALL POLAVG(FIELDB,LONOUT,LATOUT)                                 GAU01170
C                                                                       GAU01180
      RETURN                                                            GAU01190
      END                                                               GAU01200
