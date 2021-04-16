      program main
      implicit double precision (a-h,o-z)
      implicit integer(i-n)

      character*16 buf
      character*255 filein,fileout,namebuf
      double precision,allocatable,dimension(:,:) :: pos
      double precision,parameter
     &  :: pi= 3.14159265358979323846264338327950288419

      dimension ccmpos(3)
      dimension xcmpos(3)
      dimension cnt(3)
      dimension cntxy(3)
      dimension e1(3),e2(3),e3(3),e1old(3),e2old(3),e3old(3)

 
      e1=(/1,0,0/)
      e2=(/0,1,0/)
      e3=(/0,0,1/)     

      e1old=e1
      e2old=e2
      e3old=e3

      narg=COMMAND_ARGUMENT_COUNT()

      if(narg>=1) then
      call getarg(1,filein)
      open(11,file=trim(filein),status='old')
      else
         open(11,file='pos.dat',status='old')
      end if

      if(narg>=2) then
      call getarg(2,fileout)
      open(21,file=trim(fileout),status='replace')
      else
         open(21,file='pos_edit.dat',status='replace')
      end if

      write(*,*) 'input free carbon density (nclus)'
      read(*,*,err=1237) nclus
      goto 1238

 1237 write(*,*) 'nclus has to be an integer'
      stop

 1238 continue

      read(11,*)
      read(11,*) nmc
      read(11,*) nmm
      read(11,*) ngen
      read(11,*) vlx,vly,vlz
      read(11,*) t0
      read(11,*) time

      allocate( pos(nmc+nmm,3) )

      write(21,*) 1
      write(21,*) nmc
      write(21,*) nmm
      write(21,*) ngen
      write(21,*) vlx,vly,vlz
      write(21,*) t0
      write(21,*) time

      rcut=3.0d0
      rcarbon=2.0d0

      npick=0
      do igen=1,ngen !frame loop
        ccmpos=0.0d0
        xcmpos=0.0d0
        nmc_current=0
        cos_t=0.0d0
        sin_t=0.0d0
        cos_p=0.0d0
        sin_p=0.0d0
        cnt  =0.0d0
        cntxy=0.0d0

        !write(*,*) igen

       x49=vlx*0.49-0.0001
       x491=x49+0.0002
       y49=vly*0.49-0.0001
       y491=y49+0.0002
       z49=vlz*0.49-0.0001
       z491=z49+0.0002
       
        do i=1,nmc !carbon atoms reading from pos.dat
          read(11,*) pos(i,1),pos(i,2),pos(i,3)
          if( (pos(i,1).ge.x49).and.(pos(i,1).le.x491) ) then
          if( (pos(i,2).ge.y49).and.(pos(i,2).le.y491) ) then
          if( (pos(i,3).ge.z49).and.(pos(i,3).le.z491) ) then
             cycle ! omit non-active carbon
          end if
          end if
          end if

          nmc_current=nmc_current+1 !count active-carbon
        end do
          write(*,*) 'nmc_current=', nmc_current
        do i=nmc+1,nmc+nmm
          read(11,*) pos(i,1),pos(i,2),pos(i,3)
        end do

        if(npick.eq.0) then
            write(*,*) igen
            ipick=0
            pick=0.0d0
          do i=1,nmc_current !find top of the cap: pos(ipick,1-3)
            x=pos(i,1)
            y=pos(i,2)
            z=pos(i,3) 
             xy=dsqrt(x**2+y**2)
             if(pick<xy*dabs(z)) then
               picknew=xy*dabs(z)
               ipick=i
               xpick=pos(ipick,1)
               ypick=pos(ipick,2)
               zpick=pos(ipick,3)
               rmin=vlx
                  do j=1,nmc_current
                     if(j.eq.ipick) then
                       cycle
                     end if

                     x=pos(j,1)
                     y=pos(j,2)
                     z=pos(j,3)
                     rr=dsqrt( (xpick-x)**2+(ypick-y)**2+(zpick-z)**2 ) 
                     rmin=min(rmin,rr)
                  end do
                  if(rmin>rcarbon) then
                    cycle ! cap should have a C-C bond
                  end if
                  write(*,*) 'rmin_carbon=',rmin !top-of-cap carbon bond length rmin
               rmin=vlx
                  do j=nmc+1,nmc+nmm
                    x=pos(j,1)
                    y=pos(j,2)
                    z=pos(j,3)
                    rr=dsqrt( (xpick-x)**2+(ypick-y)**2+(zpick-z)**2 )
                    rmin=min(rmin,rr)
                  end do
                  if(rmin<rcut) then
                    cycle ! cap should not have a C-M bond
                  end if
                  write(*,*) 'rmin_metal=',rmin
                  npick=ipick
                  pick=picknew
                  write(*,*) 'igen=',igen
                  write(*,*) 'npick=',npick !top of cap (kakutei)
             end if
          end do
        end if


        do i=1,nmc_current-nclus !carbon center of mass
          ccmpos(1)=ccmpos(1)+pos(i,1)/dble(nmc_current)
          ccmpos(2)=ccmpos(2)+pos(i,2)/dble(nmc_current)
          ccmpos(3)=ccmpos(3)+pos(i,3)/dble(nmc_current)
        end do       

        do i=nmc+1,nmc+nmm !metal center of mass
          xcmpos(1)=xcmpos(1)+pos(i,1)/dble(nmm)
          xcmpos(2)=xcmpos(2)+pos(i,2)/dble(nmm)
          xcmpos(3)=xcmpos(3)+pos(i,3)/dble(nmm)
        end do

        !write(23,*) ccmpos(1),ccmpos(2),ccmpos(3)
        !write(23,*) xcmpos(1),xcmpos(2),xcmpos(3)

        cntlen2=0.0d0
        do j=1,3
          cnt(j)=ccmpos(j)- xcmpos(j) !axial vector cnt(1-3)
          cntlen2=cntlen2+cnt(j)**2
        end do
          cntlen2=dsqrt(cntlen2)
          cntxy(1)=cnt(1)/dsqrt(cnt(1)**2+cnt(2)**2)
          cntxy(2)=cnt(2)/dsqrt(cnt(1)**2+cnt(2)**2)
          cntxy(3)=0.0d0
          cnt=cnt/cntlen2
c          write(22,*) nmc_current, 
c     &    cnt(1),cnt(2),cnt(3),cnt(1)**2+cnt(2)**2+cnt(3)**2

          cos_t=cntxy(1)
          sin_t=cntxy(2)

        do i=1,nmc_current
           x=pos(i,1)
           y=pos(i,2)
           z=pos(i,3)
           pos(i,1)=x*cos_t+y*sin_t
           pos(i,2)=-x*sin_t+y*cos_t
        end do

        do i=nmc+1,nmc+nmm
           x=pos(i,1)
           y=pos(i,2)
           z=pos(i,3)
           pos(i,1)=x*cos_t+y*sin_t
           pos(i,2)=-x*sin_t+y*cos_t
        end do

        x=cnt(1)
        y=cnt(2)
        z=cnt(3)

        cnt(1)=x*cos_t+y*sin_t
        cnt(2)=-x*sin_t+y*cos_t

        !caution sign of phi is different from theta 

        cos_p=cnt(3)
        sin_p=cnt(1)

        !write(24,*) cnt(2),nmc_current

         do i=1,nmc_current
           x=pos(i,1)
           y=pos(i,2)
           z=pos(i,3)
           pos(i,1)=x*cos_p-z*sin_p
           pos(i,3)=x*sin_p+z*cos_p
          end do

        do i=nmc+1,nmc+nmm
           x=pos(i,1)
           y=pos(i,2)
           z=pos(i,3)
           pos(i,1)=x*cos_p-z*sin_p
           pos(i,3)=x*sin_p+z*cos_p
        end do


      ! stop rotation
        if(npick.ne.0) then
          enorm=dsqrt(pos(npick,1)**2+pos(npick,2)**2)
          cos_a=pos(npick,1)/enorm
          sin_a=pos(npick,2)/enorm

        do i=1,nmc_current
          x=pos(i,1)
          y=pos(i,2)
          z=pos(i,3)
          pos(i,1)=x*cos_a+y*sin_a
          pos(i,2)=-x*sin_a+y*cos_a
        end do

        do i=nmc+1,nmc+nmm
          x=pos(i,1)
          y=pos(i,2)
          z=pos(i,3)
          pos(i,1)=x*cos_a+y*sin_a
          pos(i,2)=-x*sin_a+y*cos_a
        end do
        end if

        do i=1,nmc+nmm
           write(21,'(3f8.3)') pos(i,1),pos(i,2),pos(i,3)
        end do



      end do
      close(11)
      close(21)
      end program

          
