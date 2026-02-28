C
      subroutine min_max(LEX,ximf,spmax,spmin,nmax,nmin)
C
c  This is a routine to define maxima and minima from series ximf.
c  All the extrema are defined as the corresponding values of
c  ximf in spmax and spmin. All non-extrema values in spmax and
c  spmin are defined as 1.0e31.
c
      real ximf(LEX),spmax(LEX),spmin(LEX)
      integer nmax, nmin
c
      nmax=0
      nmin=0

      spmax(1)=ximf(1)
      spmax(LEX)=ximf(LEX)
      spmin(1)=spmax(1)
      spmin(LEX)=spmax(LEX)

      nmax=2
      nmin=2

      do i=2,LEX-1
        if(ximf(i).gt.ximf(i-1).and.ximf(i).ge.ximf(i+1)) then
          spmax(i)=ximf(i)
          nmax=nmax+1
        else
          spmax(i)=1.0e31
        endif
        if(ximf(i).lt.ximf(i-1).and.ximf(i).le.ximf(i+1)) then
          spmin(i)=ximf(i)
          nmin=nmin+1
        else
          spmin(i)=1.0e31
        endif
      enddo

      call endmax(LEX, spmax, nmax)
      call endmin(LEX, spmin, nmin)

      return
      end


c****************************************************************
c
      subroutine endmax(LEX, temp, nmax)
      integer nmax
      real temp(LEX), exmax(nmax), X(nmax)
     
      lend=nmax

      J=1
      DO I=1, LEX
        IF( temp(I).LT.1.0E30 ) THEN
          X(J)=float(I)
          exmax(J)=temp(I)
          J=J+1
        ENDIF
      ENDDO

      if (nmax .ge. 4) then
        slope1=(exmax(2)-exmax(3))/(X(2)-X(3))
        tmp1=slope1*(X(1)-X(2))+exmax(2)
        if(tmp1.gt.exmax(1)) then
          temp(1)=tmp1
        endif
        
        slope2=(exmax(lend-1)-exmax(lend-2))/(X(lend-1)-X(lend-2))
        tmp2=slope2*(X(lend)-X(lend-1))+exmax(lend-1)
        if(tmp2.gt.exmax(lend)) then
          temp(LEX)=tmp2
        endif
      endif
      
      return
      end



c****************************************************************
c
      subroutine endmin(LEX, temp, nmax)
      integer lend
      real temp(LEX), exmax(nmax), X(nmax)

      lend=nmax
      J=1
      DO I=1, LEX
        IF( temp(I).LT.1.0E30 ) THEN
          X(J)=float(i)
          exmax(J)=temp(I)
          J=J+1
        ENDIF
      ENDDO


      if (nmax .ge. 4) then
        slope1=(exmax(2)-exmax(3))/(X(2)-X(3))
        tmp1=slope1*(X(1)-X(2))+exmax(2)
        if(tmp1.lt.exmax(1)) then
          temp(1)=tmp1
        endif

        slope2=(exmax(lend-1)-exmax(lend-2))/(X(lend-1)-X(lend-2))
        tmp2=slope2*(X(lend)-X(lend-1))+exmax(lend-1)
        if(tmp2.lt.exmax(lend)) then
          temp(LEX)=tmp2
        endif
      endif
      
      return
      end
