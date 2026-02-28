!***********************************************************************
!  PROGRAM MKCDLONG.F                                                  *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!    Reads 344 climate divisions in CPC-by month format and reformats  *
!         it to the t.long, p.long by-division format                  *
!    lead operations                                                   *
!----------------------------------------------------------------------*
! USAGE:  Update forecast archive once per month                       *
!----------------------------------------------------------------------*  
! INPUT FILES                                                          *
! FT11    INPUT DATES CONTROL FILE 11  (todaysdate.txt)                *
!  FT 12     INPUT CPC TEMP. OBSERVATIONS IN BY-MONTH FORMAT           *            
!  FT 13     INPUT CPC PRECIP. OBSERVATIONS IN BY-MONTH FORMAT         *
!  FT 14     INPUT CPC TEMP. OBSERVATIONS IN BY-DIVISION FORMAT        *            
!  FT 16     INPUT CPC PRECIP. OBSERVATIONS IN BY-DIVISION FORMAT      *
!----------------------------------------------------------------------*
! OUTPUT FILES:                                                        *
!  FT 15     OUTPUT CPC TEMP. OBSERVATIONS IN BY-DIVISION FORMAT       *            
!  FT 17     OUTPUT CPC PRECIP. OBSERVATIONS IN BY-DIVISION FORMAT     *            
!                                                                      *
!----------------------------------------------------------------------*
!   SUBROUTINE AND MODULE USE.                                         *
!   MODULE ControlConstants - Holds overall program control constants  *
!   MODULE Fileops - File operations control                           *
!       SUBROUTINES, GETFILES, OPENFILE                                *
!   MODULE CalOps - Calendar operations                                *
!       SUBROUTINES, ADDYR,MONTHLOOP                                   *
!   MODULE NcdcDiv - Handles NDCD divisional and CPC Forecast Division *
!                    operations.                                       *
!       SUBROUTINES, CHANGEMISSING,CPYCDDATA,FCCONVERT,RDCDDATA,       *
!----------------------------------------------------------------------*
! VARIABLES                                                            *
!  FROM MODULE ControlConstants                                        *
!     jprint = Printing control                                        *
!     ndcd = Dimensions for the climate divisions (357)                *
!     ncdcconus = Lower 48 climate division count (344)
!     rmiss = Missing value indicator                                  *
!  FROM LOCAL MODULE                                                   *
!       nu = Unit Numbers for input files                              *
!      nut,nup = Unit numbers for temp and precip.  Nut=input,         *
!                 nut+1=output long,   similarly for nup.              *
!       nuct,nucp = New CPC 344 climate division temp and precip data  *
!      nfile = number of files to open                                 *
!      nerr= Error Flag                                                *
!     kh = monthly partition flag  3 for complete months               *
!     jflag= Data Flags (not used )                                    *
!     jyncdc1, jm1 = First year and month on NCDC archive data sets    *
!     jylong = First year on t.long and p.long data sets               *
!     jyc,jmc,jdc = Current date                                       *
!     jycm,jmcm = Last Complete Month of observations                  *
!     jyr, jm = loop variables for year and month                      *
!      jys,jms = Start month of the most recent 12-months of data      *
!    jmx1,jmx2  = Start and end month of each year                     *
!     kyymm = date read (not used)                                     *
!    t,p = (jy,jm) Array holding NDCD temp and precip fields           *
!    tn,pn = (jy+1,jm)  Array holding the output temp and precip.      *
!             in Jan, this can be one year larger than t and p arrays  *
!***********************************************************************
!  NOTE:   Current t.long and p.long only have CONUS climate divisions *
!       but NCEI (The agency formerly known as NCDC) has added 13      *
!       Alaskan divisions.  These are chopped out by limiting the "js" *
!       loop range.                                                    *
!***********************************************************************
   USE ControlConstants
   USE NcdcDiv
   USE FileOps
   USE CalOps
   IMPLICIT NONE
     REAL, DIMENSION(:,:), ALLOCATABLE :: t,p,tn,pn
     REAL, DIMENSION(:,:,:), ALLOCATABLE :: cdt,cdp
     INTEGER :: nu,jh,kvn,nuct,nucp,nut,nup,nut1,nup1,nfile,nerr,jflag,js,iy,im
     INTEGER :: jyr,jndx,jyndx,jmx1,jmx2,jm,jylong,jmlong,jys,jms,jnumsta12,jnumsta13, &
      jyc,jmc,jdc,jycm,jmcm,jyc1,jmc1,jmx,jm1,jyear,jyearout,kyear,kyymm,jmncdc1
     REAL :: rmisst,rmissp
!   Reads the control file, initialize some variables, and open files
      CALL GETFILES(10,nfile)
      nu=11
      jh=3
      kvn=1
      nuct=12
      nucp=13
      nut=14
      nup=16
      nut1=nut+1
      nup1=nup+1
      rmiss=-99.0
      rmisst=-99.9
      rmissp=-9.99
      PRINT * ,' open the files ',nu
      CALL OPENFILE(nu,1,nfile,jprint,nerr)
!      Read some control information from the control file
      READ(10,91) jprint
      READ(10,91) jyncdc1,jmncdc1
      READ(10,91) jylong,jmlong
      READ(10,91) jys,jms
      READ(11,92) jyc,jmc,jdc
 91   FORMAT(2I5)
 92   FORMAT(I5,I3,I3)
!      Calculate the previous month.  
      CALL ADDYR(jyc,jmc,-1,jycm,jmcm)
      IF(jys == 0) THEN
         jys = jycm
         jms=jmcm
      ELSEIF (jys < 0) THEN
         jmx=jys*12
         CALL ADDYR(jyc,jmc,jmx,jys,jms)
         IF(jys < jylong) THEN
!           IF n is really small like -99 it backs up before the start of our .long data
!           this signifies a complete re-do of the t.long and p.long data.
           jys=jylong
           jms=1
         ENDIF
      END IF
      CALL ADDYR(jyc,jmc,-2,jyc1,jmc1)
      jm1=1
!     Calculate dimensions and allocate dynamic arrays
      jyear=jyc1-jylong +1
      jyearout=jycm-jys+1
      CALL ASSIGNNCDC
      ALLOCATE (t(jyear,ndm))
      ALLOCATE (p(jyear,ndm))
      kyear=jycm-jylong +1
      ALLOCATE (tn(kyear,ndm))
      ALLOCATE (pn(kyear,ndm))
      ALLOCATE (cdt(ndcd,ndm,jyearout))
      ALLOCATE (cdp(ndcd,ndm,jyearout))
      PRINT *,'Update with month startiing ',jys,jms, ' copy through ',jyc1,jmc1
!     We've subtracted 1 year from the current month 
!     so the loops below index jm=1,12, with jm=1,jmcm from this year
!     and jm=jmc,12 from last year.  (jmcm=12 spans only 1 year)
!    now read the by-division data for all years and months
        DO jyr=jys,jycm
          jyndx=jyr-jys+1
          CALL MONTHLOOP(jyr,jys,jms,jycm,jmcm,jmx1,jmx2)
          DO jm=jmx1,jmx2
            CALL RDCDDATA(12,cdt(1,jm,jyndx),jyr,jm,jh,jnumsta12,kyymm,1,jflag,nerr,ndcd)
!           The missing value indicator on the two files differ, fix it
            CALL CHANGEMISSING(cdt,rmiscd(1),ndcd)
            IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps unit 12 ',jyr,jm,nerr
                 STOP
            ENDIF
            CALL RDCDDATA(13,cdp(1,jm,jyndx),jyr,jm,jh,jnumsta13,kyymm,2,jflag,nerr,ndcd)
            CALL CHANGEMISSING(cdp,rmiscd(2),ndcd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc precip ',nucp,jyr,jm,nerr
                 STOP
             ENDIF
           END DO
        END DO
        DO js=1,ncdcconus
          tn=rmiss
          pn=rmiss
          READ (14,93,iostat=nerr)((t(iy,im),iy=1,jyear),im=1,12)
   93     FORMAT(10F8.3)
          IF(nerr /=0) THEN
              PRINT *,' Input t.long file 14 is bad ',jyear,nerr
              STOP
          ENDIF
          READ (15,93,iostat=nerr)((p(iy,im),iy=1,jyear),im=1,12)
          IF(nerr /=0) THEN
              PRINT *,' Input p.long file is 15 bad ',jyear,nerr
              STOP
          ENDIF
!           when a new year is added, tn and pn arrays are bigger than t and p.
          tn(1:jyear,:)=t(1:jyear,:)
          pn(1:jyear,:)=p(1:jyear,:)
!         Go through the requested number of year's of data, replacing the old with the 
!         new, and adding the new month.  
          DO jyr=jys,jycm
             jndx=jyr-jylong+1
             jyndx=jyr-jys+1
             CALL MONTHLOOP(jyr,jys,jms,jycm,jmcm,jmx1,jmx2)
             DO jm=jmx1,jmx2
                CALL FCCONVERT(tn(jndx,jm),cdt(js,jm,jyndx),rmiss,1)
                CALL FCCONVERT(pn(jndx,jm),cdp(js,jm,jyndx),rmiss,2)
             END DO ! jm
          END DO  ! jyr
          WRITE (16,93,iostat=nerr),tn
          IF(nerr /=0) THEN
             PRINT *,' output T.long file is bad ',nut1,js,nerr
             STOP
          ENDIF      
          WRITE (17,93,iostat=nerr),pn
          IF(nerr /=0) THEN
             PRINT *,' Output p.long file is bad ',nup1,js,nerr
             STOP
          ENDIF
       END DO  ! js
      PRINT *,' PROGRAM STATUS = 0'
      STOP
      END
      
            
 
            




