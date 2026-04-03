# 该程序的作用:
#     在使用3DMax生成.obj文件之后可以使用该程序来绘制OBJ文件中的顶点,以此来判断建模的角度是否正确
#     该程序需要numpy模块和matplotlib模块,如果没有需要自行安装
import numpy as np
import math

# 读取一个3dmax生成的.obj文件,并解析得到其中的顶点数据,返回到调用处
def readVertex(fname):
    f = open(fname)   #打开数据文件文件
    lines = f.readlines()   #把全部数据文件读到一个列表lines中
    
    retMat = np.arange(3)
    
    for line in lines:   #把lines中的数据逐行读取出来
        list = line.strip('\n').split(' ')   #处理逐行数据：strip表示把头尾的'\n'去掉，split表示以空格来分割行数据，然后把处理后的行数据返回到list列表中
        if list[0] == 'v' :
            # print (list[1], list[2], list[3], list[4])  #这里的list[1]是一个空格
            tmp = np.array([list[2], list[3], list[4] ], dtype=np.float)
            retMat = np.vstack((retMat, tmp))
    # print (retMat)
    return retMat[1:]

def main():
    filename = str(input("Please enter file name: "))
    mat = readVertex(filename)
    # np.set_printoptions(threshold=np.inf)   #这一句可以保证当矩阵数据量较大的时候打印所有的数据
    print (mat)

if __name__ == '__main__':
    main()

