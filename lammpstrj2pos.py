import numpy as np
import sys


outfilename="pos.dat"
nmc=1000
flag_header=False
Tstep0=0.0005 # [ps] = 0.5 [fs]

nframe_dummy="NUMBER_OF_FRAMES"

iframe=0

with open(outfilename,"w"):pass

with open("pos.lammpstrj", 'r') as datafile:
    header=[]
    for i in range(0,9):
        data0=datafile.readline()
        data0=data0.replace('\n','')
        header.append(data0)
    
    #print(header)
    
    Time0=float(header[1])
    natom=int(header[3])
    
    cells=np.loadtxt(header[5:8])
    #print(cells)
    
    vlx=abs(cells[0,0]-cells[0,1])
    vly=abs(cells[1,0]-cells[1,1])    
    vlz=abs(cells[2,0]-cells[2,1])
    

        

    while True:
        iframe=iframe + 1
        print("iframe = ", iframe )
        pos0=[]
        for i in range(0,natom):
            data0=datafile.readline()
            data0=data0.replace('\n','')
            pos0.append(data0)
        
        pos=np.genfromtxt(pos0)
        
        #print(pos.shape)
        
        cpos0=pos[ pos[:,1]==1 ]
        cpos0=cpos0[np.argsort(cpos0[:,0])]
        nmc_current=cpos0.shape[0]
        #print(nmc_current)
        
        cpos=np.ones([nmc,3])*0.99
        cpos[0:nmc_current,:]=cpos0[:,2:5]
        cpos[:,0]=cpos[:,0]*vlx+cells[0,0]
        cpos[:,1]=cpos[:,1]*vly+cells[1,0]
        cpos[:,2]=cpos[:,2]*vlz+cells[2,0]  
        
        mpos0=pos[ pos[:,1]==2 ]
        mpos0=mpos0[np.argsort(mpos0[:,0])]
        nmm_current=mpos0.shape[0]
        #print(nmm_current)
        nmm=nmm_current
        
        mpos=mpos0[:,2:5]
        mpos[:,0]=mpos[:,0]*vlx+cells[0,0]
        mpos[:,1]=mpos[:,1]*vly+cells[1,0]
        mpos[:,2]=mpos[:,2]*vlz+cells[2,0]
        
        if( np.max(mpos[:,0]) > 0.25*vlx and np.min(mpos[:,0]) < -0.25*vlx ):
            mpos[ mpos[:,0] < 0 , 0] = mpos[ mpos[:,0] < 0 , 0] + vlx
            
        if( np.max(mpos[:,1]) > 0.25*vly and np.min(mpos[:,1]) < -0.25*vly ):
            mpos[ mpos[:,1] < 0 , 1] = mpos[ mpos[:,1] < 0 , 1] + vly
            
        if( np.max(mpos[:,2]) > 0.25*vlz and np.min(mpos[:,2]) < -0.25*vlz ):
            mpos[ mpos[:,2] < 0 , 2] = mpos[ mpos[:,2] < 0 , 2] + vlz            
        
        cmm=mpos.mean(axis=0)
        
        cpos[0:nmc_current,:]=cpos[0:nmc_current,:]-cmm
        mpos=mpos-cmm
        
        
        header=[]
        for i in range(0,9):
            data0=datafile.readline()
            data0=data0.replace('\n','')
            header.append(data0)
        
        try:
            Time1=float(header[1])
            Tstep=(Time1-Time0)*Tstep0 #[ps]
        except:
            print("END OF INPUT")
        
        if( not(flag_header) ):
            with open(outfilename, 'a') as outfile:
                outfile.writelines("1\n")
                outfile.writelines(str(nmc)+"\n")
                outfile.writelines(str(nmm)+"\n")
                outfile.writelines(nframe_dummy + "\n")
                outfile.writelines( str(vlx)+"  "+str(vly)+"  "+str(vlz) + "\n" )
                outfile.writelines( str(Time0) + "\n" )
                outfile.writelines( str(Tstep) + "\n" )
                flag_header=True
        
        with open(outfilename, 'a') as outfile:
            np.savetxt(outfile, cpos)
            np.savetxt(outfile, mpos)
        
        if not data0:
            break
    
#with open(outfilename, mode='r') as outfile:
#    filedata=outfile.read()
#    filedata=filedata.replace(nframe_dummy,str(iframe))
#    outfile.write(filedata)
    
        #if line.find(nframe_dummy) != 1:
        #    line = line.replace(nframe_dummy, str(iframe))
        #    #outfile.write(str(iframe))
        #    #print(str(iframe))
        #    print("NFRAME REFRESHED")
        #outfile.write(line)