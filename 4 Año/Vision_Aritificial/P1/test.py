from p1 import *
from imagenes import *
import cv2
from skimage import io

### TEST adjust intensity Algoritmo de alteración del rango dinámico ###

def test_intensity_adjustment(path, alpha, beta):
    input_image = load_image(path)
    # Ajustar la intensidad de la imagen
    output_image = adjustIntensity(input_image, [], [alpha, beta])
    # libreria que ajusta la intensidad de la imagen en cv2 basicamente ajuste de intensidad utilizando cv2.normalize
    output_image_cv2 = cv2.normalize(input_image, None, alpha, beta, norm_type=cv2.NORM_MINMAX)
    display_images(input_image, output_image, output_image_cv2)
    plot_histogram('Input Image', 'Output Image', input_image, output_image)
    save_image(output_image, 'imagenes_output/adjust_intensity_2.png')


### Test equalize intensity ecualización de histograma ###

def test_equalize_intensity(path):
    input_image = load_image(path)
    # Ajustar la intensidad de la imagen para mejorar el contraste y aplicar la ecualización de histograma
    output_image_intensity = adjustIntensity(input_image)
    output_image = equalizeIntensity(output_image_intensity) # Por defecto los nbin son 256
    ## Ecualización de histograma de cv2 de libreria
    output_image_cv2 = cv2.equalizeHist((input_image * 255).astype(np.uint8)) / 255 
    display_images( input_image, output_image, output_image_cv2)
    plot_histogram('output_image_intensity', 'outImage', output_image_intensity, output_image)
    save_image(output_image, 'imagenes_output/equalize_intensity.png')


###  Test filterImage Filtrado espacial mediante convolución ###

def test_filter_image(path, option):
    input_image = load_image(path)
    
    if option == 1:
        # Filtro promedio
        kernel = np.array([[1, 1, 1], [1, 1, 1], [1, 1, 1]]) / 9
        output_image = filterImage(input_image, kernel)
        
        # Aplicación del filtro en OpenCV
        output_image_cv2 = cv2.filter2D(input_image, -1, kernel)
        
        # Mostrar y guardar la imagen resultante
        display_images(input_image, output_image, output_image_cv2)
        save_image(output_image, 'imagenes_output/filter_image.png')
    
    elif option == 2:
        # Código para la segunda opción
        # Comprobar que el kernel funcione correctamente
        kernel = np.array([[0, 0, 0], [0, 1, 0], [0, 0, 0]])
        kernel = load_image('imagenes/morph.png')
        input_image = np.zeros((513, 513))
        input_image[256, 256] = 1
        output_image = filterImage(input_image, kernel)
        output_image_cv2 = cv2.filter2D(input_image, -1, kernel)
        display_images(input_image, output_image, output_image_cv2)
        save_image(output_image, 'imagenes_output/filter_image2.png')
    else:
        # Que la imagen sea un array y el kernel que tenga mas importancia el pixel central
        # Imagen de prueba en formato uint8
        inImage2 = np.array([[4, 3, 2], [1, 0, 1], [2, 3, 4]], dtype=np.uint8)
        
        # Definir el kernel de filtro
        kernel = np.array([[1,1,1], [1,-4,1], [1,1,1]], dtype=np.float32)

        # Aplicar filtro con la función propia
        output_image = filterImage(inImage2, kernel)
        
        # Aplicar filtro con OpenCV
        output_image_cv2 = cv2.filter2D(inImage2, -1, kernel)
        
        # Mostrar y guardar resultados
        display_images(inImage2, output_image, output_image_cv2)
        save_image(output_image, 'imagenes_output/filter_image3.png')




### Test Filtro gaussiando de 1D ###

def test_gaussian_filter_1D(sigma):
    # kernel mio
    kernel = gaussKernel1D(sigma)
    # Kernel de cv2
    kernel_cv2 = cv2.getGaussianKernel((int)(2*(np.ceil(3*sigma))+1), sigma)
    # Mostrar kernel para ver si hace una forma gaussiana en 1D
    print(kernel)
    print(kernel_cv2)
    plot_gaussian(kernel, sigma)
    

### Test Filtro gaussiando de 2D ### 

def test_gaussian_filter_2D(sigma,path):
    
    input_image = load_image(path)
    # Imagene de salida mia
    output_image = gaussianFilter(input_image,sigma)
    # Imagen de salida de cv2
    N = (int)(2*(np.ceil(3*sigma))+1)
    kernel = (N,N)
    output_image_cv2 = cv2.GaussianBlur(input_image, kernel, sigma)
    display_images(input_image, output_image, output_image_cv2)
    plot_gaussian_3d(kernel) 
    save_image(output_image, 'imagenes_output/gauss_filter.png')
    
### Test Filtro Mediana ###
def test_median_filter(path,filterSize):
    input_image = load_image(path)
    ## Imagen de salida mia
    output_image = medianFilter(input_image,filterSize)
    ## Imagen de salida de cv2
    output_image_cv2 = cv2.medianBlur((input_image * 255).astype(np.uint8), filterSize) / 255
    display_images(input_image, output_image, output_image_cv2)
    save_image(output_image, 'imagenes_output/median_filter.png')

### 3.3. Operadores morfológicos ###

### Operadores morfologicos de erosion, dilatacion, apertura y cierre para imagenes binarias

def test_morphological_erode(path):
    input_image = load_image(path)
    #SE = np.array([[1, 1, 1] ]) 
    SE = np.array([[1, 1, 1], [1, 1, 1], [1, 1, 1]])
    # Aumentar el tamaño de la imagen
    output_image = erode(input_image, SE)

    output_image_cv2 = cv2.erode((input_image * 255).astype(np.uint8), SE, iterations=1) / 255
    display_images(input_image, output_image, output_image_cv2)
    save_image(output_image, 'imagenes_output/morphological_erode.png')

def test_morphological_dilate(path):
    input_image = load_image(path)
    # SE = np.array([[1, 1, 1] ])
    SE = np.array([[1, 1, 1], [1, 1, 1], [1, 1, 1]])
    output_image = dilate(input_image, SE)
    output_image_cv2 = cv2.dilate((input_image * 255).astype(np.uint8), SE, iterations=1) / 255
    display_images(input_image, output_image, output_image_cv2)
    save_image(output_image, 'imagenes_output/morphological_dilate.png')

def test_morphological_opening(path):
    input_image = load_image(path)
    # SE = np.array([[1, 1, 1] ])
    SE = np.array([[1, 1, 1], [1, 1, 1], [1, 1, 1]])
    output_image = opening(input_image, SE)
    # Imagen de salida de cv2
    output_image_cv2 = cv2.morphologyEx((input_image * 255).astype(np.uint8), cv2.MORPH_OPEN, SE,iterations=1) / 255
    display_images(input_image, output_image, output_image_cv2)
    save_image(output_image, 'imagenes_output/morphological_opening.png')


def test_morphological_closing(path):
    input_image = load_image(path)
    SE = np.array([[1, 1, 1], [1, 1, 1], [1, 1, 1]])
    output_image = closing(input_image, SE)
    output_image_cv2 = cv2.morphologyEx((input_image * 255).astype(np.uint8), cv2.MORPH_CLOSE, SE,iterations=1) / 255
    display_images(input_image, output_image, output_image_cv2)
    save_image(output_image, 'imagenes_output/morphological_closing.png')


## Test Fill ##
def test_fill(path):
    input_image = load_image(path)
    # Elemento estructurante en forma de cruz
    #SE = np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]])
    SE = np.array([[1, 1, 1], [1, 1, 1], [1, 1, 1]])
    
    # Semillas en el (0,0) y en el (25,25)
    seeds = [(0, 0), (25, 25)]
    
    # Pasar las semillas combinadas a la función fill
    output_image = fill(input_image, seeds, SE)
    
    # Usar la primera semilla para cv2.floodFill
    output_image_cv2 = cv2.floodFill((input_image * 255).astype(np.uint8), None, (seeds[0][1], seeds[0][0]), 255)[1] / 255
    
    display_images(input_image, output_image, output_image_cv2)
    save_image(output_image, 'imagenes_output/fill.png')

##########################################################################
# Función para tener en cuenta valores positivos y negativos
def normalize(image):
    # Calcular el valor mínimo y máximo de la imagen
    min_val = np.min(image)
    max_val = np.max(image)

    # Evitar la división por cero si max_val == min_val
    if max_val - min_val == 0:
        return np.zeros_like(image)  # Retornar una imagen de ceros si todos los valores son iguales

    # Normalizar la imagen a un rango de 0 a 1
    normalized_image = (image - min_val) / (max_val - min_val)
    return normalized_image

##########################################################################

### Detección de bordes Gradient ###

# Preguntar como comprobar si va bien
def test_gradient (path, option):
    inImage = load_image(path)
    
    # Mapping options to gradient operators
    operators = {
        1: 'Roberts',
        2: 'CentralDiff',
        3: 'Prewitt',
        4: 'Sobel'
    }
    operator = operators[option]
    gX, gY = gradientImage(inImage, operator)

    ## Usar cv2 para comparar
    # Sobel por ejemplo
    gX_cv2 = cv2.Sobel((inImage * 255).astype(np.uint8), cv2.CV_64F, 1, 0, ksize=3)
    gY_cv2 = cv2.Sobel((inImage * 255).astype(np.uint8), cv2.CV_64F, 0, 1, ksize=3)
    # Mostrar las imágenes
    # Imprimir los valores mínimos y máximos de la magnitud del gradiente de la imagen
    plt.figure('gX')
    plt.imshow(gX, cmap='gist_gray')
    plt.figure('gY')
    plt.imshow(gY,  cmap='gist_gray')
    plt.show()



##########################################################################

### Detección de bordes LoG ###

def test_log(path, sigma):
    inImage = load_image(path)
    output_image = LoG(inImage, sigma)
    
    # Mostrar rango de valores de la salida
    min_val, max_val = np.min(output_image), np.max(output_image)
    print(f"Rango de valores de la salida (LoG): Min = {min_val}, Max = {max_val}")

    # EN FUNCION DE SIGMA AHORA
    output_image_cv2 = cv2.Laplacian((inImage * 255).astype(np.uint8), cv2.CV_64F, ksize=(int)(2*(np.ceil(3*sigma))+1))  # Usa CV_64F para valores negativos

    # Mostrar las imágenes
    display_images(inImage,normalize(output_image),normalize(output_image_cv2))


##########################################################################
### Detección de bordes Canny ###

def test_canny(path, sigma, low_threshold, high_threshold):
    inImage = io.imread(path, as_gray=True) # Cargar la imagen en escala de grises
    imagen_entrada = load_image(path)
    output_image = edgeCanny(inImage, sigma, low_threshold, high_threshold)
    output_image_cv2 = cv2.Canny((inImage * 255).astype(np.uint8), low_threshold, high_threshold) / 255
    display_images(imagen_entrada, normalize(output_image), normalize(output_image_cv2))

