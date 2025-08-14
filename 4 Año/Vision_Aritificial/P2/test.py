from p2 import *
import cv2
import numpy as np
import matplotlib.pyplot as plt



def load_image(path):
    return cv2.imread(path)

def test_filter_señales(path):
    InImage = load_image(path)
    if InImage is None:
        print("Error: No se pudo cargar la imagen.")
        return
    
    # Preprocesar la imagen
    mask_red, mask_blue ,_,_= filter_señales(InImage)
    
    # Mostrar la imagen de entrada y las máscaras de rojo y azul en un mismo bloque
    plt.figure(figsize=(30, 25))
    
    plt.subplot(1, 3, 1)
    plt.imshow(cv2.cvtColor(InImage, cv2.COLOR_BGR2RGB))
    plt.title('Imagen de entrada')
    
    plt.subplot(1, 3, 2)
    plt.imshow(mask_red, cmap='gray')
    plt.title('Máscara de rojo')
    
    plt.subplot(1, 3, 3)
    plt.imshow(mask_blue, cmap='gray')
    plt.title('Máscara de azul')
    
    plt.show()


def test_filter_señales_white_black(path):
    InImage = load_image(path)
    if InImage is None:
        print("Error: No se pudo cargar la imagen.")
        return
    
    # Preprocesar la imagen
    _, _ ,mask_white,mask_black= filter_señales(InImage)
    
    # Mostrar la imagen de entrada y las máscaras de rojo y azul en un mismo bloque
    plt.figure(figsize=(30, 25))
    
    plt.subplot(1, 3, 1)
    plt.imshow(cv2.cvtColor(InImage, cv2.COLOR_BGR2RGB))
    plt.title('Imagen de entrada')
    
    plt.subplot(1, 3, 2)
    plt.imshow(mask_white, cmap='gray')
    plt.title('Máscara de rojo')
    
    plt.subplot(1, 3, 3)
    plt.imshow(mask_black, cmap='gray')
    plt.title('Máscara de negro')
 
    
    plt.show()

def test_filter_classify_señales(path):
    InImage = load_image(path)
    if InImage is None:
        print("Error: No se pudo cargar la imagen.")
        return

    # Preprocesar la imagen
    mask_red, mask_blue,mask_white,mask_black = filter_señales(InImage)

    # Clasificar la señal
    output_image = classify_señales(InImage, mask_red, mask_blue,mask_white,mask_black)

    # Mostrar la imagen de entrada y la imagen de salida en un mismo bloque
    plt.figure(figsize=(30, 25))

    plt.subplot(1, 2, 1)
    plt.imshow(cv2.cvtColor(InImage, cv2.COLOR_BGR2RGB))
    plt.title('Imagen de entrada')

    plt.subplot(1, 2, 2)
    plt.imshow(cv2.cvtColor(output_image, cv2.COLOR_BGR2RGB))
    plt.title('Imagen de salida')

    plt.show()
