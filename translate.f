      program main
      implicit none

      character*16 buf, Aelem, Belem
      character*255 filein,fileout,namebuf

      double precision sigmm,epsmm

      double precision, parameter::
     &     abn = 6.0221367d23,
     &     rmc = 12.0d-3/abn,
     &     rkb = 1.3806d-23,
     &     hconst = 6.626068d-34,
     &     evconst = 1.602177d-19,
     &     pi = 3.14159265358979323846264338327950288419,
     &     pi2=pi*2.0,
     &     qmetal=1.0D-47

      double precision, parameter::
     &     sigcc = 3.37d-10,
     &     sigss = 3.23d-10,
     &     epscc = 3.845d-22,
     &     epsss = 2.275d-21

      double precision rcc,rmm,rcm,rlcc,rlcc2,rlmm,rlmm2,
     &     rlmc2,r_LJ,r_LJ2,
     &     rbet,rbetmm,rbetcm,rbet2,rlcm,rlcm2,rbetmm2,rc2,
     &     rlmc,rmin_LJ2,rmin_LJ,rmid_LJ,mu

      double precision r1cc,r1cm,r1mc,r1mm,r2cc,r2cm,r2mc,r2mm,
     &     Acc,Acm,Amc,Amm,
     &     ramda1cc,ramda1cm,ramda1mc,ramda1mm,
     &     Bcc,Bcm,Bmc,Bmm,ramda2cc,ramda2cm,ramda2mc,ramda2mm,
     &     etacc,etacm,etamc,etamm,
     &     deltacc,deltacm,deltamc,deltamm,
     &     c1ccc,c1ccm,c1cmc,c1mcc,c1cmm,c1mcm,c1mmc,c1mmm,
     &     c2ccc,c2ccm,c2cmc,c2mcc,c2cmm,c2mcm,c2mmc,c2mmm,
     &     c3ccc,c3ccm,c3cmc,c3mcc,c3cmm,c3mcm,c3mmc,c3mmm,
     &     hccc,hccm,hcmc,hmcc,hcmm,hmcm,hmmc,hmmm,
     &     pccc,pccm,pcmc,pmcc,pcmm,pmcm,pmmc,pmmm,
     &     recc,recm,remc,remm,
     &     cfcc,cfcc2,cfcm,cfmc,cfcm2,cfmc2,cfmm,cfmm2,
     &     qccc,qccm,qcmc,qmcc,qcmm,qmcm,qmmc,qmmm

      double precision beta_ters
      double precision c4, c5

      double precision rmg

      integer narg
      narg=COMMAND_ARGUMENT_COUNT()      

      if(narg>=1) then
      call getarg(1,filein)
      open(11,file=trim(filein),status='old')
      else
         open(11,file='parameters.dat',status='old')
      end if

      if(narg>=2) then
      call getarg(2,fileout)
      open(101,file=trim(fileout),status='replace')
      else
         open(101,file='C-Co.tersoff_mod',status='replace')
      end if

      if(narg>=3) then
      call getarg(3,Aelem)
      else
         Aelem='C'
      end if       

      if(narg>=4) then
      call getarg(4,Belem)
      else
         Belem='Co'
      end if

!-------------------------------------------------
!*************************************************
!   read parameters.dat(11)
!*************************************************
!-------------------------------------------------
      read(11,*) 
      read(11,*) rmg
      rmg = rmg/abn
!     ???bop_para????????
      read(11,*)
      read(11,*)
      read(11,*)
      read(11,'(11xf)') Acc
      write(*,*) 'Acc= ',Acc
      read(11,'(11xf)') Bcc
      !Bcc=-1.0d0*Bcc
      read(11,'(11xf)') ramda1cc
      read(11,'(11xf)') ramda2cc
      read(11,'(11xf)') etacc
      read(11,'(11xf)') deltacc
      deltacc=deltacc/etacc
      read(11,'(11xf)') pccc
!     q ????EE?E
      read(11,'(11xf)') qccc
      write(*,*) 'qccc= ',qccc
      read(11,'(11xf)') c1ccc
      read(11,'(11xf)') c2ccc
      read(11,'(11xf)') c3ccc
      read(11,'(11xf)') hccc
      write(*,*) 'hccc= ',hccc
      read(11,'(11xf)') r1cc
      read(11,'(11xf)') r2cc
      r2cc=r2cc+r1cc
      read(11,'(11xf)') recc
      read(11,'(11xf)') rlcc


      read(11,*)
      read(11,*)
      read(11,*)
      read(11,'(11xf)') Amm
      read(11,'(11xf)') Bmm
      !Bmm=-1.0d0*Bmm
      read(11,'(11xf)') ramda1mm
      read(11,'(11xf)') ramda2mm
      read(11,'(11xf)') etamm
      read(11,'(11xf)') deltamm
      deltamm=deltamm/etamm
      read(11,'(11xf)') pmmm
!     q ?????
      read(11,'(11xf)') qmmm
      read(11,'(11xf)') c1mmm
      read(11,'(11xf)') c2mmm
      read(11,'(11xf)') c3mmm
      read(11,'(11xf)') hmmm
      read(11,'(11xf)') r1mm
      read(11,'(11xf)') r2mm
      r2mm=r2mm+r1mm
      read(11,'(11xf)') remm
      read(11,'(11xf)') rlmm


      read(11,*)
      read(11,*)
      read(11,*)
      read(11,'(11xf)') Amc
      read(11,'(11xf)') Bmc
      !Bmc=-1.0d0*Bmc
      read(11,'(11xf)') ramda1mc
      read(11,'(11xf)') ramda2mc
      read(11,'(11xf)') etamc
      read(11,'(11xf)') deltamc
      deltamc=deltamc/etamc
      read(11,'(11xf)') etacm
      read(11,'(11xf)') deltacm
      deltacm=deltacm/etacm
      read(11,'(11xf)') pmmc
      read(11,'(11xf)') pmcc
      read(11,'(11xf)') pcmm
      read(11,'(11xf)') pccm
!     q ?????
      read(11,'(11xf)') qmmc
      read(11,'(11xf)') qmcc
      read(11,'(11xf)') qcmm
      read(11,'(11xf)') qccm
      read(11,'(11xf)') c1mmc
      read(11,'(11xf)') c1mcc
      read(11,'(11xf)') c1cmm
      read(11,'(11xf)') c1ccm
      read(11,'(11xf)') c2mmc
      read(11,'(11xf)') c2mcc
      read(11,'(11xf)') c2cmm
      read(11,'(11xf)') c2ccm
      read(11,'(11xf)') c3mmc
      read(11,'(11xf)') c3mcc
      read(11,'(11xf)') c3cmm
      read(11,'(11xf)') c3ccm
      read(11,'(11xf)') hmmc
      read(11,'(11xf)') hmcc
      read(11,'(11xf)') hcmm
      read(11,'(11xf)') hccm
      read(11,'(11xf)') r1mc
      read(11,'(11xf)') r2mc
      r2mc=r2mc+r1mc
      read(11,'(11xf)') remc
      read(11,'(11xf)') rlmc
      write(*,*) 'rlmc=',rlmc

      read(11,*)
      read(11,*)
      read(11,*)
      read(11,'(11xf)') sigmm
      read(11,'(11xf)') epsmm

      read(11,*)
      read(11,*)
      read(11,*)
      read(11,'(11xf)') rmin_LJ
      read(11,'(11xf)') rmid_LJ

      read(11,*)
      read(11,*)
      read(11,*)
      read(11,'(11xf)') mu
      
      
!-------------------------------------
!sssssssssssssssssssssssssssssssssssss
! units translation ( eV / AA -> J / m )
!sssssssssssssssssssssssssssssssssssss
!-------------------------------------
      !Acc=Acc*evconst
      !Amc=Amc*evconst
      !Amm=Amm*evconst
      Acm=Amc
      
      !Bcc=Bcc*evconst
      !Bmc=Bmc*evconst
      !Bmm=Bmm*evconst
      Bcm=Bmc
      
      !ramda1cc=ramda1cc*1.0d10
      !ramda1mc=ramda1mc*1.0d10
      !ramda1mm=ramda1mm*1.0d10
      ramda1cm=ramda1mc
      
      !ramda2cc=ramda2cc*1.0d10
      !ramda2mc=ramda2mc*1.0d10
      !ramda2mm=ramda2mm*1.0d10
      ramda2cm=ramda2mc
      
!     etacc

      
!     deltacc

      
!     p*
      pmcm=pmmc
      pcmc=pccm
      
!     q
      qmcm=qmmc
      qcmc=qccm
      
!     c1,c2,c3,h
      c1mcm=c1mmc
      c1cmc=c1ccm
      c2mcm=c2mmc
      c2cmc=c2ccm
      c3mcm=c3mmc
      c3cmc=c3ccm
      hmcm=hmmc
      hcmc=hccm
      
      !r1cc=r1cc*1.0d-10
      !r1mc=r1mc*1.0d-10
      !r1mm=r1mm*1.0d-10
      r1cm=r1mc
      
      !r2cc=r2cc*1.0d-10
      !r2mc=r2mc*1.0d-10
      !r2mm=r2mm*1.0d-10
      r2cm=r2mc
      
      !recc=recc*1.0d-10
      !remc=remc*1.0d-10
      !remm=remm*1.0d-10
      recm=remc
      
      !rlcc=rlcc*1.0d-10
      !rlmc=rlmc*1.0d-10
      !rlmm=rlmm*1.0d-10
      rlcm=rlmc

      !sigmm=sigmm*1.0D-10
      !rmin_LJ=rmin_LJ*1.0D-10
      !rmid_LJ=rmid_LJ*1.0D-10
      epsmm=epsmm*rkb
      mu=mu*evconst

!-------------------------------------
!sssssssssssssssssssssssssssssssssssss
!  modification
!sssssssssssssssssssssssssssssssssssss
!-------------------------------------
      
      cfcc = pi/(r2cc-r1cc)
      cfcc2 = cfcc/2.0d0
      cfcm = pi/(r2cm-r1cm)
      cfcm2 = cfcm/2.0d0
      cfmm = pi/(r2mm-r1mm)
      cfmm2 = cfmm/2.0d0
      
      cfmc=cfcm
      cfmc2=cfcm2
      
      write(*,*) 'cfcc cfcm cfmm:',cfcc,cfcm,cfmm

      write(*,*) '   complete reading parameters.dat'

!-------------------------------------------------
!    output lammps potential file
!-------------------------------------------------

!#      beta=q   alpha=p   h   eta  beta_ters=1   lambda2   B   R
!#           D  lambda1   A   n  c1   c2   c3   c4   c5

      c4=0.0d0
      c5=0.0d0

      beta_ters = 1.0d0

!# comments
      write(101,fmt='(a)') '# elem1 elem2 elem3 beta=q   alpha=p   
     & h   eta  beta_ters=1   lambda2   B   R   
     & D  lambda1   A   n  c1   c2   c3   c4=0   c5=0'

!# AAA
      write(101,'(3a10, 17e15.6)') Aelem, Aelem, Aelem, qccc, pccc,  
     & hccc, etacc, beta_ters, ramda2cc, Bcc, (r1cc+r2cc)/2.0d0,
     & (r2cc-r1cc)/2.0d0,  ramda1cc, Acc, 1/(2*deltacc), c1ccc, c2ccc,
     & c3ccc, c4, c5
!# BBB

      write(101,'(3a10, 17e15.6)') Belem, Belem, Belem, qmmm, pmmm, 
     & hmmm, etamm, beta_ters, ramda2mm, Bmm, (r1mm+r2mm)/2.0d0, 
     & (r2mm-r1mm)/2.0d0,  ramda1mm, Amm, 1/(2*deltamm), c1mmm, c2mmm,
     & c3mmm, c4, c5
!# ABB

      write(101,'(3a10, 17e15.6)') Aelem, Belem, Belem, qcmm, pcmm, 
     & hcmm, etacm, beta_ters, ramda2cm, Bcm, (r1cm+r2cm)/2.0d0, 
     & (r2cm-r1cm)/2.0d0,  ramda1cm, Acm, 1/(2*deltacm), c1cmm, c2cmm,
     & c3cmm, c4, c5
!# ABA

      write(101,'(3a10, 17e15.6)') Aelem, Belem, Aelem, qcmc, pcmc, 
     & hcmc, etacm, beta_ters, ramda2cm, Bcm, (r1cm+r2cm)/2.0d0, 
     & (r2cm-r1cm)/2.0d0,  ramda1cm, Acm, 1/(2*deltacm), c1cmc, c2cmc,
     & c3cmc, c4, c5
!# AAB

      write(101,'(3a10, 17e15.6)') Aelem, Aelem, Belem, qccm, pccm, 
     & hccm, etacc, beta_ters, ramda2cc, Bcc, (r1cc+r2cc)/2.0d0, 
     & (r2cc-r1cc)/2.0d0,  ramda1cc, Acc, 1/(2*deltacc), c1ccm, c2ccm,
     & c3ccm, c4, c5
!# BAA

      write(101,'(3a10, 17e15.6)') Belem, Aelem, Aelem, qmcc, pmcc, 
     & hmcc, etamc, beta_ters, ramda2mc, Bmc, (r1mc+r2mc)/2.0d0, 
     & (r2mc-r1mc)/2.0d0,  ramda1mc, Amc, 1/(2*deltamc), c1mcc, c2mcc,
     & c3mcc, c4, c5
!# BBA

      write(101,'(3a10, 17e15.6)') Belem, Belem, Aelem, qmmc, pmmc, 
     & hmmc, etamm, beta_ters, ramda2mm, Bmm, (r1mm+r2mm)/2.0d0, 
     & (r2mm-r1mm)/2.0d0,  ramda1mm, Amm, 1/(2*deltamm), c1mmc, c2mmc,
     & c3mmc, c4, c5
!# BAB

      write(101,'(3a10, 17e15.6)') Belem, Aelem, Belem, qmcm, pmcm, 
     & hmcm, etamc, beta_ters, ramda2mc, Bmc, (r1mc+r2mc)/2.0d0, 
     & (r2mc-r1mc)/2.0d0, ramda1mc, Amc, 1/(2*deltamc), c1mcm, c2mcm,
     & c3mcm, c4, c5
      close(11)
      close(101)

      end program
