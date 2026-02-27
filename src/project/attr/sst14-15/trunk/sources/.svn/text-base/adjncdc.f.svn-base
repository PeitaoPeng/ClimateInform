!***********************************************************************
!  PROGRAM ADJNCDC.F                                                   *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!    Reads grid-based NCDC observations of 344 climate divisions       *
!    and makes a statistical adjustment to estimate the old NCDC       *
!    station-based climate division dataset which is then written      *
!    in all stations-by-month ASCII format.                            *
!----------------------------------------------------------------------*
! USAGE:  Update forecast archive once per month                       *
!----------------------------------------------------------------------*  
! INPUT FILES                                                          *
!  FT11    INPUT DATES CONTROL FILE 11  (todaysdate.txt)               *
!  FT 12   CALIBRATION CONSTANTS CORRECTING NCDC GRiD TO NCDC STATION  *
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
!    ControlConstantsAdjncdc.f90  - Named ControlConstants             *
!         Contains program driver info                                 *
!     NcdcDiv - NCDC Climate Division Operations.                      *
!     FileOps - File operations                                        *
!    CalOps  - Calander operations                                     *
!----------------------------------------------------------------------*
!  SUBROUTINES USED                                                    *
!  FROM MODULE FileOps                                                 *
!      GETFILES Reads files from control file                          *
!      OPENFILES Opens files                                           *
!  FROM MODULE NcdcDiv                                                 *
!       ADJCD - Calibrates input given calibration constants.          *
!       ASSIGNNCDC - Assigns constants needed for module NcdcDiv       *
!       CPYDATA - Copies data-by-month sequential ASCII files.         *
!      RDCALIBQ - Reads calibration constants                          *
!       RDCDDATA - Reads data-by-month sequential ASCII files.         *
!       WTCDDATA - Writes data-by-month sequential ASCII files.        *
!!  FROM MODULE CalOps                                                 *
!       ADDYR  -  Adds months to calandar year and months              *
!       MONTHLOOP - Returns monthly limits for loops                   *
!                                                                      *
! VARIABLES                                                            *
!  FROM MODULE ControlConstants                                        *
!     jprint = Printing control                                        *
!     ndcd = Dimensions for the climate divisions (344)                *
!    ndx,ndy = Dimension of "faux grid" holding 344 divisions          *
!  FROM LOCAL MODULE                                                   *
!      kvn = Flag for number of output fields per month (one).         *
!       nu = Unit Numbers for input files                              *
!      nuts,nups = Unit numbers for station-based temp and precip.     *
!     nut,nup  =   Unit numbers for grid-based temp and precip.        *
!                 nut+1=output long                                    *
!      nfile = number of files to open                                 *
!      nerr= Error Flag                                                *
!     kh = monthly partition flag  3 for complete months               *
!     jflagt,jflagp = Data Flags for temp and precip                   *
!     jyncdc1, jm1 = First year and month on NCDC archive data sets    *
!     jyc,jmc,jdc = Current date                                       *
!     jycm,jmcm = Last Complete Month of observations                  *
!     jys,jms = Start year and month to adjust data                    *
!        jys = 0 to start from one month prior to jyc,jmc              *
!        jys = -N to start N year(s) prior to jycm,jmcm                *
!     jyr, jm = loop variables for year and month                      *
!     rerrort rerrorp = Error totals for t and p                       *
!    tncdc,pncdc = (js,jm,jy) Array holding NDCD temp and precip       *
!***********************************************************************
USE ControlConstants
USE FileOps
USE CalOps
USE NcdcDiv
      REAL, DIMENSION(ndcd) :: cdt,cdp,cdts,cdps
      INTEGER nu,nfile,kvn,nuts,nups,nut,nup,nerr,jys,jms
      INTEGER jyc,jmc,jdc,jm1,jycm,jmcm,jym1,jmm1,jyr,jm,jmx1,jmx2,jh, &
         kyymm,jflag,jnumsta14,jnumsta16,jnumsta18,jnumsta19
      nu=10
      CALL GETFILES(nu,nfile)
      nu=11
      kvn=1
      nuts=15
      nups=16
      nut=13
      nup=14
      jh=3
      rmiss=-9999.
      PRINT * ,' open the files ',nu
      CALL OPENFILE(nu,1,nfile,jprint,nerr)
      READ(10,91) jprint
      READ(10,91) jyncdc1,jmncdc1
      READ(10,91) jys,jms
      READ(10,91) jakflag
      READ(11,92) jyc,jmc,jdc
 91   FORMAT(2I5)
 92   FORMAT(I5,I3,I3)
      jm1=1
!    INITIALIZE VARIABLES IN MODULES
      CALL ASSIGNNCDC
!         Read calibration constants
      CALL RDCALIBQ(12,nerr)
      IF(nerr /= 0) THEN
           PRINT *,'Error reading Calibration Constants ',nerr
           STOP
      ENDIF
!      the usual case is that the observation is complete through the 
!      last complete month, one month prior to the month programs are
!      run to retrieve data.
      CALL ADDYR(jyc,jmc,-1,jycm,jmcm)
      IF(jys == 0) THEN 
         jys=jycm
         jms=jmcm
      ELSEIF (jys < 0 ) THEN
         jmonth=jys*12
         CALL ADDYR(jyc,jmc,jmonth,jys,jms)
      ENDIF
!      jys, and jms are the year and month to begin to adjust values
!       the above statements are defaults for the usual case of updating
!       a new month that was just recieved  jys=0 or the most recent
!       complete 12-months, in the case of an NCDC update.
      CALL ADDYR(jys,jms,-1,jym1,jmm1)
!       Copy data through the month before we start to adjust
      CALL CPYCDDATA(14,jyncdc1,jmncdc1,jym1,jmm1,jnumsta14,1,nerr,ndcd)
      CALL CPYCDDATA(16,jyncdc1,jmncdc1,jym1,jmm1,jnumsta16,2,nerr,ndcd)
      IF(jakflag == 0) THEN
         jnumsta14=ncdcconus
         jnumsta16=ncdcconus
      ENDIF
!      loop through all months inbetween start and most recent months.
      DO jyr=jys,jycm
         CALL MONTHLOOP(jyr,jys,jms,jycm,jmcm,jmx1,jmx2)
         DO jm=jmx1,jmx2
!            Read, adjust, and write data to the cumulative dataset
            print *,' ndcd ' , ndcd
            CALL RDCDDATA(18,cdt,jyr,jm,jh,jnumsta18,kyymm,1,jflagt,nerr,ndcd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps ',nuct,jyr,jm,nerr
                 STOP
             ENDIF
             print *,' before adjcd ',jycm
             CALL ADJCD(cdt,cdts,jm,1)
             print *,' after adjcd ' ,kyymm
             CALL RDCDDATA(19,cdp,jyr,jm,jh,jnumsta19,kyymm,2,jflagp,nerr,ndcd)
             IF(nerr /= 0) THEN
                 PRINT *,'Error reading cpc temps ',nuct,jyr,jm,nerr
                 STOP
             ENDIF
             CALL ADJCD(cdp,cdps,jm,2)
            CALL WRTCDDATA(15,cdts,jyr,jm,jh,1,jnumsta14,jflagt,nerr,ndcd)
            CALL WRTCDDATA(17,cdps,jyr,jm,jh,2,jnumsta16,jflagp,nerr,ndcd)
         END DO
      END DO
      IF( nerr == 0) THEN 
        print *,"PROGRAM STATUS = 0"
      ELSE
        PRINT *,"ERRORS ENCOUNTERED STATUS = 99 "
      ENDIF
      STOP
      END
            
