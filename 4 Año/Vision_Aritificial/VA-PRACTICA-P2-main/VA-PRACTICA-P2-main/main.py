import os
import cv2
from test import *

def main():
    for i in range(1, 13):
        filename = f'Material Señales/{i}.ppm'
        test_filter_señales(filename)
        #test_filter_señales_white_black(filename)
        test_filter_classify_señales(filename)

if __name__ == '__main__':
    main()