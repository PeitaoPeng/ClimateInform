      program ROC
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. ROC and reliability
C===========================================================)
      parameter(eps=1.e-5)
      real wk1(imx,jmx),wk2(imx,jmx)
      real crtm(imx,jmx,2),crto(imx,jmx,nss,2)
      real ob(21),oa(21),nob(21),noa(21)    !accumulated from n->N
      real on(21),non(21)                  !accumulated from n->N
      real yob(21),yoa(21),xob(21),xoa(21)  !for each bin
      real yon(21),xon(21)                  !for each bin
      real hob(20),hoa(20),fob(20),foa(20)  !for each bin
      real hon(20),fon(20)                  !for each bin
      real fpb(21)
      real prob(imx,jmx,nss,3)
      integer ctgo(imx,jmx,nss)
      integer kvfc(imx,jmx,nss),t1d1(nss),t1d2(nss)
      integer nfa(20),nfb(20)
      real xlat(jmx)
      real coslat(jmx)
      dimension mask(imx,jmx)
      dimension kprd(imx,jmx,nss),mwk1(imx,jmx)
      real np(20)
      real hhob(20),hhoa(20),ffob(20),ffoa(20)  !for each bin
      real hhon(20),ffon(20)                  !for each bin
      real wrga(20),wrgb(20)                  !for each bin
      real xx(20)
c
      data np/95.0,90.0,85.0,80.0,75.0,70.0,65.0,60.0,55.0,50.0,
     &45.0,40.0,33.34,33.32,25.0,20.0,15.0,10.0,5.0,0./
c
      open(10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(14,form='unformatted',access='direct',recl=4*imx*jmx)
      open(15,form='unformatted',access='direct',recl=4*imx*jmx) !categorical fcst
c
      open(61,form='formatted')
      open(62,form='formatted')
      open(65,form='unformatted',access='direct',recl=4*20)
c
ccc have coslat
      dl=2.
      do j=1,jmx
        xlat(j)=dl*(j-1)+20.
c       coslat(j)=COS(3.14159*xlat(j)/180)
        coslat(j)=1.
      enddo
      write(6,*) 'COASLAT=',coslat
C= read in mask
      read(11,rec=1) wk1
      call real_2_itg(wk1,mask,imx,jmx)
c
c= read in prd data
      do it=1,nss
        read(12,rec=it) wk1
        do i=1,imx
        do j=1,jmx
          prob(i,j,it,1)=wk1(i,j)
        enddo
        enddo
        read(13,rec=it) wk2
        do i=1,imx
        do j=1,jmx
          prob(i,j,it,3)=wk2(i,j)
        enddo
        enddo
        do i=1,imx
        do j=1,jmx
          prob(i,j,it,2)=100-wk1(i,j)-wk2(i,j)
        enddo
        enddo
      enddo
        do i=1,imx
        do j=1,jmx
          wk1(i,j)=prob(i,j,1,1)
        enddo
        enddo
c     write(6,*) wk1
c
c read obs data
c
      do it=1,nss
        read(14,rec=it) wk1
        do i=1,imx
        do j=1,jmx
          kvfc(i,j,it)=wk1(i,j)
        enddo
        enddo
      enddo
c
c= read in categorical prd data
      do it=1,nss
        read(15,rec=it) wk1
        do i=1,imx
        do j=1,jmx
          mwk1(i,j)=wk1(i,j)
        enddo
        enddo
        call change_numb(mwk1,imx,jmx)  !convert prd to -1,0,+1,9
        do i=1,imx
        do j=1,jmx
          kprd(i,j,it)=mwk1(i,j)
        enddo
        enddo
      enddo
c convert vfc to probilistic form
      anmb=0.
      do it=1,nss
        do i=1,imx
        do j=1,jmx
        ctgo(i,j,it)=-9999.
        IF(mask(i,j).eq.1) then
          if(kvfc(i,j,it).eq.1) ctgo(i,j,it)=3
          if(kvfc(i,j,it).eq.1) anmb=anmb+coslat(j) !count the # of A cases
          if(kvfc(i,j,it).eq.-1)ctgo(i,j,it)=1
          if(kvfc(i,j,it).eq.0) ctgo(i,j,it)=2
        END IF
        enddo
        enddo
      enddo
      write(6,*) 'A case #=',anmb
c
c have ROC, reliability, and histograms
c
      do ib=1,21
c       fpb(ib)=(ib-1)*0.1
        fpb(ib)=ib*0.1
      enddo

      oa(1)=0.
      ob(1)=0.
      on(1)=0.
      noa(1)=0.
      nob(1)=0.
      non(1)=0.

      do ib=2,21

      ibb=ib-1

      oa(ib)=0.
      ob(ib)=0.
      on(ib)=0.
      noa(ib)=0.
      nob(ib)=0.
      non(ib)=0.

      do i=1,imx
      do j=1,jmx

      if(mask(i,j).eq.1) then

      do it=1,nss
c
c     if(kprd(i,j,it).ne.9) then
c
      if(prob(i,j,it,1).gt.np(ibb).and.ctgo(i,j,it).eq.1) then
        ob(ib)=ob(ib)+coslat(j)
      endif
      if(prob(i,j,it,3).gt.np(ibb).and.ctgo(i,j,it).eq.3) then
        oa(ib)=oa(ib)+coslat(j)
      endif
      if(prob(i,j,it,2).gt.np(ibb).and.ctgo(i,j,it).eq.2) then
        on(ib)=on(ib)+coslat(j)
      endif
      if(prob(i,j,it,1).gt.np(ibb).and.ctgo(i,j,it).ne.1) then
        nob(ib)=nob(ib)+coslat(j)
      endif
      if(prob(i,j,it,3).gt.np(ibb).and.ctgo(i,j,it).ne.3) then
        noa(ib)=noa(ib)+coslat(j)
      endif
      if(prob(i,j,it,2).gt.np(ibb).and.ctgo(i,j,it).ne.2) then
        non(ib)=non(ib)+coslat(j)
      endif

c     endif  ! kprd

      enddo  ! it loop

      endif  ! mask

      enddo  ! iloop
      enddo  ! jloop

      enddo  ! ib 
      write(6,*) 'oa=',oa
      write(6,*) 'ob=',ob
c
      OAN=oa(21)
      OBN=ob(21)
      ONN=on(21)
      FOAN=noa(21)
      FOBN=nob(21)
      FONN=non(21)
      do ib=1,21
        ob(ib)=ob(ib)/ob(21)
        oa(ib)=oa(ib)/oa(21)
        on(ib)=on(ib)/on(21)
        nob(ib)=nob(ib)/nob(21)
        noa(ib)=noa(ib)/noa(21)
        non(ib)=non(ib)/non(21)
      enddo

c have HRn and Fn for each prob bin
        yoa(20)=oa(2)*OAN
        yob(20)=ob(2)*OBN
        yon(20)=on(2)*ONN
        xoa(20)=noa(2)*FOAN
        xob(20)=nob(2)*FOBN
        xon(20)=non(2)*FONN
      do ib=3,21
        yoa(22-ib)=(oa(ib)-oa(ib-1))*OAN
        yob(22-ib)=(ob(ib)-ob(ib-1))*OBN
        yon(22-ib)=(on(ib)-on(ib-1))*ONN
        xoa(22-ib)=(noa(ib)-noa(ib-1))*FOAN
        xob(22-ib)=(nob(ib)-nob(ib-1))*FOBN
        xon(22-ib)=(non(ib)-non(ib-1))*FONN
      enddo
      write(6,*) 'oa=',oa
      write(6,*) 'ob=',ob
      write(6,*) 'on=',on
      write(6,*) 'yoa=',yoa
      write(6,*) 'yob=',yob
      write(6,*) 'yon=',yon
      write(6,*) 'xoa=',xoa
      write(6,*) 'xob=',xob
      write(6,*) 'xon=',xon
      write(6,*) 'OAN=',OAN
      write(6,*) 'OBN=',OBN
      write(6,*) 'ONN=',ONN
c                   
      do ib=1,20
        hoa(ib)=yoa(ib)/(yoa(ib)+xoa(ib))  !reliability of tercile 3
        hob(ib)=yob(ib)/(yob(ib)+xob(ib))  !reliability of tercile 1
        hon(ib)=yon(ib)/(yon(ib)+xon(ib))  !reliability of tercile 2
        xxa=yoa(ib)+xoa(ib)
        xxb=yob(ib)+xob(ib)
        xxn=yon(ib)+xon(ib)
        if(xxa.lt.eps) hoa(ib)=-9999.0
        if(xxb.lt.eps) hob(ib)=-9999.0
        if(xxn.lt.eps) hon(ib)=-9999.0
        foa(ib)=(yoa(ib)+xoa(ib))/(OAN+FOAN)  !histogram of tercile 3
        fob(ib)=(yob(ib)+xob(ib))/(OBN+FOBN)  !histogram of tercile 1
        fon(ib)=(yon(ib)+xon(ib))/(ONN+FONN)  !histogram of tercile 2
      enddo
c
      sumfoa=0.
      sumfob=0.
      do ib=1,21
      sumfoa=sumfoa+foa(ib)
      sumfob=sumfob+fob(ib)
      enddo
      write(6,*) 'sum foa and fob:',sumfoa, sumfob

cc write out for ROC curves
      write(61,*)'CPC Seasonal Temp Forecast: Upper Tercile'
      write(61,*)'CPC Seasonal Prec Forecast: Upper Tercile'
      write(61,*)'False alarm rate'
      write(61,*)'Hit rate'
      write(61,*)'0.33 1.0 0.0 1.0'
      write(61,*)'0.0 0.1 0.0 0.1'
c     write(61,*)'11 2 1'
      write(61,*)'11 1 1'
      do ib=1,21
        write(61,666)noa(ib),oa(ib)
      enddo
c     do ib=1,8
c       write(61,666)nob(ib),ob(ib)
c     enddo
      call roca(oa,noa,11,areaoa)
      write(61,666)areaoa
c
      write(62,*)'CPC Seasonal Temp Forecast: Lower Tercile'
c     write(62,*)'CPC Seasonal Prec Forecast: Lower Tercile'
      write(62,*)'False alarm rate'
      write(62,*)'Hit rate'
      write(62,*)'0.33 1.0 0.0 1.0'
      write(62,*)'0.0 0.1 0.0 0.1'
c     write(62,*)'11 2 1'
      write(62,*)'11 1 1'
      do ib=1,11
        write(62,666)nob(ib),ob(ib)
      enddo
c     do ib=1,11
c       write(62,666)nob(ib),ob(ib)
c     enddo
      call roca(ob,nob,11,areaob)
      write(62,666)areaob
      do i=1,20
        hhoa(i)=-9999.0
        hhob(i)=-9999.0
        hhon(i)=-9999.0
        ffoa(i)=-9999.0
        ffob(i)=-9999.0
        ffon(i)=-9999.0
      enddo
c
c     do i=8,15  !for non-ec
      do i=1,20
        hhoa(i)=hoa(i)
        hhob(i)=hob(i)
        hhon(i)=hon(i)
        ffoa(i)=foa(i)
        ffob(i)=fob(i)
        ffon(i)=fon(i)
      enddo
c
      write(65,rec=1) hhoa
      write(6,*) 'hoa=',hhoa
      write(65,rec=2) hhob
      write(6,*) 'hob=',hhob
      write(65,rec=3) hhon
      write(6,*) 'hon=',hon
      write(65,rec=4) ffoa
      write(6,*) 'foa=',foa
      write(65,rec=5) ffob
      write(6,*) 'fob=',fob
      write(65,rec=6) ffon
      write(6,*) 'fon=',fon
c have forecast frequency in terms of integrals to do regression
      do i=1,20
        nfa(i)=10000*foa(i)
        nfb(i)=10000*fob(i)
      enddo
      nnfa=0
      nnfb=0
      do i=1,14
      nnfa=nnfa+nfa(i)
      nnfb=nnfb+nfb(i)
      enddo
      write(6,*) 'nfa=',nfa
      write(6,*) 'nnfa=',nnfa
      write(6,*) 'nfb=',nfb
      write(6,*) 'nnfb=',nnfb
      do i=1,20
        xx(i)=0.025+(i-1)*0.05
      enddo
c modify some xx to real positions
      xx(6)=0.292
      xx(7)=0.333
      xx(8)=0.367
      write(6,*) 'xx=',xx
c call regression
      call wregr(nfa,hhoa,xx,20,14,nnfb,xma,yma,wrga)
      call wregr(nfb,hhob,xx,20,14,nnfa,xmb,ymb,wrgb)
      write(65,rec=7) wrga
      write(6,*) 'rga=',wrga
      write(6,*) 'mean prob of forecast for above =',xma
      write(6,*) 'mean prob of observed for above =',yma
      write(65,rec=8) wrgb
      write(6,*) 'rgb=',wrgb
      write(6,*) 'mean prob of forecast for below =',xmb
      write(6,*) 'mean prob of observed for below =',ymb

555   format(11f6.2)
666   format(2f6.2)
777   format(A5,11f6.2)
888   format(f6.2)
cc count the grid pts where prd prob_above > 70%
      ia=0
      itot=0
      do it=1,180
      do i=1,imx
      do j=1,jmx
        IF(mask(i,j).eq.1) then
        itot=itot+1
        if(prob(i,j,it,3).gt.70) then
        ia=ia+1
        endif
        ENDIF
      enddo
      enddo
      enddo
      write(6,*) 'itot&iabove=',itot,ia

      stop
      END
c
c weighted regression
      subroutine wregr(nf,ho,xx,n,ns,ntot,xb,yb,rg)
      dimension wx(50000)
      dimension wy(50000)
      dimension nf(n),ho(n)
      dimension xx(n)
      dimension rg(n)
c have 1-d array for both x and y
      k=0
      do i=1,ns
      do j=1,nf(i)
      k=k+1
      wx(k)=xx(i)
      wy(k)=ho(i)
      enddo
      enddo
      
      do i=1,n
        rg(i)=-9999.0
      enddo
c
      xb=0.
      yb=0.
      do i=1,ntot
        xb=xb+wx(i)/float(ntot)
        yb=yb+wy(i)/float(ntot)
      enddo
      xxl=0.
      xyl=0.
      do i=1,ntot
        xxl=xxl+(wx(i)-xb)*(wx(i)-xb)
        xyl=xyl+(wx(i)-xb)*(wy(i)-yb)
      enddo
      bb=xyl/xxl
      aa=yb-bb*xb
      do i=1,ns
        rg(i)=aa+bb*xx(i)
      enddo

      return
      end

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  change num of verification to -1,0,+1,9
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine change_numb(mw,m,n)
      dimension mw(m,n)
c
      do i=1,m
      do j=1,n
      if(mw(i,j).eq.0) mw(i,j)=9
      if(mw(i,j).eq.1) mw(i,j)=-1
      if(mw(i,j).eq.2) mw(i,j)=0
      if(mw(i,j).eq.3) mw(i,j)=1
      end do
      end do
c
      return
      end

      SUBROUTINE SORT(N,RA)
      DIMENSION RA(N)
      L=N/2+1
      IR=N
10    CONTINUE
        IF(L.GT.1)THEN
          L=L-1
          RRA=RA(L)
        ELSE
          RRA=RA(IR)
          RA(IR)=RA(1)
          IR=IR-1
          IF(IR.EQ.1)THEN
            RA(1)=RRA
            RETURN
          ENDIF
        ENDIF
        I=L
        J=L+L
20      IF(J.LE.IR)THEN
          IF(J.LT.IR)THEN
            IF(RA(J).LT.RA(J+1))J=J+1
          ENDIF
          IF(RRA.LT.RA(J))THEN
            RA(I)=RA(J)
            I=J
            J=J+J
          ELSE
            J=IR+1
          ENDIF
        GO TO 20
        ENDIF
        RA(I)=RRA
      GO TO 10
      END

c
      SUBROUTINE setzero_1d(fld,n)
      DIMENSION fld(n)
      do i=1,n
         fld(i)=0.0
      enddo
      return
      end

      SUBROUTINE setzero(fld,n,m)
      DIMENSION fld(n,m)
      do i=1,n
      do j=1,m
         fld(i,j)=0.0
      enddo
      enddo
      return
      end

      SUBROUTINE acc(fld1,fld2,coslat,jmx,imx,
     'lat1,lat2,lon1,lon2,cor)

      real fld1(imx,jmx),fld2(imx,jmx),coslat(jmx)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo


      cor=0.
      sd1=0.
      sd2=0.

      do j=lat1,lat2
      do i=lon1,lon2
         cor=cor+fld1(i,j)*fld2(i,j)*coslat(j)/area
         sd1=sd1+fld1(i,j)*fld1(i,j)*coslat(j)/area
         sd2=sd2+fld2(i,j)*fld2(i,j)*coslat(j)/area
      enddo
      enddo

      sd1=sd1**0.5
      sd2=sd2**0.5
      cor=cor/(sd1*sd2)

      return
      end
c
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C  real 2 integer
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      subroutine real_2_itg(wk,mw,m,n)
      dimension wk(m,n),mw(m,n)
c
      do i=1,m
      do j=1,n
      mw(i,j)=wk(i,j)
      end do
      end do
c
      return
      end


      SUBROUTINE accavg(acc,sd1,sd2,coslat,jmx,imx,
     '                  lat1,lat2,lon1,lon2,cor)

      real acc(imx,jmx),coslat(jmx)
      real sd1(imx,jmx),sd2(imx,jmx)

      area=0
      do j=lat1,lat2
      do i=lon1,lon2
        area=area+coslat(j)
      enddo
      enddo

      cor=0.
      do j=lat1,lat2
      do i=lon1,lon2

        if(acc(i,j).lt.0..and.(sd1(i,j)/sd2(i,j)).lt.1) then
c       acc(i,j)=acc(i,j)*(sd1(i,j)/sd2(i,j))
        endif

        cor=cor+acc(i,j)*coslat(j)/area

      enddo
      enddo

      return
      end

      SUBROUTINE norsou(fldin,fldot,lon,lat)
      dimension fldin(lon,lat),fldot(lon,lat)
      do 100 j=1,lat
      do 100 i=1,lon
         fldot(i,j)=fldin(i,lat+1-j)
  100 continue
      return
      end

      SUBROUTINE wtout(fld,lon,lat,lat1,lat2,lon1,lon2)
      dimension fld(lon,lat)
      do 100 j=lat1,lat2
      do 100 i=lon1,lon2
         write(6,*) 'i,j= ',i,j,fld(i,j)
  100 continue
      return
      end

      SUBROUTINE clim_stdv(ts,nt,ave,sd)
      real ts(nt)
      ave=0
      do i=1,nt
        ave=ave+ts(i)/float(nt)
      enddo

      sd=0
      do i=1,nt
        sd=sd+(ts(i)-ave)*(ts(i)-ave)/float(nt)
      enddo
      sd=sqrt(sd)

      return
      end


      SUBROUTINE maskout(fld,mask,lon,lat)
      dimension fld(lon,lat),mask(lon,lat)
      do  j=1,lat
      do  i=1,lon
        if(mask(i,j).gt.0) then
          fld(i,j)=-99999.0
        endif
      end do
      end do
      return
      end


