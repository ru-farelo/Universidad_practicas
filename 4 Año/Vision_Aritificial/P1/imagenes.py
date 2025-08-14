import matplotlib.pyplot as plt
import numpy as np
import pylab as plt
import cv2

## Procesado de Imagenes (Cargar ,guardar, mostrar)##

# La imagen de entrada es entre 0 255 y se normaliza a 0 1
# guarda la imagen en el directorio especificado
def save_image(image, output='output_img.png'):
    cv2.imwrite(output, image * 255) # Guardar la imagen en el rango [0,255] Desnormalizar

# carga la imagen en escala de grises
def load_image(path):
    input_image = cv2.imread(path, 0) # Cargar la imagen en escala de grises
    input_image = input_image.astype(float) # Convertir a float
    input_image /= 255 # Normalizar la imagen a [0,1]
    return input_image

# Función para mostrar las imágenes de entrada y salida
def display_images(input_image, output_image, output_image_cv2):
    fig, ax = plt.subplots(1, 3, figsize=(12, 4))  # Crear un grid 1x3 para las imágenes
    fig.suptitle('Comparación de Imágenes', fontsize=16)

    # Mostrar imagen de entrada
    ax[0].imshow(input_image, cmap='gray' ,vmin=0, vmax=1)   
    ax[0].axis('off')
    ax[0].set_title('Imagen de Entrada')

    # Mostrar imagen de salida
    ax[1].imshow(output_image, cmap='gray',vmin=0, vmax=1)
    ax[1].axis('off')
    ax[1].set_title('Imagen de Salida Mia')

    # Mostrar imagen de salida de cv2
    ax[2].imshow(output_image_cv2, cmap='gray',vmin=0, vmax=1)
    ax[2].axis('off')
    ax[2].set_title('Imagen de Salida (cv2)')

    plt.tight_layout()
    plt.show()
  

# muestra el histograma de la imagen de entrada y salida
def plot_histogram(input_label, output_label, input_image, output_image):
    fig, ax = plt.subplots(1, 2, figsize=(12, 4))  # Crear un grid 1x2 para los histogramas
    fig.suptitle('Histogramas', fontsize=16)

    # Mostrar histograma de imagen de entrada el ejex es el rango de pixeles
    ax[0].hist(input_image.ravel(), bins=256, range=(0.0, 1.0), fc='k', ec='k')
    ax[0].set_title('Histograma de ' + input_label)
    ax[0].set_xlim([0.0, 1.0])

    # Mostrar histograma de imagen de salida
    ax[1].hist(output_image.ravel(), bins=256, range=(0.0, 1.0), fc='k', ec='k')
    ax[1].set_title('Histograma de ' + output_label)
    ax[1].set_xlim([0.0, 1.0])

    plt.tight_layout()
    plt.show()

# Funcion para mostrar en un plano los valores en forma gaussiana
def plot_gaussian(values, sigma):
    x = np.arange(-3*sigma, 3*sigma, 0.1) # Rango de valores
    y = np.exp(-x**2 / (2*sigma**2)) / (sigma * np.sqrt(2*np.pi))
    plt.plot(x, y)
    plt.title('Kernel Gaussiano 1D')
    plt.show()

## Funcion para mostrar en un plano los valores en forma gaussiana 3d  
def plot_gaussian_3d(values): 
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    x = np.arange(-3, 3, 0.1)
    y = np.arange(-3, 3, 0.1)
    x, y = np.meshgrid(x, y)
    z = np.exp(-(x**2 + y**2) / 2) / (2 * np.pi)
    ax.plot_surface(x, y, z, cmap='viridis')
    plt.title('Kernel Gaussiano 2D')
    plt.show()


## Display de imagenes para gradientes

def display_images_gradient(input_image, output_image, output_image2, output_image_cv2, output_image_cv2_2):
    fig, ax = plt.subplots(2, 3, figsize=(12, 8))  # Crear un grid 2x3 para las imágenes
    fig.suptitle('Comparación de Imágenes', fontsize=16)

    # Mostrar imagen de entrada
    ax[0, 0].imshow(input_image, cmap='gray', vmin=0, vmax=1)
    ax[0, 0].axis('off')
    ax[0, 0].set_title('Imagen de Entrada')

    # Mostrar magnitud del gradiente
    ax[0, 1].imshow(output_image, cmap='gray', vmin=0, vmax=1,)
    ax[0, 1].axis('off')
    ax[0, 1].set_title('Magnitud del Gradiente')

    # Mostrar dirección del gradiente
    ax[0, 2].imshow(output_image2, cmap='hsv', vmin=0, vmax=1)
    ax[0, 2].axis('off')
    ax[0, 2].set_title('Dirección del Gradiente')

    # Mostrar magnitud del gradiente (cv2)
    ax[1, 1].imshow(output_image_cv2, cmap='gray', vmin=0, vmax=1)
    ax[1, 1].axis('off')
    ax[1, 1].set_title('Magnitud del Gradiente (cv2)')

    # Mostrar dirección del gradiente (cv2)
    ax[1, 2].imshow(output_image_cv2_2, cmap='hsv', vmin=0, vmax=1)
    ax[1, 2].axis('off')
    ax[1, 2].set_title('Dirección del Gradiente (cv2)')
    plt.tight_layout()

    plt.show()