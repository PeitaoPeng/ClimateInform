!***********************************************************************
!  PROGRAM TRANSCDFD.F                                                 *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!    Changed the 344 climate divisions in CPC-by month format into     *
!     the 102 forecast divisions                                       *
!----------------------------------------------------------------------*
! USAGE:  Update forecast archive once per month                       *
!----------------------------------------------------------------------*  
! INPUT FILES                                                          *
! FT11    INPUT DATES CONTROL FILE 11  (todaysdate.txt)                *
!  FT 12     DICTIONARY RELATING 344 CDS TO 102 FDS                    *            
!  FT 13     INPUT 102  CPC TEMP. OBSERVATIONS IN BY-MONTH FORMAT      *
!  FT 15     INPUT 102 PRECIP. OBSERVATIONS IN BY-MONTH FORMAT         *            
!  FT 17     INPUT 344 CDS TEMP. OBSERVATIONS IN BY-MONTH FORMAT       *
!  FT 18     INPUT 344 CDS PRECIP. OBSERVATIONS IN BY-MONTH FORMAT     *
!----------------------------------------------------------------------*
! OUTPUT FILES:                                                        *
!  FT 14     OUTPUT CPC TEMP. OBSERVATIONS IN BY-DIVISION FORMAT       *            
!  FT 16     OUTPUT CPC PRECIP. OBSERVATIONS IN BY-DIVISION FORMAT     *            
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
!       SUBROUTINES, CHANGEMISSING,CPYCDDATA,FDCD,RDCDDATA,WTCDDATA    *
!                    RDFDCDTRAN                                        *
!----------------------------------------------------------------------*
! VARIABLES                                                            *
!  FROM MODULE ControlConstants                                        *
!     jprint = Printing control                                        *
!     ndcd = Dimensions for the climate divisions (344)                *
!     ndfd  = Dimensions for the forecast divisions (102)              *
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
!     jyncdc1, jmncdc1 = First year and month on NCDC archive data sets*
!     jyc,jmc,jdc = Current date                                       *
!     jycm,jmcm = Last Complete Month of observations                  *
!     jyr, jm = loop variables for year and month                      *
!      jys,jms = Start month of the most recent 12-months of data      *
!      jycpy,jmcpy = Last year and month to copy                       *
!    jmx1,jmx2  = Start and end month of each year                     *
!     kyymm = date read (not used)                                     *
!    t,p = (jy,jm) Array holding NDCD temp and precip fields           *
!    tn,pn = (jy+1,jm)  Array holding the output temp and precip.      *
!             in Jan, this can be one year larger than t and p arrays  *
!***********************************************************************
USE ControlConstants
USE NcdcDiv
USE FileOps
USE CalOps
IMPLICIT NONE
     INTEGER :: jys,jms,jyc,jmc,jdc,jycm,jmcm,jycpy,jmcpy,jmncdc1,kyymm,jm1,jnumsta13,jnumsta15, &
      jnumsta17,jnumsta18,jakflag
     INTEGER :: nu,kvn,nutran,nuct,nucp,nuct1,nucp1,jh,nfile,nerr,jmmx,jyr,jmx1,jmx2,jm,jflagt,jflagp
     REAL, DIMENSION(ndcd) :: cdt,cdp
     REAL, DIMENSION(ndfd) :: fdt,fdp
!   Reads control file, initialize constants and open files
      nu=10
      CALL GETFILES(nu,nfile)
      nu=11
      kvn=1
      nutran=12
      nuct=13
      nucp=15
      nuct1=17
      nucp1=18
      jh=3
      rmiss=-9999.
      PRINT * ,' open the files ',nu
      CALL OPENFILE(nu,1,nfile,jprint,nerr)
!     Read some constants from the control file.
      READ(10,91) jprint
      READ(10,91) jyncdc1,jmncdc1
      READ(10,91) jys,jms
      READ(10,91) jakflag
      READ(11,92) jyc,jmc,jdc
 91   FORMAT(2I5)
 92   FORMAT(I5,I3,I3)
       jm1=1
      CALL ADDYR(jyc,jmc,-1,jycm,jmcm)
!     If jys = 0 default to starting on last month,
!     If jys < 0 start-jys years prior to the current month
!     jys> 0 gives an absolute year to start.
      IF(jys == 0) THEN 
         jys=jycm
         jms=jmcm
      ELSEIF (jys < 0 ) THEN
         jmmx=jys*12
         CALL ADDYR(jycm,jmcm,jmmx,jys,jms)
         IF(jys < jyncdc1) THEN
!             This indicates that we are starting from scratch and re-doing the entire dataset.
!             since there is no copy, we have to tell the program the number of output locations  
           jys=jyncdc1
           jms=1
           jnumsta13=ndfd
           jnumsta15=ndfd
         ENDIF
      ENDIF
!      ALLOCATE STUFF
      CALL ASSIGNNCDC
!      Copy data through the month before jys,jms.
      CALL ADDYR(jys,jms,-1,jycpy,jmcpy)
!     Read CD to FD translation dictionary, variables are all inside
!       module NcdcDiv
      CALL RDCDFDTRAN(nutran,nerr)
!     Copy old stuff
      CALL CPYCDDATA(13,jyncdc1,jmncdc1,jycpy,jmcpy,jnumsta13,1,nerr,ndfd)
      CALL CPYCDDATA(15,jyncdc1,jmncdc1,jycpy,jmcpy,jnumsta15,2,nerr,ndfd)
!      Do translation from jys,jms through jycm,jmcm.
!     MONTHLOOP just sets proper month loop limits,
!      for each month, read the 344 divisions, do a translation, and 
!      write the 102 divisions.
      IF(jakflag == 0) THEN
         jnumsta13 = ndfdconus
         jnumsta15 = ndfdconus
      ELSE 
         jnumsta13=ndfd
         jnumsta15=ndfd
      ENDIF
      DO jyr=jys,jycm
         CALL MONTHLOOP(jyr,jys,jms,jycm,jmcm,jmx1,jmx2)
         DO jm=jmx1,jmx2
            CALL RDCDDATA(17,cdt ,jyr,jm,jh,jnumsta17,kyymm,1,jflagt,nerr,ndcd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps ',nuct,jyr,jm,nerr
                 STOP
             ENDIF
             print *,' will it ever end ',jnumsta17,jnumsta13,jnumsta15
             CALL FDCD(fdt,cdt,jnumsta17)
             CALL RDCDDATA(18,cdp ,jyr,jm,jh,jnumsta18,kyymm,2,jflagp,nerr,ndcd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc precip ',nucp,jyr,jm,nerr
                 STOP
             ENDIF
                 print *,' the end is near ',jnumsta18
             CALL FDCD(fdp,cdp,jnumsta18)
             CALL WRTCDDATA(14,fdt,jyr,jm,jh,1,jnumsta13,jflagt,nerr,ndfd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps ',nuct,jyr,jm,nerr
                 STOP
             ENDIF
             CALL WRTCDDATA(16,fdp,jyr,jm,jh,2,jnumsta15,jflagp,nerr,ndfd)

          END DO ! JM
      END DO ! JYR
      PRINT *, 'PROGRAM COMPLETE, PROGRAM STATUS = 0'
      STOP
      END      


