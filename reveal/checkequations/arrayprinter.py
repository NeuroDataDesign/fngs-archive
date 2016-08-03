from PIL import Image
import cv2
import numpy as np
from matplotlib import pyplot as plt

img = Image.open('mysolution.png')
print(list(img.getdata()))
