      subroutine load(a,nd,iuin,iuout)
#include "parm.h"
      common/gridt/jslat(11),jelat(11),islon(23,11),ielon(23,11)
      common/gridh/js1,je1,js2,je2,nlon(7),ndlon(7),iadd(7)
      common/gridh/istart(5),iend(5)
      real a(nmax,nmon,nyr)
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
      if(isst.eq.1) call sst(a,iuin,ireg,nd,iuout,mbeg,mavg)
      if(isst.ne.1) call atm(a,iuin,ireg,nd,iuout,mbeg,mavg)
      rewind iuout
      return
      end
      subroutine init
      common/gridt/jslat(11),jelat(11),islon(23,11),ielon(23,11)
      common/gridh/js1,je1,js2,je2,nlon(7),ndlon(7),iadd(7)
      common/gridh/istart(5),iend(5)
      data jslat/15,26,12,25,12,25,12,12,12,12,12/
      data jelat/26,33,27,34,25,34,33,34,34,34,34/
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
      data js1/13/
      data js2/5/
      data je1/27/
      data je2/17/
      DATA istart/1,1,1,19,17/
      DATA iend/48,48,48,44,41/
      data nlon/24,24,24,24,12,12,12/
      data ndlon/2,2,2,2,4,4,4/
      data iadd/0,1,0,0,0,2,0/
      return
      end
      subroutine atm(h,iunit,ireg,icount,iout,mbeg,mavg)
#include "parm.h"
      dimension h(nmax,nmon,nyr),a(48,40),b(48,40)
      common/gridh/js1,je1,js2,je2,nlon(7),ndlon(7),iadd(7)
      common/gridh/istart(5),iend(5)
      character*8 name
      data izon/0/
      rewind iunit
c
c mbeg= begin averaging with this month #
c mavg= average the total of this many months starting with mbeg
c
      print *,'Call to ATM. iu=',iunit,' region=',ireg
      ierr=0
      nrec=0
      do 100 iyr=1,nyr
      read(iunit) a
      nrec=nrec+1
      if (izon.ne.0) then
        do 15 j=1,40
        zon=0.
        do 16 i=1,48
        zon=zon+a(i,j)/48.
   16   continue
        do 17 i=1,48
        a(i,j)=a(i,j)-zon
   17   continue
   15   continue
      endif
c
    1 icount=0
      ib=istart(ireg)
      ie=iend(ireg)
      if (ireg.ne.1) go to 10
      inc=0
      do 80 j=js1,je1,2
      if (inc.eq.0) inc=1
      if (inc.eq.1) inc=0
      do 80 i=1,24
      ii=(i-1)*2+ib+inc
      if(ii.lt.ib.or.ii.gt.ie) goto 80
      icount=icount+1
      if(icount.gt.nmax) then
        ierr=1
        goto 80
      endif
      h(icount,1,iyr)=a(ii,j)
   80 continue
      go to 99
c
   10 jjj=0
      do 60 j=js2,je2,2
      jjj=jjj+1
      if (ireg.eq.2.or.ireg.eq.4.or.ireg.eq.5) jj=j+20
      if (ireg.eq.3) jj=21-j
      inc=iadd(jjj)
      nln=nlon(jjj)
      ndl=ndlon(jjj)
      do 60 i=1,nln
      ii=(i-1)*ndl+ib+inc
      if(ii.lt.ib.or.ii.gt.ie) goto 60
      if(ireg.eq.4.and.(ii.lt.19.or.ii.gt.44)) goto 60
      icount=icount+1
      if(icount.gt.nmax) then
        ierr=1
        goto 60
      endif
      h(icount,1,iyr)=a(ii,jj)
   60 continue
   99 if(ierr.eq.1) then
        print *,'ERROR. nmax < ICOUNT which =',icount
        print *,'RESET nmax=',icount
        stop
      endif
      write(iout) a
  100 continue
      return
      end
      subroutine sst(t,iunit,jreg,icount,iout,mbeg,mavg)
#include "parm.h"
      common/gridt/jslat(11),jelat(11),islon(23,11),ielon(23,11)
      dimension tocn(48,40),t(nmax,nmon,nyr),b(48,40)
      character*8 month
      character*8 name
c
c mbeg= begin averaging with this month #
c mavg= average the total of this many months starting with mbeg
c
      print *,'Call to SST. iu=',iunit,' region=',jreg
      rewind iunit
      do 100 iyr=1,nyr
      read(iunit) tocn
      nrec=nrec+1
      if (jreg.eq.6.or.jreg.eq.9) go to 92
      if (jreg.eq.10.or.jreg.eq.11) go to 95
      nloop=1
      ireg=jreg
      go to 93
   92 nloop=2
      go to 93
   95 nloop=3
   93 icount=0
      do 94 iloop=1,nloop
      if (jreg.eq.6.and.iloop.eq.1) ireg=2
      if (jreg.eq.6.and.iloop.eq.2) ireg=4
      if (jreg.eq.9.and.iloop.eq.1) ireg=7
      if (jreg.eq.9.and.iloop.eq.2) ireg=8
      if (jreg.eq.10.and.iloop.eq.1) ireg=5
      if (jreg.eq.10.and.iloop.eq.2) ireg=7
      if (jreg.eq.10.and.iloop.eq.3) ireg=8
      if (jreg.eq.11.and.iloop.eq.1) ireg=2
      if (jreg.eq.11.and.iloop.eq.2) ireg=8
      if (jreg.eq.11.and.iloop.eq.3) ireg=5
      js=jslat(ireg)
      je=jelat(ireg)
      jj=0
      do 80 j=js,je
      jj=jj+1
      is=islon(jj,ireg)
      ie=ielon(jj,ireg)
      do 70 i=is,ie,2
      if (ireg.eq.5.and.i.eq.11.and.j.eq.25) go to 70
      if (ireg.eq.10.and.i.eq.11.and.j.eq.25) go to 70
      icount=icount+1
      if (i.gt.48) ii=i-48
      if (i.le.48) ii=i
      t(icount,1,iyr)=tocn(ii,j)
   70 continue
   80 continue
   94 continue
      write(iout) tocn
  100 continue
      return
      end
