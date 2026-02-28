MODULE ControlConstants
!************************************************************************
! MODULE ControlConstants                                               *
!      Initializes constants used in the makecd program set             *
!                                                                       *
!-----------------------------------------------------------------------*
!    VARIABLES                                                          *
!      ndcd  - number of NCDC climate divisions in the conus            *
!       ndm  - 12 months per year                                       *
!      ndfd  - number of CPC forecast divisions                         *
!      ndx,ndy - Faux grid for the 344 divisions, used in some stats.   *
!     rmiss    -  Internal program missing value indicator.             *
!     jprint   -  Printing control constant                             *
!************************************************************************
      INTEGER,PARAMETER :: ndcd=357,ncdcconus=344,ndm=12,ndfdconus=102, & 
       ndfd=114,ndx=21,ndy=17
      REAL :: rmiss
      INTEGER jprint,jyncdc1,jyak1
END MODULE ControlConstants
