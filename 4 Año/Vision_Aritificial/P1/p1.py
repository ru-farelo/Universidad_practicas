import numpy as np
import pylab as plt
import cv2
import math

from scipy.ndimage import label  

##### 3.1. Histogramas: mejora de contraste #####

#### Algoritmo de alteración del rango dinámico

def adjustIntensity(inImage, inRange=[], outRange=[0, 1]):
    # Imagen de salida vacía
    row,col = inImage.shape
    outImage = np.zeros((row, col))
    # Comprobar si el rango de intensidad de la imagen de entrada está vacío
    if len(inRange) == 0:
        imin = np.min(inImage)
        imax = np.max(inImage)
    # Si no está vacío, se obtienen los valores de intensidad
    else:
        imin = inRange[0]
        imax = inRange[1]
    # Se obtiene el rango de niveles de intensidad de la imagen de salida
    omin = outRange[0]
    omax = outRange[1]
      
    # Explicación de como saque la formula abajo
    outImage = omin + (((omax-omin) * (inImage-imin)) / (imax-imin))
    return outImage


    ''' Explicación de como saque la formula 
        # Se ajusta la imagen de entrada al rango de salida
            # Se realiza una Transformación lineal para ajustar la imagen de entrada al rango de salida 
            # Se aplica con la formula de la recta pendiente y = mx + b
            # Se despejan m y b para obtener la formula de ajuste
            # m = (omax - omin) / (imax - imin) 
            # b = omin - m * imin -> para el omin y imin se coge un punto de la recta
            # b = omin - (((omax - omin) / (imax - imin)) * imin)
            # y = omin + (((omax - omin) / (imax - imin)) * Imagen de entrada)
            # Imagen de salida = omin + (((omax-omin) * (inImage[i][j]-imin)) / (imax-imin))
    '''

################################################################################################################
#### Ecualización de histograma ###

# Función que devuelve el índice del histograma acumulado
def get_index(value, hist_acum, nBins):
    # Se obtiene el índice del histograma acumulado que lo que hace es dividir el histograma en nBins
    index = int(value // (1 / nBins)) 
    if index >= len(hist_acum):
        return len(hist_acum) - 1  # Comprobamos si el índice es mayor que el tamaño del histograma para que no se salga de rango
    else:
        return index

# Función que crea un histograma
def create_histogram(inImage, nBins=256):
    # Se obtienen las dimensiones de la imagen
    row, col = inImage.shape
    # Se crea un histograma con nBins
    hist = np.zeros(nBins)
    # Se calcula el histograma
    for i in range(row):
        for j in range(col):
            index = get_index(inImage[i, j], hist, nBins) # Se obtiene el índice del histograma
            hist[index] += 1 
    return hist 
    

def equalizeIntensity(inImage,  nBins=256): # Se realiza la interpolación de los valores del histograma acumulado
    row, col = inImage.shape
    outImage = np.zeros((row, col))

    hist = create_histogram(inImage, nBins)  # Histograma
    hist_acum = hist.cumsum()  # Histograma acumulado
    total_pixels = row * col # Total de pixeles de la imagen

    for i in range(row):
        for j in range(col):
            # Se obtiene el índice del histograma acumulado
            index = get_index(inImage[i, j], hist_acum,nBins)
            outImage[i, j] = (hist_acum[index] / total_pixels)  # Normalizamos el histograma acumulado
    return outImage

''' Explicacion de la ecualizacion 
    # Se calcula el histograma de la imagen de entrada
    # Se calcula el histograma acumulado
    # Se calcula el total de pixeles de la imagen
    # Se normaliza el histograma acumulado
    # Se obtiene el índice del histograma acumulado
    # Se aplica la ecualización de histograma
    # Se devuelve la imagen de salida con el histograma ecualizado
'''
################################################################################################################

### 3.2. Filtrado espacial: suavizado ###

### Filtrado espacial mediante convolución ###

##Función para agregar el padding y manejar los bordes de la imagen puede implementarlo con NaN o con 0
def add_padding(inImage, up, down, left, right, padding_value=0):
    row, col = inImage.shape
   # Crear una nueva imagen con las dimensiones ampliadas
    padded_image = np.ones((row + up + down, col + left + right)) * padding_value # Se crea una imagen con el tamaño de la imagen original más el padding
    
    #Copiar la imagen original en el centro de la imagen con borde
    padded_image[up:up + row, left:left + col] = inImage
    
    return padded_image

##  Calcula el padding de la imagen
def padding_img(kernel,centerPixel): # Se obtiene el padding de la imagen teniendo en cuenta el tamaño del kernel y la posición del pixel central
    # Se obtiene el tamaño del kernel
    row, col = kernel.shape
    # Se obtiene la posición del pixel central del kernel
    centerRow, centerCol = centerPixel
    maxRow , maxCol = row - 1, col - 1
    # Se obtiene la cantidad de pixeles que se deben agregar en cada dirección
    up = centerRow
    down = maxRow - centerRow
    left = centerCol
    right = maxCol - centerCol

    return [up, down, left, right]



# Función que ajusta el kernel a la imagen
# Ajusta el kernel a la imagen, si el kernel es un vector lo convierte en una matriz
def reshapeKernel(kernelArray):
    if kernelArray.ndim == 1:
        kernelArray = np.reshape(kernelArray, (1, kernelArray.size))
    return kernelArray

# Función que realiza la convolución
def convolution (padding_image,kernel ,row,col):
    row_kernel, col_kernel = kernel.shape
    sum = 0
    for i in range(row_kernel):
        for j in range(col_kernel):
            sum += padding_image[row + i][col + j] * kernel[i][j] # Sumatorio de la convolución
    return sum


def filterImage(inImage, kernel):
    row, col = inImage.shape
    outImage = np.zeros((row, col))
    kernel = reshapeKernel(kernel)
    row_kernel, col_kernel = kernel.shape
    centerPixel = (row_kernel//2, col_kernel//2)
    ## El padding se usa para el kernel pueda aplicar correctamente en los bordes de la imagen
    # Se obtiene la cantidad de pixeles que se deben agregar en cada dirección
    [up, down, left, right] = padding_img(kernel, centerPixel)
    # Se agrega el padding a la imagen
    padding_image = add_padding(inImage, up, down, left, right, padding_value=0)
    # Se realiza la convolución
    for i in range(row):
        for j in range(col):
            outImage[i][j] = convolution(padding_image, kernel, i, j)
    return outImage

    ''' Explicación de filterImage
        # Se obtiene el tamaño de la imagen
        # Se inicializa la imagen de salida
        # Se ajusta el kernel a la imagen
        # Se obtiene el tamaño del kernel
        # Se obtiene la posición del pixel central del kernel
        # Se obtiene el padding de la imagen
        # Se realiza la convolución (Sumatorio de la convolución)
        # Se devuelve la imagen de salida
    '''

################################################################################################################
### Kernel Gaussiano 1D ###

def gaussKernel1D (sigma):
    # N es el tamaño del kernel
    N = (int)(2*(np.ceil(3*sigma))+1) ## se multiplica por 3 para que coja correctamente la forma gaussiana si fuera 1 sigma actuaria como un filtro de medias
    center = N//2
    kernel = np.zeros(N)
    # Se calcula el kernel gaussiano 1D
    for x in range(N):
       distx = x - center # Se obtiene la distancia al centro
       kernel[x] = np.exp(-distx**2 / (2*sigma**2)) / (np.sqrt(2*np.pi) * sigma) # Se aplica la formula de la gaussiana
    kernel = kernel / np.sum(kernel) # Normalizamos el kernel

    return kernel


    ''' Explicación de gaussKernel1D
        # Se obtiene el tamaño del kernel
        # Se obtiene el centro del kernel
        # Se inicializa el kernel
        # Se obtiene el rango del kernel
        # Se aplica la formula de la gaussiana
        # Retornamos la salida
    '''

################################################################################################################

### Kernel Gaussiano 2D ###  
def gaussianFilter (inImage,sigma):
    #gaussKernel1D(sigma).reshape(1, -1)
    kernel = gaussKernel1D(sigma).reshape(1,-1)
    outImage = filterImage(inImage, kernel) # Se aplica el filtro  aplicando la convolución
    outImage_transpose = filterImage(outImage, np.transpose(kernel)) # Se transpone el kernel y se aplica el filtro
    return outImage_transpose

    ''' Explicación de gaussianFilter
        # Se obtiene el kernel 1D
        # Se aplica el filtro
        # Se transpone el kernel
        # Se aplica el filtro
        # Se devuelve la imagen de salida
    '''

################################################################################################################
### Filtro de medianas bidimensional ###

def calculate_median(subMatrix): ## Calcula la mediana de la submatriz
 
    # Asegurarse de que la submatriz es un array 1D
    subMatrix = np.array(subMatrix).flatten()  # Convertir en array 1D 

    # Ordenar el array
    subMatrix.sort()

    size = len(subMatrix)
    if size % 2 == 0:
        # Si el tamaño es par, se toma el promedio de los dos elementos centrales
        median = (subMatrix[(size // 2) - 1] + subMatrix[size // 2]) / 2
    else:
        # Si el tamaño es impar, se toma el elemento central
        median = subMatrix[size // 2]
    
    return median
   
def medianFilter(inImage, filterSize):
    row, col = inImage.shape
    outImage = np.zeros((row, col))
    filt_row, filt_col = filterSize , filterSize
    center = (filt_row // 2, filt_col // 2)
    
    # Añadir padding a la imagen
    [up, down, left, right] = padding_img(np.zeros((filt_row, filt_col)), center)
    padded_image = add_padding(inImage, up, down, left, right, padding_value=0)

    # Aplicar el filtro de mediana
    for i in range(row):
        for j in range(col):
            # Extraer la submatriz en torno a (i, j)
            subMatrix = []
            for x in range(filt_row):
                for y in range(filt_col):
                    subMatrix.append(padded_image[i + x][j + y])
            
            # Calcular la mediana de la submatriz
            outImage[i][j] = calculate_median(subMatrix)

    return outImage

    ''' Explicación de medianFilter
        # Se obtienen las dimensiones de la imagen
        # Se inicializa la imagen de salida
        # Se obtienen las dimensiones del filtro
        # Se obtiene el centro del filtro
        # Se obtiene el padding de la imagen
        # Se aplica el filtro de mediana
        # Se devuelve la imagen de salida
    '''
   

################################################################################################################  
### 3.3. Operadores morfológicos ###

### Operadores morfologicos de erosion, dilatacion, apertura y cierre para imagenes binarias ###

# Erosión
def erode(inImage, SE, center=[]):
    rowIm, colIm = inImage.shape
    outImage = np.zeros((rowIm, colIm), dtype=np.uint8)  # Imagen de salida inicializada a ceros
    rowK, colK = SE.shape
    
    if center == []:
        center = [rowK // 2, colK // 2]  # Si no se especifica centro, usa el centro del kernel
    
    # Calcular padding necesario
    padding = padding_img(SE, center)
    
    # Añadir padding a la imagen de entrada
    padded_image = add_padding(inImage, padding[0], padding[1], padding[2], padding[3], padding_value=1)
    
    # Efectuar erosión
    for i in range(rowIm):
        for j in range(colIm):
            # Extraer la submatriz alrededor de (i, j) del tamaño del kernel
            subMatrix = padded_image[i:i + rowK, j:j + colK]
            
            # Aplicar erosión: si la submatriz y el SE coinciden donde SE=1
            if np.all(subMatrix[SE == 1]): # Preguntar si se puede usar el np.all
                outImage[i, j] = 1  # Si hay coincidencia, marcar como 1
            else:
                outImage[i, j] = 0  # Si no, dejar en 0 (erosión)
    
    return outImage

    ''' Explicación de erode
        # Se obtienen las dimensiones de la imagen
        # Se inicializa la imagen de salida
        # Se obtienen las dimensiones del kernel
        # Se obtiene el centro del kernel
        # Se calcula el padding necesario
        # Se añade el padding a la imagen de entrada
        # Se efectua la erosión
        # Se devuelve la imagen de salida
    '''


def complement(image):
    # Calcula el complementario de la imagen (A^C)
    return 1 - image

def inverse_kernel(kernel): # Inverso del kernel con el circunflejo
    # Calcular el inverso del kernel (flip en ambos ejes) hace el espejo basicamente
    return np.flipud(np.fliplr(kernel))

def dilate(inImage, SE, center=[]): # Se aplica la Formula A⊕B=(AC⊖B−1)C 
                                                           #A erosion B = ((A dilatacion B circunflejo)) ^complementario
    #  Calcular el complemento de la imagen A^C
    complementImage = complement(inImage)
    
    #  Calcular el inverso del kernel B^{-1}
    SE_inverse = inverse_kernel(SE)
    
    #  Aplicar erosión al complemento de la imagen usando el kernel inverso
    eroded_complement = erode(complementImage, SE_inverse, center)
    
    #  Devolver el complemento del resultado de la erosión
    return complement(eroded_complement)

    ''' Explicación de dilate
        # Se calcula el complemento de la imagen
        # Se calcula el inverso del kernel
        # Se aplica la erosión al complemento de la imagen
        # Se devuelve el complemento del resultado de la erosión
    '''

# Operador de apertura  (A∘B) = (A erosion B) dilatacion B
def opening (inImage, SE, center=[]):
    outImage_erode = erode(inImage, SE, center)
    outImage_dilate = dilate(outImage_erode, SE, center)
    return outImage_dilate

    '''Explicación de opening
        # Se aplica la erosión
        # Se aplica la dilatación
        # Se devuelve la imagen de salida  
    '''

# Operador de cierre  (A•B) = (A dilatacion B) erosion B
def closing (inImage, SE, center=[]):
    outImage_dilate = dilate(inImage, SE, center)
    outImage_erode = erode(outImage_dilate, SE, center)
    return outImage_erode

    '''Explicación de closing
        # Se aplica la dilatación
        # Se aplica la erosión
        # Se devuelve la imagen de salida
    '''
################################################################################################################
### Llenado morfologico de regiones ### 

# Función de dilatación
def fill(inImage, seeds, SE=[], center=[]):
    # Calcular el complemento de la imagen A^C
    complementImage = complement(inImage)

    # Crear la imagen inicial con las semillas
    outImage = np.zeros_like(inImage, dtype=np.uint8)
    for seed in seeds:
        outImage[seed[0], seed[1]] = 1  # Colocar semillas en la imagen

    # Iterar hasta que xk = xk-1
    while True:
        # Paso 4: Calcular xk = (xk-1 ⊕ B) ∩ A^C (dilatación e intersección)
        dilated = dilate(outImage, SE, center)
        xk = np.logical_and(dilated, complementImage).astype(np.uint8)  # Operación lógica AND
        
        # Si no hay cambios, detener el proceso
        if np.array_equal(xk, outImage):
            break
        
        # Actualizar la imagen de salida
        outImage = xk

    return np.logical_or(outImage, inImage).astype(np.uint8)
    
    # Devolver la unión de las regiones llenas con la imagen 



################################################################################################################
### 3.4. Deteccion de bordes ###

###Gradiente de una imagen  ###
# La dirección de la de la gradiente es en funcion a la normal del cambio de color

# La magnitud del gradiente es la raiz cuadrada de la suma de los cuadrados de las derivadas en x e y

def gradientImage(inImage, operator):
    kernels = { # Diccionario con los kernels de los operadores
        'Roberts': (np.array([[1, 0], [0, -1]]), np.array([[0, 1], [-1, 0]])),
        'CentralDiff': (np.array([[-1, 0, 1]]), np.array([[-1], [0], [1]])),
        'Prewitt': (np.array([[-1, 0, 1], [-1, 0, 1], [-1, 0, 1]]),
                    np.array([[-1, -1, -1], [0, 0, 0], [1, 1, 1]])),
        'Sobel': (np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]]),
                  np.array([[-1, -2, -1], [0, 0, 0], [1, 2, 1]]))
    }
    
    if operator not in kernels:
        raise ValueError(f"Unsupported operator: {operator}. Supported operators are: {list(kernels.keys())}.")
    
    kernel_x, kernel_y = kernels[operator] # Obtener los kernels para el operador seleccionado
    # Se aplica el filtro de convolución para obtener las derivadas en x e y
    gx = filterImage(inImage, kernel_x) # Gradiente en x , derivada en x
    gy = filterImage(inImage, kernel_y) # Gradiente en y , derivada en y
    
    return gx, gy

    ''' Explicación de gradientImage
        # Se crea un diccionario con los kernels de los operadores
        # Se comprueba si el operador es válido
        # Se obtienen los kernels para el operador seleccionado
        # Se aplica el filtro de convolución para obtener las derivadas en x e y
        # Se devuelve el gradiente en x y en y
    '''


################################################################################################################
### Filtro Laplaciano de Gaussiano ### 

# Función Laplaciano de Gaussiano (LoG) Se aplica lo explicado en practicas I * G * Kernel laplaciano     * ->  convolucion
def LoG(inImage, sigma):
    # Suavizado con filtro Gaussiano
    convolution_gauss = gaussianFilter(inImage, sigma)
    
    # Aplicar el filtro Laplaciano a la imagen suavizada
    kernel = np.array([[1, 1, 1],
                       [1, -8, 1],
                       [1, 1, 1]])
    # Aplicar el filtro de convolución
    outImage = filterImage(convolution_gauss, kernel)
    
    return outImage

    ''' Explicación de LoG
        # Se suaviza la imagen con un filtro Gaussiano
        # Se aplica el filtro Laplaciano a la imagen suavizada
        # Se aplica el filtro de convolución
        # Se devuelve la imagen de salida
    '''


################################################################################################################
### Detector de bordes de Canny. ###

def magnitude(gx, gy):
    # Calcular la magnitud del gradiente
    return np.sqrt(gx**2 + gy**2)

def direction(gx, gy):
    # Calcular la dirección del gradiente
    return np.arctan2(gy, gx)


def supresion_no_maximos(magnitude, direction):
    angle = direction * 180 / np.pi
    angle[angle < 0] += 180

    # Inicializar la imagen de salida
    nms = np.zeros_like(magnitude, dtype=np.float32)
    
    # Definir los offsets para las direcciones de los píxeles vecinos
    offsets = {
        (0, 1): (0, -1),    # 0° (este)
        (1, 1): (-1, 1),    # 45° (noreste)
        (1, 0): (-1, 0),     # 90° (norte)
        (1, -1): (-1, -1),   # 135° (noroeste)
    }
    for i in range(1, magnitude.shape[0] - 1):
        for j in range(1, magnitude.shape[1] - 1):
            # Determinar la dirección y vecinos correspondientes
            if (0 <= angle[i, j] < 22.5) or (157.5 <= angle[i, j] <= 180):
                neighbors = (0, 1), (0, -1)  # Este, Oeste
            elif 22.5 <= angle[i, j] < 67.5:
                neighbors = (1, 1), (-1, -1)  # Noreste, Suroeste
            elif 67.5 <= angle[i, j] < 112.5:
                neighbors = (1, 0), (-1, 0)  # Norte, Sur
            elif 112.5 <= angle[i, j] < 157.5:
                neighbors = (1, -1), (-1, 1)  # Noroeste, Sureste
            
            # Obtener los valores de los vecinos
            q = magnitude[i + neighbors[0][0], j + neighbors[0][1]]
            r = magnitude[i + neighbors[1][0], j + neighbors[1][1]]
            
            # Suprimir no máximos
            if (magnitude[i, j] >= q) and (magnitude[i, j] >= r):
                nms[i, j] = magnitude[i, j]
    
    return nms


    
def histeresis_umbralizacion(magnitude, tlow, thigh):
    #  Definir bordes fuertes y débiles
    high_thresh = magnitude > thigh  # Píxeles de bordes fuertes
    low_thresh = magnitude >= tlow

    #  Etiquetado de regiones conectadas con vecindad de 8 para bordes fuertes
    labels_high, n = label(high_thresh, structure=np.ones((3, 3)))  
    # Etiquetado de regiones conectadas con vecindad de 8 para bordes débiles
    labels_low, _ = label(low_thresh, structure=np.ones((3, 3)))    

    #  Obtener las etiquetas de los píxeles de bordes débiles conectados a bordes fuertes
    final_edges = np.zeros_like(magnitude, dtype=np.uint8)

    for i in range(1, n + 1):
        # Obtener los píxeles de la región conectada i
        region = np.unique(labels_low[labels_high == i])
        # Marcar los píxeles de la región conectada i en la imagen final
        for j in region:
        # Verificar si la etiqueta está en la imagen de bordes débiles
            if j > 0:  # Asegurarse de que la etiqueta es válida
                 final_edges[labels_low == j] = 1

    return final_edges



def edgeCanny(inImage, sigma, tlow, thigh):
    # Suavizar la imagen de entrada con un filtro Gaussiano
    img_suavizada = gaussianFilter(inImage, sigma)
    
    # Calcular el gradiente de la imagen suavizada
    gx, gy = gradientImage(img_suavizada, 'Sobel')
    
    # Calcular la magnitud y dirección del gradiente
    magnitude_gradient = magnitude(gx, gy)
    direction_gradient = direction(gx, gy)
    #  Supresión de no-máximos
    nms = supresion_no_maximos(magnitude_gradient, direction_gradient)

    #  Umbralización por histéresis
    final_edges = histeresis_umbralizacion(nms, tlow, thigh)

    return final_edges

    ''' Explicación de edgeCanny
        # Se suaviza la imagen de entrada con un filtro Gaussiano
        # Se calcula el gradiente de la imagen suavizada
        # Se calcula la magnitud y dirección del gradiente
        # Se suprime los no-máximos
        # Se umbraliza por histéresis
        # Se devuelve la imagen de salida
    '''


