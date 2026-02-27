PROGRAM mkcdprelim
!***********************************************************************
!  PROGRAM MKCDPRELIM.F                                                *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!    Reads preliminary monthly totals of 344 climate divisions         *
!    based on CPC gridded observations and formats it for CPC long     *
!    lead operations                                                   *
!----------------------------------------------------------------------*
! USAGE:  Update forecast archive once per month                       *
!----------------------------------------------------------------------*  
! INPUT FILES                                                          *
!  FT11    INPUT DATES CONTROL FILE 11  (todaysdate.txt)               *
!  FT 12   BIAS CORRECTION CONSTANTS CORRECTING CPC TO NCDC DATA       *
!  FT 13     INPUT CPC TEMP. OBSERVATIONS IN BY-MONTH FORMAT           *
!  FT 15     INPUT CPC PRECIP. OBSERVATIONS IN BY-MONTH FORMAT         *
!  FT 17     INPUT CPC GRID ESTIMATED TEMP. AND PRECIP OBSERVATIONS    *            
!                                                                      *
!----------------------------------------------------------------------*
! OUTPUT FILES:                                                        *
!  FT 14    OUTPUT CPC TEMP. OBSERVATIONS IN BY-MONTH FORMAT           *            
!  FT 16    OUTPUT CPC PRECIP. OBSERVATIONS IN BY-MONTH FORMAT         *
!                                                                      *
!----------------------------------------------------------------------*
!      MODULES                                                         *
!    ControlConstantsMkcdprelim.f90  - Named ControlConstants          *
!         Contains program driver info                                 *
!     NcdcDiv - NCDC Climate Division Operations.                      *
!     FileOps - File operations                                        *
!    CalOps  - Calander operations                                     *
!    EwmaBC - Exponential moving average bias corrector routines.      *
!----------------------------------------------------------------------*
!                                                                      *
!   SUBROUTINES USED                                                   *
!   FROM MODULE FileOps                                                *
!    GETFILES                                                          *
!    OPENFILES                                                         *
!   FROM MODULE CalOps                                                 *
!    ADDYR                                                             *
!   FROM MODULE EwmaBc                                                 *
!     RDBIASCOR                                                        *
!     NCDCBIASC                                                        *  
!     RDEWMABC                                                         *
!   FROM MODULE NcdcDiv                                                *
!     CPYCDDATA                                                        *
!     RDCPCGRID                                                        *
!     WTCDDATA                                                         *
!----------------------------------------------------------------------*
! VARIABLES                                                            *
!  FROM MODULE ControlConstants                                        *
!     jprint = Printing control                                        *
!     ndcd = Dimensions for the climate divisions (357)                *
!     ncdcconus = Number of divisions in the CONUS (344)
!  FROM LOCAL MODULE                                                   *
!      kvn = Flag for number of output fields per month (one).         *
!      ndaymin = minimum number of days in input obs to use            *
!       nu = Unit Numbers for input files                              *
!      nut,nup = Unit numbers for temp and precip.  Nut=input,         *
!                 nut+1=output long                                    *
!      nfile = number of files to open                                 *
!      nerr= Error Flag                                                *
!     kh = monthly partition flag  3 for complete months               *
!     jflagt,jflagp = Data Flags for temp and precip                   *
!     jyncdc1, jm1 = First year and month on NCDC archive data sets    *
!     jyc,jmc,jdc = Current date                                       *
!     jycm,jmcm = Last Complete Month of observations                  *
!     jym1,jmm1 = Last Archive data prior to append, = jmc-2           *
!     jyr, jm = loop variables for year and month                      *
!***********************************************************************
USE ControlConstants
USE NcdcDiv
USE FileOps
USE CalOps
USE EwmaBc
USE AlaskaEst
IMPLICIT NONE
     REAL, DIMENSION(ndcd) :: cdt,cdp,cdtc,cdpc
     INTEGER :: nu,nfile,nerr
     INTEGER :: jm,jm1,jflagp,jflagt,jakflag,jyc,jmc,jdc,jycm,jmcm,jym1,jmm1,jmncdc1
     INTEGER :: kh,kvn,ndaymin,khv,jnumsta14,jnumsta16
!       GET INFORMATION FROM CONTROL FILE, OPEN FILES AND READ CONTROL INFO.
      nu=10
      CALL GETFILES(nu,nfile)
      kh=3
      khv=1
      kvn=1
      nu=11
      rmiss=-9999.
      PRINT * ,' open the files ',nu
      CALL OPENFILE(nu,1,nfile,jprint,nerr)
      READ(10,91) jprint
      READ(10,91) jyncdc1,jmncdc1
      READ(10,91) ndaymin
      READ(10,91) jakflag
      READ(11,92) jyc,jmc,jdc
 91   FORMAT(2I5)
 92   FORMAT(I4,I3,I3)
      jm1=1
!       Assign constants
      CALL ASSIGNNCDC
!     set the date of the last month of data, and the month before that
      CALL ADDYR(jyc,jmc,-1,jycm,jmcm)
      CALL ADDYR(jyc,jmc,-2,jym1,jmm1)
      PRINT *,' Current Date ',jyc,jmc,jdc
      PRINT *,' Copy data through ',jym1,jmm1
      PRINT *,' Add data          ' , jycm,jmcm
!      Read bias correction adjustments
      CALL RDEWMABC(12,nerr)
      IF(nerr /= 0) THEN
         PRINT *,' Problem reading translation coefficients file 12/13',nerr
         PRINT *,'PROGRAM FAILED STATUS = ',nerr
         STOP
      ENDIF
!      Copy previous data, Temperature then precipitation
      CALL CPYCDDATA(14,jyncdc1,jmncdc1,jym1,jmm1,jnumsta14,kvn,nerr,ndcd)
      print *,' jnumsta14 ', jnumsta14
      IF(nerr /= 0) THEN
         PRINT *,' Problem with Copy File 14/15',nerr
         PRINT *,'PROGRAM FAILED STATUS = ',nerr
         STOP
      ENDIF
      kvn=2
      CALL CPYCDDATA(16,jyncdc1,jmncdc1,jym1,jmm1,jnumsta16,kvn,nerr,ndcd)
      print *,' jnumsta14,16 ', jnumsta14, jnumsta16
      IF(nerr /= 0) THEN
         PRINT *,' Problem with Copy File 16/17',nerr
         PRINT *,'PROGRAM FAILED STATUS = ',nerr
         STOP
      ENDIF
!         Read the new grid estimates from CPC data.
      PRINT *,' Read new estimates ',ndcd
      CALL RDCPCGRID(18,cdt,cdp,ndaymin,nerr)
      IF(nerr /= 0) THEN
         PRINT *,' Problem with CPC Grid Estimates File 18',nerr
         PRINT *,'PROGRAM FAILED STATUS = ',nerr
         STOP
      ENDIF
      IF(jakflag == 1) THEN
         CALL AKEST(21,jycm,jmcm,ncdcconus,cdt,cdp,nerr)
      ELSE
          jnumsta14=ncdcconus
          jnumsta16=ncdcconus
      ENDIF
!      jflag=2 indicates preliminary CPC grid based products.
      jflagt=2
      jflagp=2
!      Adjust bias and write out.
      PRINT *,'Make Adjustment ',jmcm
      CALL NCDCBIASC(cdt,cdtc,1,jmcm)
      CALL NCDCBIASC(cdp,cdpc,2,jmcm)
      PRINT *,' Write new data ',jnumsta14,jnumsta16,ndcd
       CALL WRTCDDATA(15,cdtc,jycm,jmcm,kh,1,jnumsta14,jflagt,nerr,ndcd)
       CALL WRTCDDATA(17,cdpc,jycm,jmcm,kh,2,jnumsta16,jflagp,nerr,ndcd)
       CALL WRTCDDATA(19,cdtc,jycm,jmcm,kh,1,jnumsta14,jflagt,nerr,ndcd)
       CALL WRTCDDATA(20,cdpc,jycm,jmcm,kh,2,jnumsta16,jflagp,nerr,ndcd)
      PRINT *,'PROGRAM STATUS = 0'
     STOP
     END

