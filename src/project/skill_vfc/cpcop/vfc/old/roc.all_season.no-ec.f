      program ROC
      include "parm.h"
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C. ROC and reliability
C===========================================================)
      parameter(eps=1.e-5)
      real wk1(imx,jmx),wk2(imx,jmx)
      real crtm(imx,jmx,2),crto(imx,jmx,nss,2)
      real ob(11),oa(11),nob(11),noa(11)    !accumulated from n->N
      real on(11),non(11)                  !accumulated from n->N
      real yob(11),yoa(11),xob(11),xoa(11)  !for each bin
      real yon(11),xon(11)                  !for each bin
      real hob(10),hoa(10),fob(10),foa(10)  !for each bin
      real hon(10),fon(10)                  !for each bin
      real fpb(11)
      integer ctgo(imx,jmx,nss),prob(imx,jmx,nss,3)
      integer kvfc(imx,jmx,nss),t1d1(nss),t1d2(nss)
      real xlat(jmx)
      real coslat(jmx)
      dimension mask(imx,jmx)
      dimension kprd(imx,jmx,nss),mwk1(imx,jmx)

      open(10,form='unformatted',access='direct',recl=4*imx*jmx)
      open(11,form='unformatted',access='direct',recl=4*imx*jmx)
      open(12,form='unformatted',access='direct',recl=4*imx*jmx)
      open(13,form='unformatted',access='direct',recl=4*imx*jmx)
      open(14,form='unformatted',access='direct',recl=4*imx*jmx)
      open(15,form='unformatted',access='direct',recl=4*imx*jmx) !categorical fcst
c
      open(61,form='formatted')
      open(62,form='formatted')
      open(65,form='unformatted',access='direct',recl=4*10)
c
ccc have coslat
      dl=2.
      do j=1,jmx
        xlat(j)=dl*(j-1)+20.
        coslat(j)=COS(3.14159*xlat(j)/180)
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
      do ib=1,11
c       fpb(ib)=(ib-1)*0.1
        fpb(ib)=ib*0.1
      enddo

      oa(1)=0.
      ob(1)=0.
      on(1)=0.
      noa(1)=0.
      nob(1)=0.
      non(1)=0.

      do ib=2,11

      np=100-(ib-1)*10

      oa(ib)=0.
      ob(ib)=0.
      on(ib)=0.
      noa(ib)=0.
      nob(ib)=0.
      non(ib)=0.

      do i=1,imx
      do j=1,jmx
c     do i=1,14
c     do j=1,12

      if(mask(i,j).eq.1) then

      do it=1,nss
c
      if(kprd(i,j,it).ne.9) then
c
      if(prob(i,j,it,1).gt.np.and.ctgo(i,j,it).eq.1) then
        ob(ib)=ob(ib)+coslat(j)
      endif
      if(prob(i,j,it,3).gt.np.and.ctgo(i,j,it).eq.3) then
        oa(ib)=oa(ib)+coslat(j)
      endif
      if(prob(i,j,it,2).gt.np.and.ctgo(i,j,it).eq.2) then
        on(ib)=on(ib)+coslat(j)
      endif
      if(prob(i,j,it,1).gt.np.and.ctgo(i,j,it).ne.1) then
        nob(ib)=nob(ib)+coslat(j)
      endif
      if(prob(i,j,it,3).gt.np.and.ctgo(i,j,it).ne.3) then
        noa(ib)=noa(ib)+coslat(j)
      endif
      if(prob(i,j,it,2).gt.np.and.ctgo(i,j,it).ne.2) then
        non(ib)=non(ib)+coslat(j)
      endif

      endif  ! kprd

      enddo  ! it loop

      endif  ! mask

      enddo  ! iloop
      enddo  ! jloop

      enddo  ! ib 
c
      OAN=oa(11)
      OBN=ob(11)
      ONN=on(11)
      FOAN=noa(11)
      FOBN=nob(11)
      FONN=non(11)
      do ib=1,11
        ob(ib)=ob(ib)/ob(11)
        oa(ib)=oa(ib)/oa(11)
        on(ib)=on(ib)/on(11)
        nob(ib)=nob(ib)/nob(11)
        noa(ib)=noa(ib)/noa(11)
        non(ib)=non(ib)/non(11)
      enddo

c have HRn and Fn for each prob bin
        yoa(10)=oa(2)*OAN
        yob(10)=ob(2)*OBN
        yon(10)=on(2)*ONN
        xoa(10)=noa(2)*FOAN
        xob(10)=nob(2)*FOBN
        xon(10)=non(2)*FONN
      do ib=3,11
        yoa(12-ib)=(oa(ib)-oa(ib-1))*OAN
        yob(12-ib)=(ob(ib)-ob(ib-1))*OBN
        yon(12-ib)=(on(ib)-on(ib-1))*ONN
        xoa(12-ib)=(noa(ib)-noa(ib-1))*FOAN
        xob(12-ib)=(nob(ib)-nob(ib-1))*FOBN
        xon(12-ib)=(non(ib)-non(ib-1))*FONN
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
      do ib=1,10
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
      do ib=1,11
      sumfoa=sumfoa+foa(ib)
      sumfob=sumfob+fob(ib)
      enddo
      write(6,*) 'sum foa and fob:',sumfoa, sumfob

cc write out for ROC curves
      write(61,*)'CPC Seasonal Temp Forecast: Upper Tercile'
      write(61,*)'CPC Seasonal Prec Forecast: Upper Tercile'
      write(61,*)'False alarm rate'
      write(61,*)'Hit rate'
      write(61,*)'0.0 1.0 0.0 1.0'
      write(61,*)'0.0 0.1 0.0 0.1'
c     write(61,*)'11 2 1'
      write(61,*)'11 1 1'
      do ib=1,11
        write(61,666)noa(ib),oa(ib)
      enddo
c     do ib=1,11
c       write(61,666)nob(ib),ob(ib)
c     enddo
      call roca(oa,noa,11,areaoa)
      write(61,666)areaoa
c
      write(62,*)'CPC Seasonal Temp Forecast: Lower Tercile'
c     write(62,*)'CPC Seasonal Prec Forecast: Lower Tercile'
      write(62,*)'False alarm rate'
      write(62,*)'Hit rate'
      write(62,*)'0.0 1.0 0.0 1.0'
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
c
      write(65,rec=1) hoa
      write(6,*) 'hoa=',hoa
      write(65,rec=2) hob
      write(6,*) 'hob=',hob
      write(65,rec=3) hon
      write(6,*) 'hon=',hon
      write(65,rec=4) foa
      write(6,*) 'foa=',foa
      write(65,rec=5) fob
      write(6,*) 'fob=',fob
      write(65,rec=6) fon
      write(6,*) 'fon=',fon

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


