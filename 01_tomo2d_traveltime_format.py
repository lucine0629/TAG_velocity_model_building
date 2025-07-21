### Script:  01_tomo2d_traveltime_format.py
### Purpose: Prepare for traveltime pick file to run TOMO2D velocity modelling
###          (1) Reduced to observed traveltime file
###          (2) Formatting the file
###
### Author:  S.Y. Lai



####################
### set up
####################
import pandas as pd
import os

out_dir = 'C:/Users/syll1n21/Documents/Python_Scripts/sem4/line03/'

###############################
### ASSIGN HEADER INFORMATION
###############################
sn = 2
## line01
# obxseq = [2, 4, 10, 12, 14, 16]
# offseq = [12.7279, 13.508, 14.246, 15.198, 16.107, 16.939]
# obxdepth = [2.91, 2.881, 2.847, 2.821, 2.568, 2.468]


## line03
obxseq = [7, 5, 11, 13, 17]
offseq = [4.614, 5.436, 6.545, 7.635, 8.825]
obxdepth = [2.950, 2.862, 2.801, 2.556, 2.356]
obx = f"{obxseq[sn-1]:0>{2}}"
off_header = offseq[sn-1]
obx_dep = obxdepth[sn-1]
print('obx',obx,'offset',off_header,'depth',obx_dep)


#############################################
### READ ttpicks stored in the spreadsheet
#############################################
sheet = 'obx'+str(obx)+'dc_east'
tmp = pd.read_excel('sem4b_03_traveltime.xlsx', sheet_name=sheet, dtype=str, usecols=["shot","time","error","code"])
tmp1 = tmp.values.tolist()

shotdist = open('sem4b_03_obx'+str(obx)+'off.txt', "r")
# shotdist = open('sem4a_01_obx14off.txt', "r")
data = shotdist.read().split('\n')
output = 'sem4b_03_obx' + str(obx) + '_dctt_east.txt'


offset1 = data[0].split(',')
offsetori = float(offset1[1])/1000

print(offsetori)

data1 = data[1].split(',')
print(data1[3])



### Check existence of the output file. If output file exists, remove it.
if os.path.isfile(os.path.join(out_dir,output)):
    os.remove(os.path.join(out_dir,output))
    
    
    
    
    
###########################################################################################
#### Loop searching for the same shot number between offset and pick files,
#### and assign the shot distance to the the traveltime pick entry in TOMO2D format.
###########################################################################################
for a, element in enumerate(tmp1):
    shot = tmp1[a]
    shotno = shot[1]
    redtime = round(float(shot[0]), 5)
    error = round(float(shot[3])/1000, 3)
    code = shot[2]
    
    
    for a1, element1 in enumerate(data):
        data1 = data[a1].split(',')
        shotno1 = data1[0]
        offset = abs(float(data1[1]))
        realoff = round(float(data1[3])/1000, 3)
        
        shotdist = round((offsetori + realoff), 3)
        obstt = round(redtime + float(offset/1000/6.5), 3)
    
        if shotno == shotno1:            
            #write shot distance into new txt 
            with open(os.path.join(out_dir,output), 'a') as f:
                outp = str('r')+str(' ')+str(shotdist)+str(' ')+str('2.50')+str(' ')+str(code)+str(' ')+str(redtime)+str(' ')+str(error)
                f.write("%s\n" % outp)





with open(os.path.join(out_dir,output), 'r') as original:
    dat = original.read()
with open(os.path.join(out_dir,output), 'w') as modified:
    header = str('s')+str(' ')+str(off_header)+str(' ')+str(obx_dep)+str(' ')+str(a+1)
    modified.write(header + "\n" + dat)




###################################
## print header, number of picks
###################################
print(offset, shotdist, redtime, obstt)
print(a+1,a1, 'travel time picks')

