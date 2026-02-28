      program MLR_correction
      include "parm.h"
      dimension on34(nt),fn34(nt)
      dimension xin(nfld)
      dimension wk(ngrd,nt),fcv(ngrd,nt-1),ocv(nt-1)
      dimension wt(ngrd),wt2d(ngrd,nt)
      real rmse
      open(unit=10,form='unformatted',access='direct',recl=4*nfld)
C
      open(unit=20,form='unformatted',access='direct',recl=4)
c*************************************************
C read nmme sst anom

      do it=1,nt

        read(10,rec=it) xin

          do i=1,ngrd
            wk(i,it)=xin(i)
          enddo

            on34(it)=xin(nfld)

      enddo ! it loop

      print *, 'nmod=',ig
C
C arrange data for CV
C
      DO itgt=1,nt      !loop over target yr

        it = 0
        DO iy = 1, nt

        IF(iy == itgt)  PRINT *,'iy=',iy

        if(iy /= itgt)  then

        it = it + 1

        do k=1,ngrd
        fcv(k,it) = wk(k,iy)
        enddo

        ocv(it)=on34(iy)

        ENDIF
        ENDDO  ! iy loop
       
        rdg=ridge
        go to 212
 211    continue
        rdg=rdg+del
 212    continue

      call get_mlr_wt(ocv,fcv,wt,ngrd,nt-1,rdg)

        do i=1,ngrd
        wt2d(i,itgt)=wt(i)
        enddo

        wts=0
        do k=1,ngrd
        wts=wts+wt(k)*wt(k)
        enddo
c       write(6,*) 'target yr=',itgt,'wts=',wts
        if(wts.gt.0.5) go to 211

      ENDDO  ! itgt loop

c construct corrected fcst

      do it=1,nt
        fn34(it)=0.
        do k=1,ngrd
        fn34(it)=fn34(it)+wt2d(k,it)*wk(k,it)
        enddo
      enddo
c
C write out
      iw=0
      do it=1,nt
        iw=iw+1
        write(20,rec=iw) on34(it)
        iw=iw+1
        write(20,rec=iw) fn34(it)
      enddo
      write(6,*) 'n34=',on34

      stop
      end

      subroutine normal(x,n)
      dimension x(n)
      avg=0
      do i=1,n
        avg=avg+x(i)/float(n)
      enddo
      var=0
      do i=1,n
        var=var+(x(i)-avg)*(x(i)-avg)/float(n)
      enddo
      std=sqrt(var)
      do i=1,n
        x(i)=(x(i)-avg)/std
      enddo
      return
      end

      subroutine rms_err(x1,x2,n,rmse)
      dimension x1(n),x2(n)
      rv=0.
      do i=1,n
        rv=rv+(x1(i)-x2(i))*(x1(i)-x2(i))
      enddo
      rmse=sqrt(rv/float(n))
      return
      end
      
      subroutine get_mlr_wt(v,f,wt,m,n,ridge)
C==========================================
C n=time, m=number of factors
C v(n): obs;, f(m,n): matrix of factors
C w(n): weights for factors
C==========================================
      real*4 v(n),f(m,n),wt(m)
      real*8 ff(m,m),vf(m),ffiv(m,m)
C have matrix
      call setzero_2d_dd(ff,m,m)
      call setzero_1d_dd(vf,m)
c
      do im=1,m
      do jm=1,m
        do i=1,n
          ff(im,jm)=ff(im,jm)+f(im,i)*f(jm,i)/float(n)
        end do
      end do
      end do

      do im=1,m
        do i=1,n
          vf(im)=vf(im)+v(i)*f(im,i)/float(n)
        end do
      end do

C add a ridge
      dg=0
      do i=1,m
       dg=dg+ff(i,i)*ff(i,i)
      enddo
      dg=sqrt(dg/float(m))
c     write(6,*) 'rms of diagnal elements',dg

      do i=1,m
       ff(i,i)=ff(i,i)+ridge*dg
      enddo

       call mtrx_inv(ff,ffiv,m,m)
       call solutn(ffiv,vf,wt,m)

      return
      end

      SUBROUTINE solutn(ff,vf,beta,m)
      real*8 ff(m,m),vf(m)
      real beta(m)

      do i=1,m
         beta(i)=0.
      do j=1,m
         beta(i)=beta(i)+ff(i,j)*vf(j)
      end do
      end do

      return
      end


C       ================================================================
        subroutine  mtrx_inv( x, xinv, n,max_npc)
C       ================================================================
        implicit none
c #include  "reg_parm"
        integer max_nchan
        parameter(max_nchan = 2000) !MAXIMUM # OF ALLOWED REGRESSION
                                    !CHANNELS
        integer max_nsamp
        parameter(max_nsamp = 600) ! MAXIMUM TRAINING SAMPLE SIZE

        integer max_npc
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
C                            EXECUTABLE CODE
C***********************************************************************
C-----------------------------------------------------------------------
C     [ Major comment blocks set off by rows of dashes. ]
C-----------------------------------------------------------------------
C    CONVERT 'X' TO A DOUBLE PRECISION WORK ARRAY.
      do 10 i=1,n
      do 10 j=1,n
c      a(i,j)=dble(x(i,j))
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
c      xinv(i,j)=sngl(s(i,j))
      xinv(i,j)=s(i,j)
  190 continue
      return
      end

      SUBROUTINE setzero_2d_dd(fld,n,m)
      real*8 fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end
      SUBROUTINE setzero_1d_dd(fld,n)
      real*8 fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end
