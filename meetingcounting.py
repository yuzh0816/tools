import pandas as pd
import os
from PIL import Image
from paddleocr import PaddleOCR, draw_ocr

mymap=[]
mate=["张三","李四","王五","赵六"]#需要统计的成员列表

for j in range(len(mate)):
    mymap.append(False)

#开启OCR
ocr = PaddleOCR(enable_mkldnn=True,use_angle_cls=False, use_gpu=True,use_tensorrt=True,
                lang="ch")  # need to run only once to download and load model into memory

img_path = '***Location***'

file_dir = r'***Location***'
for root,dirs,files in os.walk(file_dir):
    for file in files:
        img_path=file_dir+file
        if file=="dic.py" or file=="ocr.py" or file=="result.csv":
            continue
        result = ocr.ocr(img_path, cls=True)
        txts = [line[1][0] for line in result]
        for i in range(len(txts)):
            #print(txts[i])
            for j in range(len(mate)):
                if txts[i].find(mate[j])>=0:
                    mymap[j]=True

print("未到者名单如下：")
for i in range(len(mate)):
    if mymap[i]==False:
        print(mate[i])
