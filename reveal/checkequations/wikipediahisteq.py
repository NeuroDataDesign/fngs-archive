from PCV import tools
from PIL import Image
from numpy import *

def histeq(im,nbr_bins=256):
    """    Histogram equalization of a grayscale image. """
    
    # get image histogram
    imhist,bins = histogram(im.flatten(),nbr_bins,normed=True)
    cdf = imhist.cumsum() # cumulative distribution function
    cdf = 255 * cdf / cdf[-1] # normalize
    
    # use linear interpolation of cdf to find new pixel values
    im2 = interp(im.flatten(),bins[:-1],cdf)
    
    return im2.reshape(im.shape), cdf

im = array(Image.open('wikipediaexample.png').convert('L'))
im2,cdf = histeq(im)

histeqimage = Image.fromarray(im2)
histeqimage = histeqimage.convert('RGB')
histeqimage.save("mysolution.png")


