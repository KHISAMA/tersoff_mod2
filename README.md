pair tersoff_mod2
==============

_Hisama Kaoru, Ryo Yoshikawa, Ikuma Kohata_

LAMMPS implementation of the interatomic potential of C-Fe and C-Co system for single-walled carbon nanotube growth by CVD synthesis.  

The related works have published in Journal of Physical Chemistry C and ACS Nano:

Kaoru Hisama, Ryo Yoshikawa, Teppei Matsuo, Takuya Noguchi, Tomoya Kawasuzuki, Shohei Chiashi, and Shigeo Maruyama. 
Growth analysis of single-walled carbon nanotubes based on interatomic potential by molecular dynamics simulation.
The Journal of Physical Chemistry C, 122(17):9648–9653, 2018.
DOI: <https://doi.org/10.1021/acs.jpcc.7b12687>

Ryo Yoshikawa, Kaoru Hisama, Hiroyuki Ukai, Yukai Takagi, Taiki Inoue, Shohei Chiashi, and Shigeo Maruyama.
Molecular dynamics of chirality definable growth of single-walled carbon nanotubes. ACS Nano, 13(6):6506–6512, 2019.
DOI: <https://doi.org/10.1021/acsnano.8b09754>



Installation
------------

The `pair_style tersoff/mod2` are included
in the LAMMPS distribution.

To compile:

    cp 'tersoff_mod2.cpp' 'lammps/src/MANYBODY'
    cp 'tersoff_mod2.h' 'lammps/src/MANYBODY'
    cd 'lammps/src'
    make yes-MANYBODY
    make 'machine'

Note
-----

We have tested this implementation in LAMMPS 23 Jun 2022 version.  
It may not work in some environments/versions.


