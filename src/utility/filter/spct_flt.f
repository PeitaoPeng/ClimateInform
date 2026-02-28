      program filter
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C===========================================================
      PARAMETER (ltime=100)
      PARAMETER (nwf=2*ltime+15)
      real coef(ltime),wsave(nwf)
      real fin(ltime),fout(ltime)

C--------+---------+---------+---------+---------+---------+---------+---------+
c     open(unit=10,form='unformated',access='direct',recl=imax*jmax)
c     open(unit=20,form='unformated',access='direct',recl=imax*jmax)
c
      pi=3.14159
      nf=20
      iwrite=0
      write(6,*) 'start'

      do 2000 mod=1,1
      call getcos(coef,ltime)
      write(6,*) 'read coef'
      do n=1,ltime
      fin(n)=coef(n)
      end do
c     write(6,999) coef
 999  format(1x,10f7.3)
      call FILTERHP(ltime,fin,fout,nf,wsave)
      write(6,999) wsave
      write(6,999) fin

 2000 continue
      
      stop
      END


      SUBROUTINE getcos(coef,n)
      DIMENSION coef(*)
      pi=3.14159
      p1=5
      p2=20
        do it=1,n
         coef(it)=cos(2*pi*it/p1)+cos(2*pi*it/p2)
        enddo
      return
      end

      SUBROUTINE anom(fld,n)
      DIMENSION fld(*)
      avg=0
      do i=1,n
         avg=avg+fld(i)/float(n)
      enddo
      do i=1,n
         fld(i)=fld(i)-avg
      enddo
      return
      end

