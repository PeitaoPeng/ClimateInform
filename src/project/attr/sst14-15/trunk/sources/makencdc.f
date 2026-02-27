!***********************************************************************
!  PROGRAM MAKENCDC.F                                                  *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!    Reads the NCDC climate division files from the NCDC website       *
!    and makes the 344 division ascii datasets (for the 344 and 102    *
!    division data) and makes the 357 division direct access for       *
!    the US+Alaska data.                                               *
!----------------------------------------------------------------------*
! USAGE:  Update forecast archive once per month                       *
!----------------------------------------------------------------------*  
! INPUT FILES                                                          *
!  FT11    INPUT DATES CONTROL FILE 11  (todaysdate.txt)               *
!  FT 12     CPC HALF-MONTH TEMP. OBSERVATIONS IN BY-MONTH FORMAT      *
!  FT 14     CPC HALF-MONTH PRECIP. OBSERVATIONS IN BY-MONTH FORMAT    *
!  FT 16     CPC GRID ESTIMATED OF MOST RECENT MONTH  TEMP             *            
!  FT 17     CPC ESTIMATED OF FIRST HALF OF MOST RECENT MONTH  TEMP    *            
!  FT 18     CPC GRID ESTIMATED OF MOST RECENT MONTH  PRECIP           *            
!  FT 19     CPC ESTIMATED OF FIRST HALF OF MOST RECENT MONTH  PRECIP  *            
!                                                                      *
!----------------------------------------------------------------------*
! OUTPUT FILES:                                                        *
!  FT 13    OUTPUT CPC TEMP. OBSERVATIONS IN BY-MONTH FORMAT           *            
!  FT 15    OUTPUT CPC PRECIP. OBSERVATIONS IN BY-MONTH FORMAT         *
!                                                                      *
!----------------------------------------------------------------------*
!      MODULES                                                         *
!    ControlConstants.f90  - Named ControlConstants                    *
!         Contains program driver info                                 *
!     NcdcDiv - NCDC Climate Division Operations.                      *
!     FileOps - File operations                                        *
!     CalOps  - Calander operations                                    *
!----------------------------------------------------------------------*
!   SUBROUTINES USED                                                   *
!   FROM MODULE FileOps                                                *
!    GETFILES                                                          *
!    OPENFILES                                                         *
!   FROM MODULE CalOps                                                 *
!    ADDYR                                                             *
!   FROM MODULE NcdcDiv                                                *
!     CPYCDDATA                                                        *
!     RDCPCGRID                                                        *
!     RDNCDCV
!     WTCDDATA                                                         *
!----------------------------------------------------------------------*
! VARIABLES                                                            *
!  FROM MODULE ControlConstants                                        *
!     jprint = Printing control                                        *
!     ndcd = Dimensions for the CONUS climate divisions (344)          *
!            jyak1,jyncdc1
!     rmiss = Local Missing value indicator                            *
!  FROM LOCAL MODULE                                                   *
!      jmst1 used in subroutine CPYCDDATA 
!       nu = Unit Numbers for input files                              *
!      nfile = number of files to open                                 *
!      nerr= Error Flag                                                *
! jyncdc1, jyak1 =First year and the first Alaska data on NCDC archive.*
!              jylag = The number of years of additional data that     *
!                     are on the NCDC file cfsd jycm. This enables back*
!                     dating. For example, if we want to ingest data   *
!                     from 2012 in 2015, then we have to read 3 years  *
!                     worth of additional NCDC data that are not used. *
!     jy1,jm1 = First year and month of NCDC data to reprocess         *
!               if jy1 is a negative number, then it refers to the     *
!               number of years prior to the most recent data available*
!               usually jy1 = -1 telling the program to reprocess the  *
!               last year only.   jm1 is not used when jy1<0.          *
!     jycm,jmcm = Last Complete Month of observations                  *
!     jyone, jmone,jyymmone = Points to the month exactly 1 year prior *
!                 to the most recent data.  Data before this date are  *
!                 flagged as "Final data".  This allows for NCDC to    *
!                 make minor changes or error corrections on data for  *
!                 up to a year.                                        *
!        jnumsta13 = Actual number of locations on the datasets, this  *
!                 was added to handle Alaskan data.  Some datasets     *
!***      kvn = Flag for number of output fields per month (one).      *
!*****      ndaymin = minimum number of days in input obs to use       *
!      nut,nup = Unit numbers for temp and precip.  Nut=input,         *
!                 nut+1=output long                                    *
!     kh = monthly partition flag  3 for complete months               *
!     jflagt,jflagp = Data Flags for temp and precip                   *
!     jyc,jmc,jdc = Current date                                       *
!     jym1,jmm1 = Last Archive data prior to append, = jmc-2           *
!     jyr, jm = loop variables for year and month                      *
!    cdt,cdp  = Data for the most recent full month (Temp and precip)  *
!    cdt1,cdp1 = New data for the first half of the month              *
!    cdt2,cdp2 = Computed data for the Second half of the month        *
!***********************************************************************
      USE ControlConstants
      USE Calops
      USE Fileops
      USE NcdcDiv
      IMPLICIT NONE
      INTEGER :: NU,JMST,KVN,nfile,nerr,jylag,jy1,jm1,kvar,jyc,jmc,jdc,jh,jmf,jml,jm,jnumsta13
      INTEGER :: jycm,jmcm,jyone,jmone,jyymmone,jmsub,jycpy,jmcpy,kflag,jyymmcur,jyndx,jy,jyncdclst
      nu=10
      jprint=3
      jmst=1
      kvn=1
      rmiss=-9999.
!     Get the control file name and read it, then open files
      CALL GETFILES(nu,nfile)
      nu=11
      PRINT * ,' open the files ',nu
      CALL OPENFILE(nu,1,nfile,jprint,nerr)
      IF( nerr /= 0) THEN
         PRINT *,'Open files failed ',nu
      END IF
!        Read information from the control file
      READ(10,91) jprint
      READ(10,91) jyncdc1,jyak1,jylag
      READ(10,91) jy1,jm1
      READ(10,91) kvar
 91   FORMAT(3I5)
!       Read todays date (or the date supplied in the date)
      READ(11,92) jyc,jmc,jdc
 92   FORMAT(I5,I3,I3)
      jh=3
!      jycm, jmcm is the most recent month of data.
!      jy1 and jm1 are the start of the period to examine and update
!      This provides the ability to update the entire CPC archive 
!       usually only the past 12 months are updated, to give some
!       stability to the CPC long term archive.  Once a year we should
!       check the older data to see if some have changed.
      CALL ADDYR(jyc,jmc,-1,jycm,jmcm)
      CALL ADDYR(jycm,jmcm,-12,jyone,jmone)
      jyymmone=jyone*100+jmone
      print *,jyymmone ,jy1
      IF(jy1 < 0 ) THEN
        jmsub=jy1*12
        CALL ADDYR(jycm,jmcm,jmsub,jy1,jm1)
        IF(jy1 < jyncdc1) THEN
         jy1=jyncdc1
         jm1=1
         jnumsta13=ndcd
        ENDIF
      ENDIF
!      Initialize array and assign some stuff
      CALL ALLOCATENCDCV(jy1,jycm)
      CALL ASSIGNNCDC
      nu=12
!     reads the most recent NCDC data
      jyncdclst=jycm+jylag
      print *,jyncdclst
      CALL RDNCDCV(nu,jyncdclst,jy1,jycm,kvar,nerr)
      IF( nerr /= 0) THEN
         PRINT *,'NCDC read failed ',nu,nerr
         STOP
      END IF
!     Copy the data from archived files to the month before we start to update
      CALL ADDYR(jy1,jm1,-1,jycpy,jmcpy)
      CALL CPYCDDATA(13,jyncdc1,jmst,jycpy,jmcpy,jnumsta13,kvar,nerr,ndcd)
!     The first year and month get promoted to final data, kflag=0
!     subsequent data are still preliminary.
!     Do a manual fixup for special cases.
      DO jy=jy1,jycm
         jyndx=jy-jy1+1
         CALL MONTHLOOP(jy,jy1,jm1,jycm,jmcm,jmf,jml)
         DO jm=jmf,jml
            jyymmcur=jy*100+jm
!           set all data flag for all data one year or more before the latest month as permanent
            IF(jyymmcur > jyymmone) THEN
               kflag = 1
            ELSE
               kflag=0
            ENDIF
            CALL WRTCDDATA(14,vncdc(1,jm,jyndx),jy,jm,jh,kvar,jnumsta13,kflag,nerr,ndcd)
         END DO
      END DO
      CLOSE (14)
      IF(nerr /= 0 ) THEN
       PRINT *,' PROGRAM DID NOT WRITE PROPERLY '
      ELSE
        PRINT *,' PROGRAM STATUS = 0'
      END IF
      STOP
      END

      
 
