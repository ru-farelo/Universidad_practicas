# Si se ha dividido el conjunto de patrones en entrenamiento y test, 
#¿en cuál de los dos habría  que calcular la matriz de confusión?


# En el conjunto de test, ya que es el conjunto que no se ha utilizado para entrenar el modelo y por lo tanto no se ha visto antes.


#En esta práctica, se pide: 
# Desarrollar una función llamada confusionMatrix que acepte dos vectores de igual longitud 
#(igual al número de patrones), el primero con las salidas obtenidas por un modelo outputs y 
#el segundo con las salidas deseadas targets, ambos de tipo AbstractArray{Bool,1} y devuelva 
#una tupla con los siguientes valores, por este orden: 
#o Valor de precisión. 
#o Tasa de fallo. 
#o Sensibilidad. 
#o Especificidad. 
#o Valor predictivo positivo. 
#o Valor predictivo negativo. 
#o F1-score. 
#o Matriz de confusión, como un objeto de tipo Array{Int64,2} con dos filas y dos 
#columnas. 
#Dado que se le están dando vectores de valores booleanos, esta función se aplicará en 
#problemas de dos clases (casos positivos y negativos). 
#En el cálculo de estos valores, es necesario tener en cuenta los siguientes casos particulares: 
#o Si no hay patrones que pertenezcan a la clase positiva y ninguna instancia ha sido 
#clasificada como positiva, el valor de sensibilidad (recall) no se podrá calcular (0/0). En 
#este caso, no se habrá fallado ningún caso de instancias positivas, por lo que el valor 
#de sensibilidad será igual a 1. Esto se puede saber fácilmente, si VP = FN = 0. 
#o De igual manera, si VP = FP = 0, no se puede calcular el valor predictivo positivo 
#(precision), pero, sabiendo que no se ha fallado ninguna predicción hecha como 
#positiva, esta métrica debería tomar el valor de 1. 
#o El mismo razonamiento se puede seguir para las métricas especificidad (specificity) 
#(TN = FP = 0) y VPN (NPV) (VN = FN = 0). 
#o Para el cálculo de F1, si la sensibilidad y el valor predictivo positivo son iguales a 0, 
#esta no se puede calcular. En ese caso, el valor de F1 será igual a 0. 


# ¿Por qué debería de ser igual a 0 en este caso? 

# Porque si la sensibilidad y el valor predictivo positivo son 0, significa que no se ha acertado ninguna instancia positiva, por lo que el valor de F1 debería ser 0.


#No utilizar bucles en el desarrollo de esta función. 

include("../P2/pruebasconIris.jl")

function confusionMatrix(outputs::AbstractArray{Bool,1}, targets::AbstractArray{Bool,1})
    # Contar los valores en la matriz de confusión
    VP = sum(outputs .& targets)  # Verdaderos positivos
    VN = sum((.!outputs) .& (.!targets))  # Verdaderos negativos
    FP = sum(outputs .& (.!targets))  # Falsos positivos
    FN = sum((.!outputs) .& targets)  # Falsos negativos
    
    # Calcular las métricas de evaluación
    precision = VP / (VP + FP)
    error_rate = (FN + FP) / (VN + VP + FN + FP)
    
    if VP + FN == 0
        sensitivity = 1.0
    else
        sensitivity = VP / (VP + FN)
    end
    
    if VN + FP == 0
        specificity = 1.0
    else
        specificity = VN / (FP + VN)
    end
    
    if VP + FP == 0
        positive_predictive_value = 1.0
    else
        positive_predictive_value = VP / (VP + FP)
    end
    
    if VN + FN == 0
        negative_predictive_value = 1.0
    else
        negative_predictive_value = VN / (VN + FN)
    end
    
    if sensitivity + positive_predictive_value == 0
        f1_score = 0.0
    else
        f1_score = 2 * (sensitivity * positive_predictive_value) / (sensitivity + positive_predictive_value)
    end
    
    # Crear la matriz de confusión
    confusion_matrix = [VP FN; FP VN]
    
    return (precision, error_rate, sensitivity, specificity, 
            positive_predictive_value, negative_predictive_value, f1_score, confusion_matrix)
end


#Muchos modelos (por ejemplo, RR.NN.AA.) no van a devolver una salida categórica, sino que 
#asignarán un valor de probabilidad a la clase “positivo”. Por este motivo, se pide desarrollar 
#una función de nombre igual que la anterior, cuyo primer parámetro, en lugar de ser un 
#vector de valores booleanos, sea un vector de valores reales (de tipo AbstractArray{<:Real}), y 
#con un tercer parámetro opcional que tenga un umbral, con un valor por defecto, y los utilice 
#para aplicar la función anterior y devolver, por lo tanto, los mismos valores. Por el mismo 
#motivo, no se permite el uso de bucles en esta función. 

function confusionMatrix(outputs::AbstractArray{<:Real,1}, targets::AbstractArray{Bool,1}; threshold::Real=0.5)
    # Convertir valores en booleanos usando el umbral
    predicted_outputs = outputs .>= threshold
    
    # Llamar a la función confusionMatrix definida previamente
    confusionMatrix(predicted_outputs, targets)
end


#Desarrollar dos funciones del mismo nombre, printConfusionMatrix, que reciban las salidas 
#del modelo y las salidas deseadas, llamen a las funciones anteriores y muestren por pantalla 
#los resultados obtenidos, incluida la matriz de confusión. Una de estas funciones recibirá 
#como vector de salidas del modelo outputs un vector de tipo AbstractArray{Bool,1}, mientras 
#que para la otra este parámetro será un vector de valores reales (de tipo 
#AbstractArray{<:Real,1}). Estas funciones realizarán llamadas a las funciones anteriores. Estas 
#funciones no serán evaluadas.

function printConfusionMatrix(outputs::AbstractArray{Bool,1}, targets::AbstractArray{Bool,1})
    println("Confusion Matrix (Boolean Outputs):")
    println("------------------------------------")
    
    # Llamar a la función confusionMatrix
    precision, error_rate, sensitivity, specificity, positive_predictive_value, 
    negative_predictive_value, f1_score, confusion_matrix = confusionMatrix(outputs, targets)
    
    # Mostrar los resultados
    println("Precision: $precision")
    println("Error Rate: $error_rate")
    println("Sensitivity: $sensitivity")
    println("Specificity: $specificity")
    println("Positive Predictive Value: $positive_predictive_value")
    println("Negative Predictive Value: $negative_predictive_value")
    println("F1 Score: $f1_score")
    println("Confusion Matrix:")
    println(confusion_matrix)
end

function printConfusionMatrix(outputs::AbstractArray{<:Real,1}, targets::AbstractArray{Bool,1}; threshold::Real=0.5)
    println("Confusion Matrix (Real Outputs with Threshold $threshold):")
    println("---------------------------------------------------------")
    
    # Llamar a la función confusionMatrix
    precision, error_rate, sensitivity, specificity, positive_predictive_value, 
    negative_predictive_value, f1_score, confusion_matrix = confusionMatrix(outputs, targets; threshold=threshold)
    
    # Mostrar los resultados
    println("Precision: $precision")
    println("Error Rate: $error_rate")
    println("Sensitivity: $sensitivity")
    println("Specificity: $specificity")
    println("Positive Predictive Value: $positive_predictive_value")
    println("Negative Predictive Value: $negative_predictive_value")
    println("F1 Score: $f1_score")
    println("Confusion Matrix:")
    println(confusion_matrix)
end

#Prueba de las funciones
ruta = pwd()
ruta_completa = ruta*"\\iris\\iris.data"
dataset = readdlm(ruta_completa, ',')
inputs = dataset[:, 1:4]
targets = dataset[:, 5]
inputs = convert(Array{Float32, 2}, inputs)
targets = oneHotEncoding(targets)
@assert (size(inputs,1) == size(targets,1)) "Las matrices de entradas y salidas deseadas no tienen el mismo número de filas"

# Prueba de la función confusionMatrix con salidas booleanas
outputs_bool = [true, false, true, false, true, false, true, false, true, false]
targets_bool = [true, false, true, false, true, false, true, false, true, false]

println("Prueba de confusionMatrix con salidas booleanas:")
printConfusionMatrix(outputs_bool, targets_bool)

# Prueba de la función confusionMatrix con salidas reales
outputs_real = [0.9, 0.1, 0.8, 0.2, 0.7, 0.3, 0.6, 0.4, 0.5, 0.5]

println("\nPrueba de confusionMatrix con salidas reales:")
printConfusionMatrix(outputs_real, targets_bool)

# Prueba de la función printConfusionMatrix con salidas booleanas
println("\nPrueba de printConfusionMatrix con salidas booleanas:")
printConfusionMatrix(outputs_bool, targets_bool)

# Prueba de la función printConfusionMatrix con salidas reales
println("\nPrueba de printConfusionMatrix con salidas reales:")
printConfusionMatrix(outputs_real, targets_bool)
