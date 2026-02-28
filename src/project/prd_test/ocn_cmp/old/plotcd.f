!   Program plot CD's
!    Read in F = 102 forecast division
!    Read in C = Climo
!    Read in mx=Translation file
!    Make grid
!    Write to grads file
      INTEGER, PARAMETER :: ndfd=102,ndx=322,ndy=162
      REAL, DIMENSION(ndfd) :: f,a
      REAL, DIMENSION(2,ndfd,12) :: c
      INTEGER, DIMENSION(ndx,ndy) :: mx
      REAL, DIMENSION(ndx,ndy) :: g,rmx
      jdate=2013
      jm=1
      jh=3
      nvar=1
      jf=1950
      rmiss=-9999
      jfill=0
      OPEN(10,file='/export/cpc-lw-dunger/wd53du/cddata/cd102t.dat')
      OPEN(11,file='/export/cpc-lw-dunger/wd53du/cddata/mn3102t.dat')
       OPEN(12,file='/export/cpc-lw-dunger/wd53du/grids/fd322x162.gs',&
      access ='direct', form='unformatted',recl=322*162*4)  
      OPEN(13,file='/export/cpc-lw-dunger/wd53du/cdtemp/cdanom.gs', &
      access ='direct', form='unformatted',recl=322*162*4)
      READ(12,rec=1) rmx
      mx=rmx
      CALL RDCLM(11,c,jdate,jf,nerr,ndfd)
      CALL RDCDDATA(10,f,jdate,jm,jh,kyymm,nvar,jflag,nerr,ndfd)
      print *, f(1)
      print *, c(1,1,jm)
      a=f-c(1,:,jm)
      print *,mx(160,80)
      CALL QGRID(a,g,mx,jfill,rmiss,ndx,ndy,ndfd)
      print *,g(160,80)
      WRITE(13,rec=1) g
      STOP
      END
      SUBROUTINE QGRID(f,g,mx,jfill,rmiss,ngx,ngy,ndfd)
!***********************************************************************
!  PURPOSE:
!*  PLACES A FEILD CONSISTING OF A ONE DIMENSIONAL ARRAY OF LOCATIONS  *
!*  ,F, ON A GRID, G, OF  NGX,NGY GRID GIVEN TRANSLATION GRID MX WHICH *
!*   MAPS ARRAY F ONTO G.  THIS IS CAN BE USED FOR A NEAREST GRIDPOINT *
!*    TYPE ANALYSIS, OR FOR REGIONAL-TO-GRID MAPPING WITHOUT           *
!*    INTERPOLATION                                                    *
!*---------------------------------------------------------------------*
!* LANGUAGE    FORTRAN 90                                              *
!*---------------------------------------------------------------------*
!* MACHINE     linux                                                   *
!*---------------------------------------------------------------------*
!*--------------------------------------------- -----------------------*
!* SUBROUTINES USED:   NONE                                            *
!*---------------------------------------------------------------------*
!* VARIABLES
!*  INPUT
!*    f = an ordered array of forecast values. (stations, climate divs.*
!*   mx = an array containing the element in array f (position) that   *
!*        corresponds to each grid square in g.  mx(i,j) has -1*element*
!*        when the grid square is over water, signifying the ocean mask*
!*        This can be then used to mask ocean areas, or continue to    *
!*        just place the nearest neighbor analysis anyway according to *
!*        option jfill                                                 *
!* jfill = 0 to mask out oceans/water 1 to place a value from the f    *
!*         array over oceanic regions.                                 *
!* rmiss  = Missing value indicator                                     *
!* ngx,ngy = x and y grid dimensions                                   *
!* ndfd   = array dimension of one dimensional array f                 *
!* OUTPUT
!*    g = gridded tranlation of f                                      *
!***********************************************************************
      REAL, DIMENSION(ndfd) :: f
      INTEGER, DIMENSION(ngx,ngy) :: mx
      REAL, DIMENSION(ngx,ngy) :: g
      nerr=0
      DO   jy=1,ngy
        DO   jx=1,ngx
          g(jx,jy)=rmiss
          jn=mx(jx,jy)
          jn2=ABS(jn)
          IF(jn .LE. 0) THEN
            IF(jfill .EQ. 1) THEN
              jn=ABS(jn)
              g(jx,jy)=f(jn)
            ELSE
              g(jx,jy)=rmiss
            ENDIF
          ELSE
             g(jx,jy)=f(jn)
          ENDIF
        END DO
      END DO
      RETURN
      END      
      SUBROUTINE RDCLM(nu,c,jy,jf,nerr,ndfd)
!***********************************************************************
!*   SUBROUTINE RDCLM    NOTE SHOULD SOON BE REPLACED BY RDCLIMCD      *
!*---------------------------------------------------------------------*
!* LANGUAGE    FORTRAN 90                                              *
!*---------------------------------------------------------------------*
!* MACHINE     linux                                                   *
!*---------------------------------------------------------------------*
!* PURPOSE:  C       Reads the 102 climate division temperature,       *
!*    precip or degree day files   mean (1), SD, 2                     *
!*---------------------------------------------------------------------*
!* FILES USED  NONE                                                    *
!*---------------------------------------------------------------------*
!* SUBROUTINES USED: NONE                                              *
!*---------------------------------------------------------------------*
!* CALL ARGUMENTS:                                                     *
!*  INPUT VARIABLES: nu = unit number of input file holding climos     *
!        ndfd =  dimension of stations                                 * 
!    OUTPUT VARIABLES                                                  *
!      c = climo 1=mean 2=st. dev., for station,month and              *
!*---------------------------------------------------------------------*
      REAL, DIMENSION(2,ndfd,12) :: c
      nerr=0
      jfx=(jf-5)/10
      kwmo=jy/10-196 
      IF(kwmo == 0) jwmo=1
      DO  jwmo=1,kwmo
        DO  jm=1,12
          READ(nu,91,iostat=nerr)km,kx,ky1,ky2,kid,kg1,kg2
 91       FORMAT(7I5)
          IF(nerr /= 0) RETURN
          READ(nu,92)(c(1,js,jm),js=1,ndfd)
         READ(nu,92)(c(2,js,jm),js=1,ndfd)
  92     FORMAT(10F8.2)
        END DO
      END DO
      RETURN
      END
      SUBROUTINE RDCDDATA(nu,x,ky,km,kh,kyymm,nvar,jflag,nerr,ndsta)
!***********************************************************************
!*   SUBROUTINE RDCDDATA(nu,x,ky,km,kh,kyymm,nvar,jflag,ndsta)         *
!*---------------------------------------------------------------------*
!* LANGUAGE    FORTRAN 90                                              *
!*---------------------------------------------------------------------*
!* MACHINE     linux                                                   *
!*---------------------------------------------------------------------*
!* PURPOSE: Reads a temperature or precip field from the ASCII datasets*
!*      usually the NCDC 102 or 344 Division data                      *
!*---------------------------------------------------------------------*
!* FILES USED  FD or CD files are opened elsewhere and passed into the *
!*      routine.  see description of climate division ASCII datasets   *
!*---------------------------------------------------------------------*
!* SUBROUTINES USED: NONE                                              *
!*---------------------------------------------------------------------*
!* CALL ARGUMENTS:                                                     *
!*  INPUT VARIABLES  nu = unit number assigned to data file.           *
!*               ky = year requested, if negative grab the next record *
!*               km = Month number  1 JAN, 2 FEB 3=March 12=Dec ETC.   *
!*               kh = 1 FIRST 15 DAYS  2= REMAINDER, 3=FULL MONTH      *
!*               nvar  = 1 temperature, 2 for precipitation            *
!*  OUTPUT VARIABLES  kyymm = Year and month read in YYYYMM format     *
!*                This field contains a negative number for a bad call *
!*            jflag = data flag written on data 0 for ncdc final       *
!*                    1 for ncdc prelim, 2 for cpc prelim,             *
!*                    3= grid-based estimates, higher, rough estimates *
!*               x  = output data array. (Temps or Precip              *
!*---------------------------------------------------------------------*
!* AUTHOR:   UNGER, 2005                                               *
!*---------------------------------------------------------------------*
!* MODIFICATIONS                                                       *
!*---------------------------------------------------------------------*
      REAL, DIMENSION(ndsta) :: x
      nerr=0
      kyymm=ky*100+km
      khx=kh
      DO
        READ(nu,105,iostat=nerr)jy,jm,jh,jsta,jflag
        IF(nerr /=0) GO TO 800
 105    FORMAT(5I4)
        IF(nvar .EQ. 1) THEN
           READ(nu,106,iostat=nerr) x
        ELSE
           READ(nu,107,iostat=nerr) x
        ENDIF
  106   FORMAT(12F6.1)
  107   FORMAT(12F6.2)
        jyymm=jy*100+jm
!  If call asks for next record load test variable to return this one
!     note this used an old computed goto test branching to the 
!     first number if negative, second if zero, and third if positive
         IF(ky < 0) THEN
          kyymm=jyymm
	  khx=jh
         ENDIF
         kddate=kyymm-jyymm
         kdh=khx-jh
         IF( kddate == 0 .AND. kdh == 0) EXIT
         IF(kddate < 0) GO TO 820
      END DO
      RETURN
  800 print 801,nu,nerr,kyymm,ksta,jyymm
  801 format ('ERROR on file ', I4,'iostat= ', I4,'station data ',3i10)
      kyymm=-999
      RETURN
  820 print 821,nu,jyymm,kyymm
  821 format(' ERROR: date passed when looking for stations ',3i10)
       kyymm=-999
      RETURN
      END
           
