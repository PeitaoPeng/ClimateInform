!***********************************************************************
!  PROGRAM APPENDHALF.F                                                *
!----------------------------------------------------------------------*
!  LANGUAGE:  FORTRAN 95                                               *
!----------------------------------------------------------------------*
!  MACHINE   COMPUTE FARM                                              *
!----------------------------------------------------------------------*
!  PURPOSE:                                                            *
!    Reads the half-month mean temp or total precip, and then reads    *
!     the full month values, and computes what the second half month   *
!     means or totals from that information                            *
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
!    ControlConstantsMkcdprelim.f90  - Named ControlConstants          *
!         Contains program driver info                                 *
!     NcdcDiv - NCDC Climate Division Operations.                      *
!     FileOps - File operations                                        *
!    CalOps  - Calander operations                                     *
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
!     WTCDDATA                                                         *
!----------------------------------------------------------------------*
! VARIABLES                                                            *
!  FROM MODULE ControlConstants                                        *
!     jprint = Printing control                                        *
!     ndcd = Dimensions for the climate divisions (344)                *
!      jyncdc1= First year on half-month NCDC archive                  *
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
!     jmncdc1 =First month on half-month NCDC archive*
!     jyc,jmc,jdc = Current date                                       *
!     jycm,jmcm = Last Complete Month of observations                  *
!     jym1,jmm1 = Last Archive data prior to append, = jmc-2           *
!     jyr, jm = loop variables for year and month                      *
!    cdt,cdp  = Data for the most recent full month (Temp and precip)  *
!    cdt1,cdp1 = New data for the first half of the month              *
!    cdt2,cdp2 = Computed data for the Second half of the month        *
!***********************************************************************
USE ControlConstants
USE NcdcDiv
USE FileOps
USE CalOps
IMPLICIT NONE
     REAL, DIMENSION(ndfd) :: cdt,cdp,cdt1,cdt2,cdp1,cdp2,bc
     INTEGER :: nu,jmncdc1,jys,jms,jyc,jmc,jdc,jycm,jmcm,jmmx, &
            jym1,jmm1,jmx1,jmx2,jflag,kyymm,jh,jyr,jm,nerr,jdays,jm1,kvn, &
            nfile,jnumsta12,jnumsta14,jnumsta16,jnumsta17,jnumsta18
     REAL :: rmissp,rdays
!       GET INFORMATION FROM CONTROL FILE, OPEN FILES AND READ CONTROL INFO.
      nu=10
      CALL GETFILES(nu,nfile)
      kvn=1
      jh=1
      rmiss=-9999.
      rmissp=rmiss+.01
      PRINT * ,' open the files ',nu
      nu=11
      CALL OPENFILE(nu,1,nfile,jprint,nerr)
      READ(10,91) jprint
      READ(10,91) jyncdc1,jmncdc1
      READ(11,92) jyc,jmc,jdc
 91   FORMAT(2I5)
 92   FORMAT(I5,I3,I3)
      jm1=1
!       Assign constants
      CALL ASSIGNNCDC
!     set the date of the last month of data, and the month before that
      CALL ADDYR(jyc,jmc,-1,jycm,jmcm)
      CALL ADDYR(jyc,jmc,-2,jym1,jmm1)
      CALL CPYCDDATA(12,jyncdc1,jmncdc1,jym1,jmm1,jnumsta12,3,nerr,ndfd)
      CALL CPYCDDATA(14,jyncdc1,jmncdc1,jym1,jmm1,jnumsta14,4,nerr,ndfd)
      CALL RDCDDATA(16,cdt ,jycm,jmcm,jh,jnumsta16,kyymm,1,jflag,nerr,ndfd)
      IF(nerr /= 0) THEN
           PRINT *,'Error reading cpc temps unit 16 ',jyr,jm,nerr
           STOP
      ENDIF
!    Read new half-month cd102 file , compute difference, between first 
!     half of the month and the entire month, and compute the second half. 
!    Note because of code reuse this was temporarily labled as a full month value.
!    Half month data always has 15 days in the first half. GETDAYS handles
!    variable month lenghts.
      CALL RDCDDATA(17,cdt1 ,jycm,jmcm,1,jnumsta17,kyymm,1,jflag,nerr,ndfd)
      CALL GETDAYS(jycm,jmcm,jdays)
      rdays=float(jdays)
      WHERE (cdt1 > rmissp)  cdt2=(cdt*rdays-cdt1*15.)/(rdays-15.)
      WHERE (cdt < rmissp) cdt2=rmiss
      CALL WRTCDDATA(13,cdt1,jycm,jmcm,1,3,jnumsta12,jflag,nerr,ndfd)
      CALL WRTCDDATA(13,cdt2,jycm,jmcm,2,3,jnumsta12,jflag,nerr,ndfd)
!*******************************************************************
! NOW DO PRECIPITATION 
!*****************************************************************
!            Read the full month estimate
      CALL RDCDDATA(18,cdp ,jycm,jmcm,1,jnumsta18,kyymm,2,jflag,nerr,ndfd)
      IF(nerr /= 0) THEN
           PRINT *,'Error reading cpc half mmonth precip unit 18 ',jyr,jm,nerr
           STOP
      ENDIF
!    Read new cd102 file , compute difference, and add to each half-month 
!    Note because of code reuse this was temporarily labled as a full month value.
      CALL RDCDDATA(19,cdp1 ,jycm,jmcm,1,jnumsta18,kyymm,2,jflag,nerr,ndfd)
      IF(nerr /= 0) THEN
         PRINT *,'Error reading cpc temps unit 19 ',jyr,jm,nerr
         STOP
      ENDIF
      WHERE (cdp1 > rmissp)  cdp2=cdp-cdp1
      WHERE (cdp < rmissp) cdp2=rmiss
      CALL WRTCDDATA(15,cdp1,jycm,jmcm,1,4,jnumsta14,jflag,nerr,ndfd)
      CALL WRTCDDATA(15,cdp2,jycm,jmcm,2,4,jnumsta14,jflag,nerr,ndfd)
      IF(nerr /= 0) THEN
             PRINT *,'Error writing cpc temps unit 15 ',jyr,jm,nerr
             STOP
      ENDIF
      PRINT *, 'PROGRAM COMPLETE, PROGRAM STATUS = 0'
      STOP
      END      


