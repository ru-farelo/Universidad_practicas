import cv2
import numpy as np
import matplotlib.pyplot as plt

def enhance_contrast(image):
    laplacian = cv2.Laplacian(image, cv2.CV_64F) # Se aplica el operador Laplaciano a la imagen para marcar los bordes
    laplacian = cv2.convertScaleAbs(laplacian) # Se convierte la imagen a un tipo de datos de 8 bits sin signo
    enhanced_image = cv2.addWeighted(image, 1.25, laplacian, -0.35, 0) # Se combina la imagen original con el operador Laplaciano
    return enhanced_image

def filter_señales(image):
    image = enhance_contrast(image)
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV) # Se convierte la imagen a espacio de color HSV

    lower_blue = np.array([90, 130, 90])
    upper_blue = np.array([120, 255, 255])

    lower_red1 = np.array([0, 135, 50])
    lower_red2 = np.array([160, 120, 50])
    upper_red1 = np.array([15, 255, 255])
    upper_red2 = np.array([180, 255, 255])

    lower_white = np.array([0, 0, 150])
    upper_white = np.array([180, 60, 255])

    lower_black = np.array([0, 0, 0])
    upper_black = np.array([180, 255, 30])

    mask_white = cv2.inRange(hsv, lower_white, upper_white)
    mask_black = cv2.inRange(hsv, lower_black, upper_black)

    mask_red1 = cv2.inRange(hsv, lower_red1, upper_red1)
    mask_red2 = cv2.inRange(hsv, lower_red2, upper_red2)
    mask_red = cv2.bitwise_or(mask_red1, mask_red2)
    mask_blue = cv2.inRange(hsv, lower_blue, upper_blue)
    
    kernel = np.ones((5, 5), np.uint8)

    mask_blue = cv2.morphologyEx(mask_blue, cv2.MORPH_CLOSE, kernel) # Se aplica una operación morfológica de cierre a las máscaras azules
    return mask_red, mask_blue, mask_white, mask_black

def detect_circles_with_hough(image, hull):

    mask = np.zeros(image.shape[:2], dtype=np.uint8) # Se crea una máscara en blanco
    cv2.drawContours(mask, [hull], 0, 255, -1) # Se dibuja el contorno en la máscara
    
    masked_image = cv2.bitwise_and(image, image, mask=mask) # Se aplica la máscara a la imagen original
    
    gray = cv2.cvtColor(masked_image, cv2.COLOR_BGR2GRAY) # Se convierte la imagen a escala de grises

    edges = cv2.Canny(gray, 50, 150, apertureSize=3) # Se detectan los bordes de la imagen , apertureSize es el tamaño del kernel del operador de Sobel
    
    circles = cv2.HoughCircles(edges, cv2.HOUGH_GRADIENT, dp=1, minDist=1,
                            param1=1500, param2=13, minRadius=6, maxRadius=50) # Se detectan los círculos
    
    if circles is not None:
        circles = np.uint16(np.around(circles)) # Se redondean las coordenadas de los círculos
        return circles[0, :]
    return []


def classify_señales(image, mask_red, mask_blue, mask_white, mask_black):
    colors = {
        "prohibicion": (0, 0, 255),
        "peligro": (0, 255, 255),
        "obligacion": (255, 0, 0),
        "indicacion": (255, 255, 0),
    }

    output_image = image.copy()

    def process_mask(mask, mask_type):
        contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE) # Se obtienen los contornos de la máscara con vecindad 

        for contour in contours:
            area = cv2.contourArea(contour)
            if area > 400: # Se filtran los contornos con un área menor a 400
                x, y, w, h = cv2.boundingRect(contour)
                aspect_ratio = w / float(h)
                if aspect_ratio > 1.25 or aspect_ratio < 0.5: # Se filtran los contornos con una proporción mayor a 1.25 o menor a 0.5
                    continue

                padding = 5 # Se añade un padding alrededor del contorno para el bounding box
                x_padded = max(0, x - padding)
                y_padded = max(0, y - padding)
                w_padded = min(image.shape[1] - x_padded, w + 2 * padding)
                h_padded = min(image.shape[0] - y_padded, h + 2 * padding)

                hull = cv2.convexHull(contour) # Se obtiene el contorno convexo
                #cv2.drawContours(output_image, [hull], -1, (0, 255, 0), 2) # Se dibuja el contorno convexo en la imagen de salida
                
                peri = cv2.arcLength(hull, True) # Se calcula el perímetro del contorno convexo
                approx = cv2.approxPolyDP(hull, 0.04 * peri, True) # Se aproxima el contorno a un polígono
                '''
                cv2.approxPolyDP(hull, 0.04 * peri, True) aproxima el contorno convexo a un polígono. El segundo argumento 0.04 * peri 
                es la precisión de la aproximación: cuanto menor sea este valor, más cerca estará el polígono del contorno original. 
                El tercer argumento True indica que el contorno está cerrado.
                '''
                vertices = len(approx) # Se calcula el número de vértices del polígono aproximado

                # 1. Clasificación de triángulos usando la aproximación de polígonos
                if vertices == 3 and mask_type == "red":
                    # Dividir la región en dos partes horizontales para clasificar la señal
                    mid_y_padded = y_padded + h_padded / 2
                    top_vertices_padded = sum(1 for point in approx if point[0][1] < mid_y_padded)

                    if top_vertices_padded == 2: # Se verifica si el triángulo tiene dos vértices en la parte superior y se clasifica como ceda 
                        cv2.rectangle(output_image, (x_padded, y_padded), (x_padded + w_padded, y_padded + h_padded), colors["prohibicion"], 2)
                        cv2.putText(output_image, "prohibicion", (x_padded, y_padded - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, colors["prohibicion"], 2)
                    else: # Sino es una señal de peligroq
                        cv2.rectangle(output_image, (x_padded, y_padded), (x_padded + w_padded, y_padded + h_padded), colors["peligro"], 2)
                        cv2.putText(output_image, "peligro", (x_padded, y_padded - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, colors["peligro"], 2)
                
                # 2. Clasificación de cuadrados usando la aproximación de polígonos
                elif vertices == 4 and mask_type == "blue":
                    cv2.rectangle(output_image, (x_padded, y_padded), (x_padded + w_padded, y_padded + h_padded), colors["indicacion"], 2)
                    cv2.putText(output_image, "indicacion", (x_padded, y_padded - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, colors["indicacion"], 2)
                elif vertices == 8 and mask_type == "red":
                    cv2.rectangle(output_image, (x_padded, y_padded), (x_padded + w_padded, y_padded + h_padded), colors["prohibicion"], 2)
                    cv2.putText(output_image, "prohibicion", (x_padded, y_padded - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, colors["prohibicion"], 2)
                
                # 3. Clasificación de círculos usando Hough
                else:
                    circles = detect_circles_with_hough(image[y_padded:y_padded+h_padded, x_padded:x_padded+w_padded], 
                                                       hull - [x_padded, y_padded])
                    
                    circularity = 4 * np.pi * (area / (peri * peri)) # Se calcula la circularidad del contorno para eliminar falsos positivos
                    if circularity < 0.7:
                        continue
                    
                    if len(circles) > 0 :
                        cx, cy, r = max(circles, key=lambda c: c[2])
                        cx += x_padded
                        cy += y_padded

                        circle_mask = np.zeros(mask.shape, dtype=np.uint8)
                        cv2.circle(circle_mask, (cx, cy), r, 255, -1)
                            
                        # Verificar píxeles blancos y negros dentro del contorno para saber si es una señal o una luz de un semaforo
                        mask_contour_white = np.zeros_like(mask_white)

                        cv2.drawContours(mask_contour_white, [contour], -1, 255, -1)
                        white_pixels = cv2.countNonZero(cv2.bitwise_and(mask_white, mask_contour_white))

                        mask_contour_black = np.zeros_like(mask_black)
                        cv2.drawContours(mask_contour_black, [contour], -1, 255, -1)
                        black_pixels = cv2.countNonZero(cv2.bitwise_and(mask_black, mask_contour_black))
                        
                        if mask_type == "red" and white_pixels > 15 or black_pixels > 15:
                            cv2.circle(output_image, (cx, cy), r, colors["prohibicion"], 2)
                            cv2.putText(output_image, "prohibicion", (cx - r, cy - r - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, colors["prohibicion"], 2)
                        elif mask_type == "blue":       
                            cv2.circle(output_image, (cx, cy), r, colors["obligacion"], 2)
                            cv2.putText(output_image, "obligacion", (cx - r, cy - r - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, colors["obligacion"], 2)

    process_mask(mask_red, "red")
    process_mask(mask_blue, "blue")

    return output_image