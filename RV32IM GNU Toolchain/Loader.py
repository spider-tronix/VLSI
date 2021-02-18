def file_write(list_object,file_object):
    for i in range(len(list_object)):
        file_object.write(list_object[i])
        file_object.write("\n")
    file_object.close()

## Add file path here
filepath = "O:\compile\Branch.txt"
file = open(filepath)
mem_depth = 1024
data = file.read()
data = data.split("\n")
index = 0
for i in range(len(data)):
    status=data[i].find('main')
    if(status == 10):
        index = i
        break

j=index+1
instructions = list()
while(data[j]!=''):
    instructions.append(data[j])
    j=j+1

opcodes = list()
for i in range(len(instructions)):
    opcodes.append(instructions[i].split('\t')[1])
    opcodes[i] = opcodes[i].replace(' ','')

imem = open("Imem.txt","w")
file_write(opcodes,imem)


for i in range(len(data)):
    status=data[i].find('.data')
    if(status == 10):
        index = i
        break
j = index + 1
dmem_ = list()
while(data[j]!=''):
    dmem_.append(data[j])
    j=j+1

print(dmem_)
addr = list()
data = list()
for i in range(len(dmem_)):
    temp = dmem_[i].replace(":",' ')
    addr.append(temp.split("\t")[0])
    data.append(temp.split("\t")[1])
    addr[i] = addr[i].replace(' ','')
    addr[i] = int(addr[i],16)
    data[i] = data[i].replace(' ','')



dmem0 = ['0']*int(mem_depth/4)
dmem1 = ['0']*int(mem_depth/4)
dmem2 = ['0']*int(mem_depth/4)
dmem3 = ['0']*int(mem_depth/4)

for i in range(len(addr)):
    if(addr[i]%4==0):
        dmem0[int(addr[i]/4)] = data[i][2:4]
        dmem1[int(addr[i]/4)] = data[i][0:2]
    elif(addr[i]%4==1):
        dmem1[int(addr[i]/4)] = data[i][2:4]
        dmem2[int(addr[i]/4)] = data[i][0:2]
    elif(addr[i]%4==2):
        dmem2[int(addr[i]/4)] = data[i][2:4]
        dmem3[int(addr[i]/4)] = data[i][0:2]
    elif(addr[i]%4==3):
        dmem3[int(addr[i]/4)] = data[i][2:4]
        dmem0[int(addr[i]/4)] = data[i][0:2]

dmem_file_0 = open("dmem0.txt","w")
dmem_file_1 = open("dmem1.txt","w")
dmem_file_2 = open("dmem2.txt","w")
dmem_file_3 = open("dmem3.txt","w")

file_write(dmem0,dmem_file_0)
file_write(dmem1,dmem_file_1)
file_write(dmem2,dmem_file_2)
file_write(dmem3,dmem_file_3)

        




