#!/bin/sh
#PBS -l select=1:ncpus=1:mpiprocs=1:ompthreads=1:jobtype=gpup:ngpus=1
#PBS -l walltime=00:30:00

if [ ! -z "${PBS_O_WORKDIR}" ]; then
  cd "${PBS_O_WORKDIR}"
fi

. /local/apl/lx/intel2018update4/parallel_studio_xe_2018/psxevars.sh intel64

LAMMPSDIR=/local/apl/lx/lammps29Oct20-CUDA
LAMMPSBIN=lmp_rccs-cuda
LAMMPS=${LAMMPSDIR}/bin/${LAMMPSBIN}

. ${LAMMPSDIR}/etc/profile.d/lammps.sh

export PATH=/local/apl/lx/cuda-11.1/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=${LAMMPSDIR}/lib64:/local/apl/lx/cuda-11.1/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

N_MPI=1
N_OMP=1
N_GPU=1

##############################################################################
mpirun -np ${N_MPI} $LAMMPS -sf hybrid gpu omp \
                            -pk omp ${N_OMP} \
                            -pk gpu ${N_GPU}  \
                            -in in.tersoff_mod_gpu
