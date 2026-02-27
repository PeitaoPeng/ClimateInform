      subroutine eemd(LXY,data,An,Nesb,Nm,rslt,idum,Nsifting)
c
c  LXY: length of input data
c  data: input data
c  An: amplitude of added noise
c  Nesb: number of ensemble members
c  Nm: number of mode in each decomposition
c  rslt: output data
c  idum: seed for the random number
c  Nsifting: sifting number for EMD, usually set to 10
c
      dimension data(LXY)      ! data
      dimension ximf(LXY)
      dimension spmax(LXY)    ! upper envelope, cubic spline
      dimension spmin(LXY)    ! lower envelope, cubic spline
      dimension ave(LXY)    ! the average of spmax and spmin
      dimension remp(LXY)   ! the input data to obtain IMF
      dimension rem(LXY)    ! (remp-ximf) the remainder
c
      dimension rslt(LXY,Nm+2) ! original, modes, residual
      dimension allmode(LXY,Nm+2) ! original, modes, residual
c
      integer nmax, nmin


c  initialize the output
      do j=1,Nm+2
        do i=1,LXY
          rslt(i,j)=0.0
        enddo
      enddo

c
c  ensemble EMD
c
c  -------------------------------------------------------
      do IE=1,Nesb
c  -------------------------------------------------------
        if(mod(IE,10).eq.0) WRITE(*,*) "IE= ", IE
c       inputted data + noise
        if(Nesb.eq.1) then
          do i=1,LXY
            ximf(i)=data(i)
          enddo
        else
          do i=1,LXY
            ximf(i)=data(i)+An*gasdev(idum)
          enddo
        endif
c
c
c  save modified data
        do i=1,LXY
          allmode(i,1)=ximf(i)
        enddo
c
c
c  calculate modes
c       =======================================================
        do im=1,Nm
c       =======================================================
c
c  leave a copy of the input data before IMF is calculated
          do i=1,LXY
            remp(i)=ximf(i)
          enddo

c
c  Sifting
c         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          do ii=1,Nsifting
c         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            if(mod(ii,1000).eq.0 .and. im.eq.1) then
c             write(*,*) 'sifting_num= ',ii
            endif

            call min_max(LXY,ximf,spmax,spmin,nmax,nmin)
            call splint(spmax,LXY,nmax)
            call splint(spmin,LXY,nmin)

            do i=1,LXY
              ave(i)=(spmax(i)+spmin(i))/2.0
              ximf(i)=ximf(i)-ave(i)
            enddo
c         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          enddo
c         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     
c
          do i=1,LXY
            rem(i)=remp(i)-ximf(i)
          enddo
c
          do i=1,LXY
            allmode(i,im+1)=ximf(i)
          enddo
c
          do i=1,LXY
             ximf(i)=rem(i)
          enddo
c
c       =======================================================
        enddo
c       =======================================================
c
        do i=1,LXY
          allmode(i,Nm+2)=ximf(i)
        enddo
c
        do j=1,Nm+2
          do i=1,LXY
            rslt(i,j)=rslt(i,j)+allmode(i,j)
          enddo
        enddo
c
c     ---------------------------------------------------------
      enddo
c     ---------------------------------------------------------
c
      fNesb=float(Nesb)
      do j=1,Nm+2
        do i=1,LXY
          rslt(i,j)=rslt(i,j)/fNesb
        enddo
      enddo
c
      return
      end
