      subroutine load(a,nd,iuin,iuout)
#include "parm.h"
      common/gridt/jslat(11),jelat(11),islon(23,11),ielon(23,11)
      common/gridh/js1,je1,js2,je2,nlon(7),ndlon(7),iadd(7)
      common/gridh/istart(7),iend(7)
      real a(nmax,nmon,nyr)
      ierr=0
      call init
c
c call sst with xldata, unit 31 input and unit 41 output if left is sst
c call atm with xldata, unit 31 input and unit 41 output if left is z5
c call sst with rdata,  unit 32 input and unit 42 output if right is sst
c call atm with xldata, unit 32 input and unit 42 output if right is z5
c
      read(78,'(i2,1x,i2,1x,i2,1x,i1)') mbeg,mavg,ireg,isst
      print *,'monbeg=',mbeg,'  monavg=',mavg,' iregion=',ireg,
     * ' isst=',isst
      if(isst.eq.0) call atm(a,iuin,ireg,nd,iuout,mbeg,mavg)
      if(isst.eq.1) ierr=1
      if(isst.eq.2) ierr=1
      print *,'in load: ireg=',ireg,' nd=',nd
      rewind iuout
      if(ierr.eq.1) then
        print *,'code not modified to include these options.'
        stop
      endif
      return
      end
      subroutine init
      common/gridt/jslat(11),jelat(11),islon(23,11),ielon(23,11)
      common/gridh/js1,je1,js2,je2,nlon(7),ndlon(7),iadd(7)
      common/gridh/istart(7),iend(7)
      data jslat/15,26,12,25,12,25,12,12,12,12,12/
      data jelat/26,33,27,34,25,34,33,34,34,34,34/
c      data islon/21,22,23,22,21,22,21,22,21,18,17,16,17,16,19,18,
c     1            0,0,0,0,0,0,0,
c    1           16,19,18,19,20,19,20,21,24, 0, 0, 0, 0, 0, 0, 0,
c     1            0,0,0,0,0,0,0,
      data islon/22,21,22,21,22,21,18,17,16,17,16,19,18,
     1            0,0,0,0,0,0,0,0,0,0,
     1           19,18,19,20,19,20,21,24, 0, 0, 0, 0, 0, 0, 0,
     1            0,0,0,0,0,0,0,0,
     1           43,44,43,44,45,44,45,46,45,44,43,40,39,38,37,38,
     1            0,0,0,0,0,0,0,
     1           38,37,38,39,40,41,42,43,42,43, 0, 0, 0, 0, 0, 0,
     1            0,0,0,0,0,0,0,
     1            6, 5, 6, 9, 8, 7, 8, 7, 8, 7, 8, 7, 8, 9, 0, 0,
     1            0,0,0,0,0,0,0,
     1            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1           21,22,23,22,21,22,21,22,21,18,17,16,17,16,19,18,
     1           19,20,19,20,21,24,0,
     1           43,44,43,44,45,44,45,46,45,44,43,40,39,38,37,38,
     1           39,40,41,42,43,42,43,
     1            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0/
c      data ielon/39,38,39,38,39,38,37,38,37,38,37,36,35,34,33,32,
c     1            0,0,0,0,0,0,0,
c     1           34,33,32,33,32,31,32,31,30, 0, 0, 0, 0, 0, 0, 0,
c     1            0,0,0,0,0,0,0,
      data ielon/38,39,38,37,38,37,38,37,36,35,34,33,32,
     1            0,0,0,0,0,0,0,0,0,0,
     1           33,32,33,32,31,32,31,30, 0, 0, 0, 0, 0, 0, 0,
     1            0,0,0,0,0,0,0,0,
     1           51,50,51,50,49,50,49,50,49,50,47,46,45,46,45,46,
     1            0,0,0,0,0,0,0,
     1           46,45,46,47,46,47,48,47,48,49, 0, 0, 0, 0, 0, 0,
     1            0,0,0,0,0,0,0,
     1           18,15,16,15,16,17,16,17,14,15,14,13,12,13, 0, 0,
     1            0,0,0,0,0,0,0,
     1            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1           39,38,39,38,39,38,37,38,37,38,37,36,35,34,33,32,
     1           33,32,31,32,31,30, 0,
     1           51,50,51,50,49,50,49,50,49,50,47,46,45,46,45,46,
     1           47,46,47,48,47,48,49,
     1            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     1            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0/
      DATA istart/1,1,1,19,17,18,29/
      DATA iend/48,48,48,44,41,42,45/
      data js1/13/
      data js2/5/
      data je1/27/
      data je2/17/
      data nlon/24,24,24,24,12,12,12/
      data ndlon/2,2,2,2,4,4,4/
      data iadd/0,1,0,0,0,2,0/
      return
      end
      subroutine atm(h,iunit,ireg,icount,iout,mbeg,mavg)
#include "parm.h"
      parameter (id=48,jd=16)
      dimension h(nmax,nmon,nyr),a(id,jd),b(id,jd)
      integer mask(id,jd)
      common/gridh/js1,je1,js2,je2,nlon(7),ndlon(7),iadd(7)
      common/gridh/istart(7),iend(7)
      character*8 name
c Indicate southern hemisphere by setting "ireg" negative
c if data is for southern hemisphere from 20-90S then shem = .true.
      logical shem
      data izon/0/,shem/.false./
      rewind iunit
c
c mbeg= begin averaging with this month #
c mavg= average the total of this many months starting with mbeg
c
      print *,'Call to ATM for NMC 48x16 data iu=',iunit,' ireg=',ireg
      if(ireg.lt.0) then
        ireg=-ireg
        shem=.true.
      endif
      ravg=1./float(mavg)
      mask=0
c
      nrec=0
      do 100 iyr=1,nyr
      do 100 imo=1,nmon
        do 5 j=1,jd
          do 5 i=1,id
            a(i,j)=0.
    5   continue
        read(iunit) b
        nrec=nrec+1
        do 10 j=1,jd
          do 10 i=1,id
            a(i,j)=b(i,j)
   10   continue
        icount=0
        ib=istart(ireg)
        ie=iend(ireg)
        if(shem) then
         jb=16
         je=4
         jinc=-2
        else
         jb=1
         je=13
         jinc=2
        endif
        jj=0
        do 90 j=jb,je,jinc
          jj=jj+1
          inc=iadd(jj)
          nln=nlon(jj)
          ndl=ndlon(jj)
          do 90 i=1,nln
            ii=(i-1)*ndl+ib+inc
            if(ii.lt.ib.or.ii.gt.ie) goto 90
            if(ireg.eq.4.and.(ii.lt.19.or.ii.gt.44)) goto 90
            icount=icount+1
            h(icount,imo,iyr)=a(ii,j)
            mask(ii,j)=1000
   90   continue
   99   write(iout) a
  100 continue
      print *,'icount=',icount
      print *,'SHEM= ',shem
      write(*,'(''MASK. (*) indicates point used'')')
      write(*,'(i2,1x,48i1)') (j,(mask(i,j),i=1,id),j=jd,1,-1)
      return
      end
