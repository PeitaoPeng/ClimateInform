      program test_data
      include "parm.h"
      dimension out(nt)
      dimension w2d(imx,jmx),w2d2(imx,jmx)
      dimension w3d(imx,jmx,nt),w3d2(imx,jmx,nt)
      dimension ts1(nt),ts2(nt),ts3(nt)
      dimension aam(ngrdm,nt),wkm(nt,ngrdm)
      dimension aao(ngrdo,nt),wko(nt,ngrdo)

      dimension evalm(nt),evecm(ngrdm,nt),coefm(nt,nt)
      dimension revalm(nmodm),revecm(ngrdm,nmodm),rcoefm(nmodm,nt)
      dimension rwkm(ngrdm),rwkm2(ngrdm,nmodm),ttm(nmodm,nmodm)

      dimension evalo(nt),eveco(ngrdo,nt),coefo(nt,nt)
      dimension revalo(nmodo),reveco(ngrdo,nt),rcoefo(nmodo,nt)
      dimension rwko(ngrdo),rwko2(ngrdo,nmodo),tto(nmodo,nmodo)

      dimension xlat(jmx),coslat(jmx),cosr(jmx)
      real corr(imx,jmx),regr(imx,jmx)
      open(unit=10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=11,form='unformatted',access='direct',recl=4*imx*jmx)
C
      open(unit=20,form='unformatted',access='direct',recl=4*nt)
      open(unit=21,form='unformatted',access='direct',recl=4*nt)
C
      open(unit=30,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=31,form='unformatted',access='direct',recl=4*imx*jmx)
      open(unit=32,form='unformatted',access='direct',recl=4*imx*jmx)
C*************************************************
C
C== have coslat
C
      do j=1,jmx
        xlat(j)=-90+(j-1)*2.5
        coslat(j)=cos(xlat(j)*3.14159/180)  !for EOF use
        cosr(j)=sqrt(coslat(j))  !for EOF use
      enddo
C read model sst anom
      ir=ld
      do it=1,nt
        read(10,rec=ir) w2d
          do i=1,imx
          do j=1,jmx
            w3d(i,j,it)=w2d(i,j)
          enddo
          enddo
        print *, 'ir=',ir
        ir=ir+nld
      enddo ! it loop

C read obs sst anom
      do it=1,nt
        read(11,rec=it) w2d2
          do i=1,imx
          do j=1,jmx
            w3d2(i,j,it)=w2d2(i,j)
          enddo
          enddo
      enddo ! it loop

C EOF for model
      do it=1,nt
      ig=0
      do i=is,ie
      do j=js,je
        if(abs(w3d(i,j,it)).lt.1000) then
        ig=ig+1
        aam(ig,it)=w3d(i,j,it)*cosr(j)
        endif
      enddo
      enddo
      print *, 'ngrdm=',ig
      enddo
C
c     call eofs(aam,ngrdm,nt,nt,evalm,evecm,coefm,wkm,id)
      call reofs(aam,ngrdm,nt,nt,wkm,id,evalm,evecm,coefm,
     &           nmodm,revalm,revecm,rcoefm,ttm,rwkm,rwkm2)
      print *, 'valm=',revalm
C
C EOF for OBS
      do it=1,nt
      ig=0
      do i=is,ie
      do j=js,je
        if(abs(w3d2(i,j,it)).lt.1000) then
        ig=ig+1
        aao(ig,it)=w3d2(i,j,it)*cosr(j)
        endif
      enddo
      enddo
      print *, 'ngrdo=',ig
      enddo
C
c     call eofs(aao,ngrdo,nt,nt,evalo,eveco,coefo,wko,id)
      call reofs(aao,ngrdo,nt,nt,wko,id,evalo,eveco,coefo,
     &           nmodo,revalo,reveco,rcoefo,tto,rwko,rwko2)
      print *, 'valo=',revalo
C
C have model patterns
      iw=0
      do m=1,nmodm
        do it=1,nt
        ts1(it)=rcoefm(m,it)
        enddo
        call normal(ts1,nt)

        do it=1,nt
        rcoefm(m,it)=ts1(it)
        enddo
c
        do j=1,jmx
        do i=1,imx

        if(abs(w2d(i,j)).lt.1000) then

        do it=1,nt
        ts3(it)=w3d(i,j,it)
        enddo

        call regr_t(ts1,ts3,nt,corr(i,j),regr(i,j))
        else

        corr(i,j)= -9.99E+8
        regr(i,j)= -9.99E+8

        endif

        enddo
        enddo

        iw=iw+1
        write(30,rec=iw) regr
      enddo
C
C have OBS patterns
      iw=0
      do m=1,nmodo
        do it=1,nt
        ts1(it)=rcoefo(m,it)
        enddo
        call normal(ts1,nt)

        do it=1,nt
        rcoefo(m,it)=ts1(it)
        enddo
c
        do j=1,jmx
        do i=1,imx

        if(abs(w2d2(i,j)).lt.1000) then

        do it=1,nt
        ts3(it)=w3d2(i,j,it)
        enddo

        call regr_t(ts1,ts3,nt,corr(i,j),regr(i,j))
        else

        corr(i,j)= -9.99E+8
        regr(i,j)= -9.99E+8

        endif

        enddo
        enddo

        iw=iw+1
        write(31,rec=iw) regr
      enddo
C
C write out coef of model and obs
      do m=1,nmodm
        do it=1,nt
          out(it)=rcoefm(m,it)
        enddo
        write(20,rec=m) out
      enddo
c
      do m=1,nmodo
        do it=1,nt
          out(it)=rcoefo(m,it)
        enddo
        write(21,rec=m) out
      enddo
C
C write out model anomaly
      do it=1,nt
        do i=1,imx
        do j=1,jmx
          w2d(i,j)=w3d(i,j,it)
        enddo
        enddo
        write(32,rec=it) w2d
      enddo
c
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

      SUBROUTINE regr_t(f1,f2,ltime,cor,reg)

      real f1(ltime),f2(ltime)

      cor=0.
      sd1=0.
      sd2=0.

      do it=1,ltime
         cor=cor+f1(it)*f2(it)/float(ltime)
         sd1=sd1+f1(it)*f1(it)/float(ltime)
         sd2=sd2+f2(it)*f2(it)/float(ltime)
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      reg=cor/(sd1)
      cor=cor/(sd1*sd2)

      return
      end

