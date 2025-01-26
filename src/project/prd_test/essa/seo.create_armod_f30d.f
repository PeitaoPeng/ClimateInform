      program create_armod

      implicit none

      integer nlead,nlag,order,lrec,t,r
      parameter(nlead=30) 
      integer lag,irec,mode,i,j,k,lead,ir
      real ipc1(15),ipc2(15),opc1(15),opc2(15),ipc3(15),ipc4(15)
      real temppc1(15),temppc2(15)
      real pc(45),fpc(2,30),sum, filler(15)
      real coeff(2,15) ! 15 order*2 modes
      real spc1,spc2
      character*54 idir
      character*50 odir

c     idir = "/export/lnx343/jgottschalck/CON_OPCP/code/"
c     odir = "/export/lnx343/jgottschalck/CON_OPCP/forecasts/"
      idir = "/gpfs/td2/cpc/noscrub/Qin.Zhang/MJOindex/realtime/tmp/"
      odir = "/gpfs/td2/cpc/noscrub/Qin.Zhang/MJOindex/forecast/"
      lrec=9999
      do t=1,15
       ipc1(t) = 0.0
      enddo
      do t=1,15
       ipc2(t) = 0.0
      enddo

c     open(10,file="./input_date",status='old')
c     read(10,*) lrec
c     print*, lrec

      open(11,file=idir//"pct20050101_REGRESS.data",
     &  access='direct',recl=4*4,status='old')
      open(12,file=odir//"arm/coeff_order10pc1_order15pc2.txt",
     &  status='old')
      
      open(20,file=odir//"arm/pct.daily.forecast.arm",
     &  status='unknown',access='direct',recl=2*4)
      
c        do lag=3,1,-1
c         read(11,rec=3-lag+1) temppc1(lag),filler(lag)
c        enddo
c        do lag=11,1,-1
c         read(11,rec=11-lag+1) filler(lag),temppc2(lag)
c       enddo

c      do lag=10,1,-1
c       read(11,rec=lrec-lag+1) ipc1(lag),filler(lag)
c      enddo
c      do lag=15,1,-1
c       read(11,rec=lrec-lag+1) filler(lag),ipc2(lag)
c      enddo

c     do lag=1,10,1
c       read(11,rec=lrec-lag+1) ipc1(lag),filler(lag)
c     enddo
      do lag=1,15,1
c      read(11,rec=lrec-lag+1) filler(lag),ipc2(lag)
       read(11,rec=lrec-lag+1) ipc1(lag),ipc2(lag),ipc3(lag),ipc4(lag)
      enddo
      
c      do t=1,15
c       tpc1=ipc1(t)
c       tpc2=ipc2(t)
c      enddo
c     call swap_1d(ipc1,10,opc1)
c     call swap_1d(ipc2,15,opc2)
      do t=1,15
c      temppc1(t) = -1.0*opc1(t)
c      temppc2(t) = -1.0*opc2(t)
       temppc1(t) = -1.0*ipc1(t)
       temppc2(t) = -1.0*ipc2(t)
c       print*, t, temppc1(t),temppc2(t)
       if (t.eq.1) then
         spc1 = temppc1(t)
         spc2 = temppc2(t)
       endif
      enddo
      
c       ---------------------------------------------
C       Read ARMOD coeff=fn(leadtime,target pc)
C       ----------------------------------------------

**** First PC uses an order of 10 so reads in 10 coefficients.
**** Second PC uses an order of 15 so reads in 15 coefficients.
        do mode=1,2
         if (mode .eq. 1) then
           read(12,*) (coeff(mode,order),order=1,10)
         else
           read(12,*) (coeff(mode,order),order=1,15)
         endif
        enddo

c        do mode=1,2
c          print*, (coeff(mode,order),order=1,15)
c        enddo
c        stop

       do mode=1,2
  
        if (mode .eq. 1) then 
          nlag=10
          do i=1,nlag
           r = nlag - i + 1
           pc(r) = temppc1(i)
c           pc(i) = temppc1(i)
c           print*, mode,i,r,temppc1(i),pc(r)
        enddo
      endif


c      do r=1,10
c        print*, mode,r,temppc1(r),pc(r)
c      enddo
c      stop

       
        if (mode .eq. 2) then
          nlag=15
          do i=1,nlag
            r = nlag - i + 1
            pc(r) = temppc2(i)           
c          pc(i) = temppc2(i)
         enddo
       endif


      do ir=nlag,nlag
       do lead=1,nlead
        sum = 0.0
         do i=1,nlag ! order for PC 
          sum = sum + coeff(mode,i)*pc(ir+lead-i)
         enddo
         pc(ir+lead) = -sum  
         fpc(mode,lead) = -sum
        enddo ! end lead loop
       enddo ! end current pentad loop (i.e., prediction performed once using most recent day)
 
      enddo ! end mode loop

       print*,'LEAD: 0', spc1,spc2
       write(20,rec=1) spc1,spc2
       do lead=1,nlead
         write(20,rec=lead+1) fpc(1,lead),fpc(2,lead)
        print*, 'LEAD:', lead, fpc(1,lead),fpc(2,lead)
       enddo

      end

      subroutine swap_1d(idata,id,data)
c     Byte swaps data -- Janowiak
c     Input arguments:
c     idata: I*4 array into which data are read in the calling pgm
c     ix: 1st dimension of idata & data arrays
c     iy: 2nd       "
c     data: byte-swapped data returned in this array

      integer*4 idata(id)
      real*4     data(id)
      character*1 c, ctmp(4)
      equivalence (itmp,ctmp)
      equivalence (jtmp,f)

      do j=1,id
        itmp=idata(j)
        c=ctmp(1)
        ctmp(1)=ctmp(4)
        ctmp(4)=c
        c=ctmp(2)
        ctmp(2)=ctmp(3)
        ctmp(3)=c

        jtmp=itmp

        data(j)=f
      enddo

      return
      end
      
