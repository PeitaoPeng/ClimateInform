!***********************************************************************
!  PROGRAM UPDTNCDCSTATS.F                                             *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!   Updates adaptive regression constants that calibrate the CPC grid  *
!    estimates to the NCDC Climate Divisions                           *
!----------------------------------------------------------------------*
! USAGE:  Update statistics once per month                             *
!----------------------------------------------------------------------*  
! INPUT FILES                                                          *
!  FT11    INPUT DATES CONTROL FILE 11  (todaysdate.txt)               *
!  FT 12   CALIBRATION CONSTANTS -TEMPS   NCDC GRID TO NCDC STATION    *
!  FT 13   CALIBRATION CONSTANTS -PRECIP  NCDC GRID TO NCDC STATION    *
!  FT 14   CPC GRID PRELIMINARY TEMPERATURE CD                         *
!  FT 15   NCDC PRELIMINARY TEMPERATURE CD                             *            
!  FT 16   CPC GRID PRELIMINARY TEMPERATURE CD  (INPUT)                *
!  FT 17   CPC GRID PRELIMINARY TEMPERATURE CD  (INPUT)                *
!----------------------------------------------------------------------*
! OUTPUT FILES:                                                        *
!  FT 18    OUTPUT BIAS CORRECTION CONSTANTS FOR TEMPERATURE           *            
!  FT 19    OUTPUT BIAS CORRECTION CONSTANTS FOR PRECIP                *
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
!       ASSIGNNCDC - Assigns constants needed for module NcdcDiv       *
!       CPYDATA - Copies data-by-month sequential ASCII files.         *
!      RDCALIBQ - Reads calibration constants                          *
!       RDCDDATA - Reads data-by-month sequential ASCII files.         *
!       WTCDDATA - Writes data-by-month sequential ASCII files.        *
!   FROM MODULE CalOps                                                 *
!       ADDYR  -  Adds months to calandar year and months              *
!                                                                      *
!   FROM MODULE EwmaBc                                                 *
!       RDEWMABC - Reads Bias Correction Constants for EWMA            *
!       ADJEWMA  - Updates EWMA bias correction constants              *
!       WTEWMABC - Writes EWMA bias correction constants.              *
!----------------------------------------------------------------------*
! VARIABLES                                                            *
!  FROM MODULE ControlConstants                                        *
!     jprint = Printing control                                        *
!     ndcd = Dimensions for the climate divisions (344)                *
!    ndx,ndy = Dimension of "faux grid" holding 344 divisions          *
!  FROM MODULE EwmaBc                                                  *
!     ncmin - do adjacent month adjustments when sample is <  ncmin    *
!  FROM LOCAL MODULE                                                   *
!       nu = Unit Numbers for input files                              *
!      nfile = number of files to open                                 *
!      nerr= Error Flag                                                *
!     jyc,jmc,jdc = Current date                                       *
!     jycm,jmcm = Last Complete Month of observations                  *
!     jya,jma =year and month to adjust data                           *
!     bmaxt,bmaxp = Absolute value of maximum bias to adjust           *
!                   Greater values are truncated.                      *
!    rstep  =  Effective decay rate - see subroutine JUMPSTART in      *
!              module EwmaBc for further details.                      *
!    kmin  =  Start of EWMA trial period  See Module EwmaBC for details*
!    alph = EWMA averaging coefficient, see module EwmaBc for details. *
!    cdtcpc,cdpcpc - Array holding cpc T and P estimates               *
!    cdtncdc,cdpndc - Array holding ncdc T and P estimates             *
!***********************************************************************
USE ControlConstants
USE NcdcDiv
USE FileOps
USE CalOps
USE EwmaBc
IMPLICIT NONE
!    Calandar constants
     INTEGER :: jyc,jmc,jdc,jycm,jmcm,jya,jma,kyymm,nu
!    misc constants and variables
     INTEGER ::  kmin,nfile,nerr,jh,jflag,jmon
     INTEGER ::  jnumsta14,jnumsta15,jnumsta16,jnumsta17
     REAL, DIMENSION(ndcd) :: cdtcpc,cdpcpc,cdtncdc,cdpncdc
     REAL,DIMENSION(ndx,ndy) :: f,v
     REAL :: bmaxt,bmaxp,rstep,alph
!   Reads CPC 344 and computes the CPC 102 division dataset
      nu=10
      ncmin=7
     CALL GETFILES(nu,nfile)
      rmiss=-9999.
      rstep=1.
      kmin=0
      PRINT * ,' open the files ',nu
      CALL OPENFILE(nu,1,nfile,jprint,nerr)
      READ(10,91) jprint
      READ(10,93) bmaxt,bmaxp,alph
      READ(11,92) jyc,jmc,jdc

 91   FORMAT(2I5)
 92   FORMAT(I5,I3,I3)
 93   FORMAT(2F5.2,F7.4)
      CALL ASSIGNNCDC
      CALL ADDYR(jyc,jmc,-1,jycm,jmcm)
      CALL RDEWMABC(12,nerr)
      IF( nerr /= 0) THEN
         PRINT *,'READ PROBLEM ON UNIT 12, Input stats , nerr ',nerr
          PRINT *,' PROGRAM STATUS = 99 '
      ENDIF
!      Read the CPC and updated NCDC climate division data.
      CALL RDCDDATA(14,cdtcpc ,jycm,jmcm,jh,jnumsta14,kyymm,1,jflag,nerr,ndcd)
      IF( nerr /= 0) THEN
          PRINT *,'READ PROBLEM ON UNIT 14, Input temps , nerr ',nerr
          PRINT *,' PROGRAM STATUS = 99 '
      ENDIF
      CALL RDCDDATA(15,cdtncdc ,jycm,jmcm,jh,jnumsta15,kyymm,1,jflag,nerr,ndcd)
      IF( nerr /= 0) THEN
          PRINT *,'READ PROBLEM ON UNIT 15, Input temps , nerr ',nerr
          PRINT *,' PROGRAM STATUS = 99 '
      ENDIF
      CALL RDCDDATA(16,cdpcpc ,jycm,jmcm,jh,jnumsta16,kyymm,1,jflag,nerr,ndcd)
      IF( nerr /= 0) THEN
         PRINT *,'READ PROBLEM ON UNIT 16, Input precip , nerr ',nerr
         PRINT *,' PROGRAM STATUS = 99 '
      ENDIF
      CALL RDCDDATA(17,cdpncdc ,jycm,jmcm,jh,jnumsta17,kyymm,1,jflag,nerr,ndcd)
      IF( nerr /= 0) THEN
         PRINT *,'READ PROBLEM ON UNIT 17, Input temps , nerr ',nerr
         PRINT *,' PROGRAM STATUS = 99 '
      ENDIF
!     look to the possible adjustment of the previous, current and 
!      following month.
      DO JMON=-1,1,1
          CALL ADDYR(jycm,jmcm,jmon,jya,jma)
          CALL ADJEWMA(jmcm,jma,cdtcpc,cdtncdc,bmaxt,1,rstep,kmin,alph)
          CALL ADJEWMA(jmcm,jma,cdpcpc,cdpncdc,bmaxp,2,rstep,kmin,alph)
      END DO
!    We adjusted everything, now write out the new constants.
      CALL WTEWMABC(18,nerr)
      IF( nerr /= 0) THEN
           PRINT *,'WRITE PROBLEM ON UNIT 18, Output stats , nerr ',nerr
           PRINT *,' PROGRAM STATUS = 99'
      ELSE
          PRINT *,'PROGRAM STATUS = 0'
      ENDIF
      STOP
      END      

