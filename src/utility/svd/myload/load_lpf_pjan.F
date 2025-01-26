      subroutine load(a,nd,iuin,iuout,iuw)
#include "parm.h"
      common/gridt/jslat(11),jelat(11),islon(23,11),ielon(23,11)
      common/gridh/js1,je1,js2,je2,nlon(7),ndlon(7),iadd(7)
      common/gridh/istart(7),iend(7)
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
      if(isst.eq.0) call atm(a,iuin,ireg,nd,iuout)
      if(isst.eq.1) call sst(a,iuin,ireg,nd,iuout)
      if(isst.eq.2) call land(a,iuin,ireg,nd,iuout,mbeg,mavg)
      print *,'in load: ireg=',ireg,' nd=',nd
      rewind iuout
      return
      end
      subroutine init
      common/gridt/jslat(11),jelat(11),islon(23,11),ielon(23,11)
      common/gridh/js1,je1,js2,je2,nlon(7),ndlon(7),iadd(7)
      common/gridh/istart(7),iend(7)
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
      subroutine atm(h,iunit,ireg,icount,iout)
#include "parm.h"
      dimension h(nmax,nmon,nyr),a(48,40),b(48,40)
      common/gridh/js1,je1,js2,je2,nlon(7),ndlon(7),iadd(7)
      common/gridh/istart(7),iend(7)
      character*8 name
      data izon/0/
      rewind iunit
      print *,'Call to ATM (LPF version for PJAN). '
      print *,'iu=',iunit,' region=',ireg,' nyr=',nyr,' nmon=',nmon
      nrec=0
c.... skip first and last 10 days 
      do iskip=1,10
        read(iunit) b
        write(*,'(''skip '',i3,e14.6)') iskip,b(1,1)
      enddo
      do 100 iyr=1,nyr
        do nm=1,nmon
          do j=1,40
            do i=1,48
              a(i,j)=0.
            enddo
          enddo
          read(iunit) a
          write(iout) a
          nrec=nrec+1
          icount=0
          ib=istart(ireg)
          ie=iend(ireg)
          if (ireg.ne.1) go to 85
          inc=0
          do 80 j=js1,je1,2
            if (inc.eq.0) inc=1
            if (inc.eq.1) inc=0
            do 80 i=1,24
              ii=(i-1)*2+ib+inc
              if(ii.lt.ib.or.ii.gt.ie) goto 80
              icount=icount+1
              h(icount,nm,iyr)=a(ii,j)
   80     continue
          go to 99
   85     jjj=0
          do 90 j=js2,je2,2
            jjj=jjj+1
            if (ireg.eq.2.or.ireg.ge.4) jj=j+20
            if (ireg.eq.3) jj=21-j
            inc=iadd(jjj)
            nln=nlon(jjj)
            ndl=ndlon(jjj)
            do 90 i=1,nln
              ii=(i-1)*ndl+ib+inc
              if(ii.lt.ib.or.ii.gt.ie) goto 90
              if(ireg.eq.4.and.(ii.lt.19.or.ii.gt.44)) goto 90
              icount=icount+1
              h(icount,nm,iyr)=a(ii,jj)
   90     continue
   99     continue
        enddo
  100 continue
      do iskip=1,10
        read(iunit) b
      enddo
      print *,'icount=',icount,' nmax=',nmax
      if(icount.gt.nmax) stop
      return
      end
      subroutine sst(t,iunit,jreg,icount,iout)
#include "parm.h"
      common/gridt/jslat(11),jelat(11),islon(23,11),ielon(23,11)
      dimension tocn(48,40),t(nmax,nmon,nyr),b(48,40)
      character*8 month
      character*8 name
      print *,'Call to SST (LPF version PJAN). iu=',iunit,' region=',
     * jreg
      rewind iunit
      nrec=0
      do iskip=1,10
        read(iunit) b
        write(*,'(''skip '',i3,e14.6)') iskip,b(1,1)
      enddo
      do 100 iyr=1,nyr
        do nm=1,nmon
          read(iunit) tocn
          write(iout) tocn
          if (jreg.eq.6.or.jreg.eq.9) go to 92
          if (jreg.eq.10.or.jreg.eq.11) go to 95
          nloop=1
          ireg=jreg
          go to 93
   92     nloop=2
          go to 93
   95     nloop=3
   93     icount=0
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
                t(icount,nm,iyr)=tocn(ii,j)
   70         continue
   80       continue
   94     continue
        enddo
  100 continue
      do iskip=1,10
        read(iunit) b
      enddo
      print *,'icount=',icount,' nmax=',nmax
      if(icount.gt.nmax) stop
      return
      end
      subroutine land(t,iunit,jreg,icount,iout,mbeg,mavg)
#include "parm.h"
      dimension tocn(48,40),t(nmax,nmon,nyr),b(48,40)
      integer iis(7,2),iie(7,2), jjs(2),jje(2)
      character*8 month
      character*8 name
      data iis/34,34,33,33,33,32,32,
     *         34,34,33,33,33, 0, 0/
      data iie/36,38,38,39,40,41,41,
     *         36,38,38,39,40, 0, 0/
      data jjs/27,27/, jje/33,31/
c
c.... mbeg= begin averaging with this month #
c.... mavg= average the total of this many months starting with mbeg
c.... jreg=1 for 25N-60N, NAmer. land pts.
c.... jreg=2 for 25N-50N, NAmer. land pts. only
c
      print *,'Call to LAND. iu=',iunit,' region=',jreg
c.... ONLY ONE REGION AT THIS TIME
      ravg=1./float(mavg)
      msk1=mavg+1
      mskip=mbeg-1
      numskp=0
c
      rewind iunit
      nrec=0
      if(mskip.gt.0) then
      do 20 iskip=1,mskip
        read(iunit) b
        nrec=nrec+1
        numskp=numskp+1
   20 continue
      endif
      do 100 iyr=1,nyr
        tocn=0.
        do 11 iread=1,mavg
          read(iunit) b
          nrec=nrec+1
          tocn=tocn+b*ravg
   11   continue
        do 12 iskip=msk1,12
          read(iunit,end=91) b
          nrec=nrec+1
          numskp=numskp+1
   12   continue
   91   continue
        icount=0
c...... north american land points only
        nj=0
        do j=jjs(jreg),jje(jreg)
          nj=nj+1
          if(iyr.eq.1)
     *    write(*,800) jreg,j,nj,iis(nj,jreg),iie(nj,jreg)
          do i=iis(nj,jreg),iie(nj,jreg)
            if(i.eq.38.and.j.eq.33) goto 95
            icount=icount+1
            t(icount,1,iyr)=tocn(i,j)
   95       continue
          enddo
        enddo
        write(iout) tocn
  100 continue
      write(*,'(''icount='',i6)') icount
  800 format('SVD for land region #',i1,' j=',i2,' nj=',i2,' i=',i2,'-'
     *    ,i2)
      return
      end
