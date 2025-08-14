from test import *

########### MAIN ###################
def main():

    # ALTERACION DEL RANGO DINAMICO
    #test_intensity_adjustment('imagenes/circles.png', 0., 0.5)
    #test_intensity_adjustment('imagenes/eq0.png', 0, 1)
    
    # ECUALIZACION DE HISTOGRAMA
    #test_equalize_intensity('imagenes/eq0.png')

    # FILTRADO ESPACIAL MEDIANTE CONVOLUCION 
    # Opcion 1 = Filtro promedio , Opcion 2 = Comprobar kernel funciona correctamente , Opcion 3 = Filtro con imagen Imagen creada con un array
    #test_filter_image('imagenes/grid0.png', 1)

    # FILTRO GAUSSIANO 1D
    #test_gaussian_filter_1D(1)

    # FILTRO GAUSSIANO 2D , Probar con diferentes sigmas
    #test_gaussian_filter_2D(0.4, 'imagenes/grid0.png') 

    # Filtro Mediana , Probar con diferentes tamaños de kernel generalmente impares
    #test_median_filter('imagenes/grid.png',3)
    #test_median_filter('imagenes/grid.png',5)

    # Operator morfologicos
    #test_morphological_erode('imagenes/image.png')
    #test_morphological_dilate('imagenes/image.png')
    #test_morphological_opening('imagenes/image.png')
    #test_morphological_closing('imagenes/image.png')

    # Operador Fill
    #test_fill('imagenes/image0.png')

    # Deteccion de bordes Gradient , Probar con las diferentes opciones de kernel 1: 'Roberts', 2: 'CentralDiff', 3: 'Prewitt', 4: 'Sobel'
    #test_gradient('imagenes/circles.png',4)

    # Detector de bordes Log , Probar con diferentes sigmas
    #test_log('imagenes/circles.png',1)

    # Detectar bordes con Canny # Probar con diferentes valores de umbral bajo y alto  y sigma
    # El cv2 me da algo diferente a la implementacion propia por la implementacion de cv2 ya que usara otro sigma
    #test_canny('imagenes/circles1.png', 1, 10, 105) # intervalo de 10 a 105 entre bordes suaves y fuertes
   #test_canny('imagenes/image5.png', 3, 43,43) # intervalo fuerte
    #test_canny('imagenes/image5.png', 3, 5,5) # intervalo de 10 a 105 entre bordes suaves y fuertes
    test_canny('imagenes/circles.png', 3, 5, 45) # intervalo de 10 a 105 entre bordes suaves y fuertes
    

if __name__ == '__main__':
    main()