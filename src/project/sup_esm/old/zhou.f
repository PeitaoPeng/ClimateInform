From - Tue Nov  7 07:21:32 2000
Return-Path: <szhou@orbit15i.nesdis.noaa.gov>
Received: from mx.ncep.noaa.gov (mx.wwb.noaa.gov [140.90.193.27])
	by poppy1.ncep.noaa.gov (8.8.8/8.8.8) with ESMTP id QAA09755
	for <ppeng@poppy1.ncep.noaa.gov>; Thu, 28 Sep 2000 16:25:48 -0400 (EDT)
Received: from orbit15i.nesdis.noaa.gov (orbit15i.wwb.noaa.gov [140.90.197.136])
	by mx.ncep.noaa.gov (8.8.8/8.8.8) with SMTP id QAA10867
	for <ppeng@ncep.noaa.gov>; Thu, 28 Sep 2000 16:25:47 -0400
Received: (from szhou@localhost) by orbit15i.nesdis.noaa.gov (950413.SGI.8.6.12/950213.SGI.AUTOCF) id QAA03618 for ppeng@ncep.noaa.gov; Thu, 28 Sep 2000 16:25:47 -0400
Date: Thu, 28 Sep 2000 16:25:47 -0400
From: szhou@orbit15i.nesdis.noaa.gov (Sisong Zhou)
Message-Id: <200009282025.QAA03618@orbit15i.nesdis.noaa.gov>
To: ppeng@ncep.noaa.gov
Reply-To: szhou@nesdis.noaa.gov

C==============================================================================
C==============================================================================
C    ORGANIZATION:   NOAA/NESDIS
C
C    PROJECT:        AIRS Core Algorithm Development
C
C    SUBSYSTEM:      NASRS (NOAA Advanced Sounder Retrieval System)
C                    - One of the programs for local angle adjustment
C
C    REMARK:      1. Local angle corection based on AIRS radiance instead 
C                    of brightness temperatures                  05/05/99
C                 2. btairs & btairx here is in radiance unit    05/05/99
C
!F77==========================================================================

!ROUTINE NAME:   pccoefgn
!ROUTINE TYPE:   main

!ABSTRACT:    Read in the xave & the eigenvectors calculated by eignairs.f
C             and the simulated AIRS radiances, and then calculate the
C             regression coefficients for local angle adjustments to AIRS
C             measured radiances at each AIRS view angle

!INPUT PARAMETERS:

C  type     name               content
C  ------------------------------------------------------------------------
C  real    fr         AIRS channels' frequecy
C  real    btairs     simulated AIRS radiances (in radiance unit)
C  real    btairx     simulated_normalized AIRS radiances (in radiance unit)
C  real    xave       mean of radiances for each AIRS channel at a
C                     specific view angle
C  real*8  Z          eigenvectors for a specific AIRS view angle
C  integer nchan      number of AIRS channels
C  integer nview      half number of AIRS view angles ( =45 )
C  integer nprofl     number of profiles used in AIRS simulation
C                     (maximum of nprofl = 600)
C  integer numpc      number of principal components

!OUTPUT PARAMETERS:

C  type    name            content
C  -----------------------------------------------------------------------
C  real   cc         regression coefficients for local angle  adjustments
C                     to AIRS measured raddiances at a specific view angle

!FILES ACCESSED: freqairs.dat                 !AIRS channels' frequencies
C                airsbt.noicld.rfnew.evn.dat  !simul. for day & night time
C                covmtrai.dax                 !input - xave
C                eigenvai.dax                 !input - eigenvectors
C                cfairs45.dax                 !output- coefficients

!SUBROUTINES CALLED: mul_regression  mtrx_inv

!FUNCTION CALLED:    brtemp

!ROUTINE HISTORY:

C        Date        Programmer        Comments
C   --------------------------------------------------------------------
C     02/19/98       Sisong Zhou       Generated
c     07/13/98       Sisong Zhou       Rerun for newly simulated data
c                                      which were affected by solar
c                                      zenith angles

!END  ==================================================================

      program pccoefgn
C========================================================================
c
      implicit none

      integer  nchan,ncgood,nview,npairs,nprofl,mprofl,isampl
      parameter(nchan=2378,ncgood=1547,nview=45,npairs=30,mprofl=600)
c
      integer  ic, icgood, ipc, imod, ivi, iview, iprofl
      real     radin(nchan)
      real     btairs(nchan,mprofl,3)
      real     btairx(nchan,mprofl),btairy(nchan,mprofl)
      real     rdairs(nchan,mprofl,3),rdairx(ncgood,mprofl)
      real     fr(nchan), NEDN_airs(nchan)
      real     brtemp          ! function
c
      integer i,ii,iv,j,k,numpc,numpx,ierr,ipair,ngroup,iselec(30)
      parameter( numpc=45,numpx=46 )
      integer  cstate(nchan),ncused,ncpick
c
      real*8  Z(ncgood,ncgood),Zin(ncgood)
      real    xave(ncgood),btsy(ncgood)

      real    sum,pc(numpc),mean(nchan)
      real    vv(nchan,mprofl),rr(numpx,mprofl),cc(nchan,numpx)
      real    pi,zsolar(nview,mprofl),solain(nview),cossun(mprofl)
c
      character*80 inputfi1,inputfi2,inputfi3,outputfi
c
c get input & output file names
c
      call getarg(1,inputfi1)
      write(6,1011) inputfi1
      call getarg(2,inputfi2)
      write(6,1012) inputfi2
      call getarg(3,inputfi3)
      write(6,1013) inputfi3
      call getarg(4,outputfi)
      write(6,1014) outputfi
 1011 format(1x,'input  file # 1 = ',A)
 1012 format(1x,'input  file # 2 = ',A)
 1013 format(1x,'input  file # 3 = ',A)
 1014 format(1x,'output file     = ',A)
c
c open input files
c
      open(87,file='AIRS.channels.beused.dat',form='formatted')
      open(88,file='Noise.airs.NeDr.v1.5.2',form='formatted')
      open(98,file='solar.zenith.45.600.day.odd.dat',form='formatted')
      open(90,file=inputfi1, form='formatted')
      open(67,file=inputfi2, form='formatted')
      open(68,file=inputfi3, form='formatted')
c
c open output files
c
      open(71, file=outputfi, form='formatted')
c
      save
c
      data iselec/ 1, 3, 4, 6, 7, 9,10,12,13,15,
     1            16,18,19,21,22,24,25,27,28,30,
     2            31,33,34,36,37,39,40,42,43,45/
c
c---------------------------------------------
c  total # of profiles used in each data file
c---------------------------------------------
c
      pi = 3.1415926
c
      read(5,*) nprofl
      write(6,1200) nprofl
 1200 format(/1x,'# of profiles for which AIRS rad. simulated=',i4)

c---------------------------------
c  read channel status into buffer
c---------------------------------
      ncpick = 0
      do ic=1,nchan
         read(87,2221) i,cstate(ic)
         write(6,2221) i,cstate(ic)
 2221 format(1x,2i5)
         if(cstate(ic).eq.0) then
            ncpick = ncpick + 1
         endif
      end do
      write(6,fmt="(/1x,'good channels picked up=',i4)") ncpick
c
c---------------------------------------
c read AIRS standard noise into buffer
c---------------------------------------
      read(88,2225) (NEDN_airs(ic),ic=1,nchan)
 2225 format(1x,5e15.7)
      write(6,fmt="(/1x,'AIRS noise standard deviation:',/)")
      write(6,2225) (NEDN_airs(ic),ic=1,nchan)

c------------------------------------------
c  read solar zenith angle data into buffer
c------------------------------------------

      do i=1,nprofl
         read(98,4501) (solain(k),k=1,nview)
 4501 format(1x,10f8.2)
         do k=1,nview
            zsolar(k,i) = solain(k)
         end do
      end do
      write(6,fmt="(/1x,'solar zenith data been read to buffer')")

c   ----------------------
c   loop over view angles
c   ----------------------

      do 100 ngroup=1,15
         write(6,fmt="(/1x,'ngroup = ',i3)") ngroup
         ivi = (ngroup-1) * 3
         write(6,fmt="(/1x,'ivi = ',i3)") ivi

c  read AIRS radiances into buffer for 3 view angles

         do iv=1,3
            do iprofl=1,nprofl
               read(90,1001) (radin(ic),ic=1,nchan)
 1001 format(1x,8f12.6)
               do ic =1, nchan
                  btairs(ic,iprofl,iv) = radin(ic)
                  rdairs(ic,iprofl,iv) = radin(ic)/NEDN_airs(ic)
               end do
            end do
         end do

c---------------------------------------------------------------------
c         if(ngroup.ne.15) goto 100  !test for view angle 44 & 45 only
c---------------------------------------------------------------------
    
         do 200 iv=1, 3, 2
            iview = ivi + iv
            write(6,fmt="(/1x,'iview = ',i3)") iview

c----------------------
c  prepare predictants
c----------------------

            if(iv.eq.1) then
               do i=1,nprofl
                  do j=1,nchan
                     btairx(j,i) = btairs(j,i,1)
                     btairy(j,i) = btairs(j,i,2)
                  end do
               end do
            else
               do i=1,nprofl
                  do j=1,nchan
                     btairx(j,i) = btairs(j,i,3)
                     btairy(j,i) = btairs(j,i,2)
                  end do
               end do
            endif

c---------------------------------
c  pick up data for good channels
c---------------------------------

         do iprofl =1, nprofl
            ncused=0
            do ic=1,nchan
               icgood = cstate(ic)
               if(icgood.eq.0) then
                  ncused = ncused + 1
                  rdairx(ncused,iprofl)=rdairs(ic,iprofl,iv)
               endif
            end do
         end do
         write(6,fmt="(/1x,'ncused = ',i4)") ncused

c-----------------------------
c  cosine(solar zenith angle)
c-----------------------------

         if(iv.eq.1) then
            do i=1,nprofl
               cossun(i) = COS(pi*zsolar(iview,i)/180.0) -
     &                     COS(pi*zsolar(iview+1,i)/180.0)
            end do
         else
            do i=1,nprofl
               cossun(i) = COS(pi*zsolar(iview,i)/180.0) -
     &                     COS(pi*zsolar(iview-1,i)/180.0)
            end do
         endif

c----------------------------------------
c  calculate regression coefficients for
c  local angle adjustment for each pair
c-----------------------------------------

c------------------------
c  read xave into buffer
c------------------------
c
            read(67,1002) (xave(k),k=1,ncgood)
 1002 format(1x,8f10.5)

c            write(6,1003)
 1003 format(//1x,' xave for AIRS 2378 channels:' )
c            write(6,1002) (xave(k),k=1,ncgood)
c
C--------------------------------------------------
C  read Z matrix into buffer ( using Z(ncgood,100) )
c--------------------------------------------------
c
            do i=1,100
               read(68,1005) (Zin(k),k=1,ncgood)
 1005 format(1x,8f12.7)
               do k=1,ncgood
                  Z(k,i) = Zin(k)
               end do
            end do
            write(6,fmt="(/1x,'eigenvectors read to buffer')")

c-----------------------------------------
c  prepare predictants & PCs for each pair
c-----------------------------------------

c------------------------
c  creating  predictants
c------------------------

            do iprofl =1, nprofl
               do ic=1,nchan
                  vv(ic,iprofl) = btairx(ic,iprofl) -
     $                            btairy(ic,iprofl)
               end do
            end do

c--------------------------------------------------------
c  computing principal components (the predictors) 
c  -- numpc=45 means 45 PCs will be used in calculation
c--------------------------------------------------------

            do iprofl=1,nprofl
               do ic=1,ncgood
                  btsy(ic)=rdairx(ic,iprofl)-xave(ic)
               end do
               do ii = 1, numpc
                  sum = 0.0
                  do ic =1, ncgood
                     sum = sum + btsy(ic) *  Z(ic, ii)
                  end do
                  pc(ii) = sum
               end do
               do ii = 1,numpc
                  rr(ii,iprofl) = pc(ii)
               end do
            end do

c---------------------------------------------------------
c  plus solar zenith angle as the 46th predictor
c
            do iprofl=1,nprofl
               rr(numpc+1,iprofl) = cossun(iprofl)
            end do

c--------------------------------------------------------------
c  call subroutine mul_regression( V,R,C,mean,nchan,nsamp,npc )
c  to compute regression coefficients for each pair
C---------------------------------------------------------------
C      Perform the matrix calculations involved in solving a general
C      least squares regression.  The Equation is as follows:
C
C      (1)   V = C * R
C
C      where V has dimensions of [nchannel x nprofle] and contains the
C      the predictants;  R has dimensions of [numpc_use x nprofle]
C      and contains the principal componenets calculated from the
C      training sample;  C is the coefficient matrix to be solved for
C      and has dimensions [nchannel x numpc_use].
C
C      The solution for C from equation (1) is:
C
C      (2)   C = V * Rt * [R * Rt](inv)
C
C      [X](inv) indicates the inverse of matrix X
C      Xt indicates the transpose of matrix X
C ----------------------------------------------------------------------
c
            call mul_regression(vv,rr,cc,mean,nchan,nprofl,numpx )
c
c----------------------------------------------------
c  write mean(nchan) & cc(nchan,numpc) into file # 71
c----------------------------------------------------
c
            write(71,1007) (mean(ic),ic=1,nchan)
 1007 format(1x,8e15.7)
c
            do ic=1,nchan
               write(71,1007) (cc(ic,ipc),ipc=1,numpx)
            end do
c
  200 continue
  100 continue
      write(6,1009)
 1009 format(/1x,'*** end of regression coefficient computation')
      stop
      end
c
C==============================================================================
C
C    ORGANIZATION:   NOAA/NESDIS 
C
C    PROJECT:        AIRS Core Algorithm Development 
C
C    SUBSYSTEM:      NASRS (NOAA Advanced Sounder Retrieval System)
C
!F77==========================================================================


!ROUTINE NAME:   mul_regression.f

!ABSTRACT:   Subroutine to calculate the coefficients by using the 
C            least square method.


!CALL PROTOCOL:



!INPUT PARAMETERS:

C    type       name           purpose            units
C    ------------------------------------------------------------------


!OUTPUT PARAMETERS:

C    type       name           purpose            units
C    ------------------------------------------------------------------


!INPUT/OUTPUT PARAMETERS:

C    type       name           purpose            units
C    ------------------------------------------------------------------

!RETURN VALUES:


!PARENT(S):  get_regression_coeff.f



!ROUTINES CALLED:  
C                  mtrx_inv



!FILES ACCESSED:
   
!ROUTINE HISTORY:

C        Date        Programmer        Comments
C   --------------------------------------------------------------------
C        05/10/95    Hanjun Ding     First Version 


!END  ==================================================================


C       ================================================================
        subroutine mul_regression( V, R, C, mean, nchan, nsamp, npc )
C       ================================================================
C-----------------------------------------------------------------------
C      Perform the matrix calculations involved in solving a general 
C      least squares regression.  The Equation is as follows:
C 
C      (1)   V = C * R
C
C      where V has dimensions of [nchannel x nprofle] and contains the
C      the predictants;  R has dimensions of [numpc_use x nprofle]
C      and contains the principal componenets calculated from the 
C      training sample;  C is the coefficient matrix to be solved for 
C      and has dimensions [nchannel x numpc_use].
C
C      The solution for C from equation (1) is:
C
C      (2)   C = V * Rt * [R * Rt](inv)
C
C      [X](inv) indicates the inverse of matrix X
C      Xt indicates the transpose of matrix X
C-----------------------------------------------------------------------        


	implicit none

C-----------------------------------------------------------------------
C                             INCLUDE FILES
C-----------------------------------------------------------------------
c
c #include "reg_parm"
        integer max_nchan
        parameter(max_nchan = 2378) !MAXIMUM # OF ALLOWED REGRESSION CHANNELS

        integer max_nsamp
        parameter(max_nsamp = 600) ! MAXIMUM TRAINING SAMPLE SIZE OR THE MAXIMUM #
                                    ! OF OBSERVATIONS TO WHICH COEFFICENTS ARE APPLIED

        integer max_npc
        parameter(max_npc =46) ! maximum # of principal components
c
C-----------------------------------------------------------------------
C                              ARGUMENTS
C-----------------------------------------------------------------------

	integer		nchan, nsamp, npc
	real		V(nchan,nsamp)
	real		R(npc, nsamp)
	real		C(nchan,npc)
	real		mean(nchan)

C-----------------------------------------------------------------------
C                            LOCAL VARIABLES
C-----------------------------------------------------------------------

        integer        icol
        integer        irow
        integer        jj

	real*8		RRT(max_npc,max_npc)
	real*8		RRTinv(max_npc,max_npc)
	real*8		VRT(max_nchan,max_npc)
	real*8 		sum

C-----------------------------------------------------------------------
c     Subtract training mean from V
C-----------------------------------------------------------------------

      do irow = 1, nchan
	mean(irow) = 0.0
	do icol = 1, nsamp
		mean(irow) = mean(irow) + V(irow,icol)
	enddo
	mean(irow) = mean(irow)/nsamp
      enddo


      do irow = 1, nchan
	do icol = 1, nsamp
		V(irow,icol) = V(irow,icol) - mean(irow)
	enddo
      enddo


C-----------------------------------------------------------------------
C     Calculate the matrix product R*RT
C-----------------------------------------------------------------------

      do irow = 1, npc

         do icol = 1, npc

                RRT( irow, icol ) = 0.0

           do jj = 1, nsamp

                RRT( irow, icol ) = RRT( irow, icol ) + 
     $                    R( irow, jj ) * R( icol, jj )

           enddo

         enddo
	
	enddo


C-----------------------------------------------------------------------
c     Calculate the inverse of the matrix RRt = [RRt](inv) 
C-----------------------------------------------------------------------

             call mtrx_inv ( RRT, RRTinv, npc )

C-----------------------------------------------------------------------
c     Calculate V * Rt
C-----------------------------------------------------------------------


      do irow = 1, nchan

         do icol = 1, npc

             VRT(irow,icol)= 0.0

           do jj = 1, nsamp

             VRT( irow, icol )= VRT( irow, icol ) + 
     $                  V( irow, jj ) * R( icol, jj )

           enddo

         enddo

      enddo


C-----------------------------------------------------------------------
c     Calculate VRt * [RRt](inv) = Coefficient Matrix
C-----------------------------------------------------------------------


      do irow = 1, nchan

         do icol = 1, npc

             sum = 0.0

           do jj = 1, npc

             sum = sum + VRT( irow, jj ) * RRTinv( jj, icol )

           enddo
             C( irow, icol ) = sngl(sum)
         enddo

      enddo

      return
      end

C==============================================================================
C==============================================================================
C
C    ORGANIZATION:   NOAA/NESDIS 
C
C    PROJECT:        AIRS Core Algorithm Development 
C
C    SUBSYSTEM:      NASRS (NOAA Advanced Sounder Retrieval System)
C
!F77==========================================================================


!ROUTINE NAME:   mtrx_inv.f

!ABSTRACT:   Calculates the inverse of a double precision symmetric 
C            matrix. 


!CALL PROTOCOL:

C          mtrx_inv( x, xinv, n )



!INPUT PARAMETERS:

C    type       name           purpose            units
C    ------------------------------------------------------------------
C    real*8     x              matrix to be inverted
C    integer    n              dimension of x

!OUTPUT PARAMETERS:

C    type       name           purpose            units
C    ------------------------------------------------------------------
C    real*8     xinv           inverted matrix 

!INPUT/OUTPUT PARAMETERS:

C    type       name           purpose            units
C    ------------------------------------------------------------------


!RETURN VALUES:

C   [Include the values of the return status from this routine.]


!PARENT(S):  General Purpose



!ROUTINES CALLED:  None 



!FILES ACCESSED: None


!COMMON BLOCKS:  None



!DESCRIPTION:

C   [This section should describe the state of the program and
C    arguments on entry (including any assumptions about previous
C    processing, file positioning, and so on) and on return.  Exception
C    handling, return values and limitations should also be discussed.]

!ALGORITHM REFERENCES:

C      The method is described in J. H. Wilkinson and C. Reinsch,
c       'Handbook for Automatic Compuation, Vol. II - Linear Algebra',
c        Springer-Verlag, under 'Symmetric Decomposition of a Positive
c        Definite Matrix', p. 9.


!KNOWN BUGS AND LIMITATIONS:

C   [Include all the possible limitations or bugs that are currently
C    associated with this code.]


!ROUTINE HISTORY:

C        Date        Programmer        Comments
C   --------------------------------------------------------------------
C        03/22/84    Mitch Goldberg    


!END  ==================================================================



C       ================================================================
        subroutine  mtrx_inv( x, xinv, n )
C       ================================================================

        implicit none

C-----------------------------------------------------------------------
C                             INCLUDE FILES
C-----------------------------------------------------------------------
c
c #include  "reg_parm"
        integer max_nchan
        parameter(max_nchan = 2378) !MAXIMUM # OF ALLOWED REGRESSION CHANNELS

        integer max_nsamp
        parameter(max_nsamp = 600) ! MAXIMUM TRAINING SAMPLE SIZE OR THE MAXIMUM #
                                    ! OF OBSERVATIONS TO WHICH COEFFICENTS ARE APPLIED

        integer max_npc
        parameter(max_npc =46) ! maximum # of principal components
c
C-----------------------------------------------------------------------
C                              ARGUMENTS
C-----------------------------------------------------------------------

        real*8    x ( max_npc, max_npc )
        real*8    xinv ( max_npc, max_npc )
        integer   n

C-----------------------------------------------------------------------
C                            LOCAL VARIABLES
C-----------------------------------------------------------------------

        integer   i
        integer   ii
        integer   im
        integer   ip
        integer   j
        integer   jm
        integer   jp
        integer   k
        integer   l
        integer   nm
        real*8    s ( max_npc, max_npc )
        real*8    a ( max_npc, max_npc )
        real*8    sum

C***********************************************************************
C***********************************************************************
C                            EXECUTABLE CODE
C***********************************************************************
C***********************************************************************

C-----------------------------------------------------------------------
C     [ Major comment blocks set off by rows of dashes. ]
C-----------------------------------------------------------------------

C
C    CONVERT 'X' TO A DOUBLE PRECISION WORK ARRAY.
      do 10 i=1,n
      do 10 j=1,n
cx      a(i,j)=dble(x(i,j))
      a(i,j)=x(i,j)
   10 continue
      s(1,1)=1.0/a(1,1)
c    just inverting a scalar if n=1.
      if(n-1)20,180,30
   20 return
   30 do 40 j=2,n
      s(1,j)=a(1,j)
   40 continue
      do 70 i=2,n
      im=i-1
      do 60 j=i,n
      sum=0.0
      do 50 l=1,im
      sum=sum+s(l,i)*s(l,j)*s(l,l)
   50 continue
      s(i,j)=a(i,j)-sum
   60 continue
      s(i,i)=1.0/s(i,i)
   70 continue
      do 80 i=2,n
      im=i-1
      do 80 j=1,im
   80 s(i,j)=0.0
      nm=n-1
      do 90 ii=1,nm
      im=n-ii
      i=im+1
      do 90 j=1,im
      sum=s(j,i)*s(j,j)
      do 90 k=i,n
      s(k,j)=s(k,j)-s(k,i)*sum
   90 continue
      do 120 j=2,n
      jm=j-1
      jp=j+1
      do 120 i=1,jm
      s(i,j)=s(j,i)
      if(jp-n)100,100,120
  100 do 110 k=jp,n
      s(i,j)=s(i,j)+s(k,i)*s(k,j)/s(k,k)
  110 continue
  120 continue
      do 160 i=1,n
      ip=i+1
      sum=s(i,i)
      if(ip-n)130,130,150
  130 do 140 k=ip,n
      sum=sum+s(k,i)*s(k,i)/s(k,k)
  140 continue
  150 s(i,i)=sum
  160 continue
      do 170 i=1,n
      do 170 j=i,n
      s(j,i)=s(i,j)
  170 continue
c    retrieve output array 'xinv' from the double precession work array.
  180 do 190 i=1,n
      do 190 j=1,n
cx      xinv(i,j)=sngl(s(i,j))
      xinv(i,j)=s(i,j)
  190 continue
      return
      end
-----------------------------------------
Sisong Zhou NOAA/NESDIS/ORA
Room 711H, World Weather Building (WWB) 
5200 Auth Road                         
Camp Springs, MD 20746
szhou@nesdis.noaa.gov
Phone: 301-763-8346
----------------------------------------
