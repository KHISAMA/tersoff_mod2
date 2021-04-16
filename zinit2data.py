import numpy as np
import sys

with open("zinit_converted.dat", 'r') as datafile:
    data0=datafile.readlines()

#print(data0[1])
    
zlx=float(data0[1])*1e10
zly=float(data0[2])*1e10
zlz=float(data0[3])*1e10

nmc=int(data0[4])

cdata=np.genfromtxt(data0[5:5+nmc*2])
cdata=cdata.reshape([-1,3])

cpos=cdata[0:nmc,:]*1e10
cvel=cdata[nmc:nmc*2,:]*1e10/1e12

#print(cdata)
#print(cdata.shape)
#print(data0[5+nmc*2])

nmm=int(data0[5+nmc*2])

mdata=np.genfromtxt(data0[5+nmc*2+1:5+nmc*2+1+2*nmm])
mdata=mdata.reshape([-1,3])

#print(mdata)
#print(mdata.shape)

mpos=mdata[0:nmm,:]*1e10
mvel=mdata[nmm:nmm*2,:]*1e10/1e12 # angstrom per picosecond

id=np.arange(nmc+nmm)+1
#id=np.arange(nmm)+1

id=id.reshape(-1,1)

atom_c=np.ones(nmc)
atom_m=np.ones(nmm)*2
atom_type=np.hstack( (atom_c,atom_m) )
#atom_type=atom_m

atom_type=atom_type.reshape([-1,1])

#print(atom_type)
pos = np.vstack( (cpos, mpos) )
#pos = mpos

#print(id.shape)
#print(atom_type.shape)
#print(pos.shape)

pos = np.hstack( (id, atom_type, pos) ) 


#print(pos)

vel=np.hstack( (id, np.vstack( (cvel, mvel) ) ) )
#vel=np.hstack( (id, mvel) )  

#print(vel)

print("# converted from zinit_converted.dat")
print(" ")
print( str(nmm+nmc) + "atoms")
print( "2 atom types" )
print(" ")
print( str(-zlx/2) + "  " + str(zlx/2) + " xlo xhi")
print( str(-zly/2) + "  " + str(zly/2) + " ylo yhi")
print( str(-zlz/2) + "  " + str(zlz/2) + " zlo zhi")
print(" ")
print("Masses")
print(" ")
print("1  12.01") # mass for C atom
print("2  58.93") # mass for Co atom
print(" ")
print("Atoms")
print(" ")
np.savetxt(sys.stdout, pos, fmt=['%.0f', '%.0f', '%.14e', '%.14e', '%.14e'])
print(" ")
print("Velocities")
print(" ")
np.savetxt(sys.stdout, vel, fmt=['%.0f', '%.14e', '%.14e', '%.14e'])
