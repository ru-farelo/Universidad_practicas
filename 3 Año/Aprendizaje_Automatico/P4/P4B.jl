#¿Por qué es necesaria esta clase extra al usar la función softmax? 

# Porque la función softmax devuelve un vector de probabilidades, y para clasificar las salidas de la red neuronal,
# es necesario convertir estas probabilidades en una clase concreta.

#¿Podría no ser necesaria crear la clase adicional? 

# Sí, si se utilizan otras funciones de activación que devuelvan una salida categórica, 
#como por ejemplo la función sigmoide.

# ¿Qué modificación habría que hacer en la RNA?

# Habría que cambiar la función de activación de la capa de salida por una que devuelva una salida categórica,

#¿Cómo se interpretaría la salida?

# La salida se interpretaría como la probabilidad de que la instancia pertenezca a cada una de las clases.

# ¿Cómo se generaría la clase de salida en función de las salidas de las neuronas de salida?

# Se tomaría la clase con mayor probabilidad como la clase de salida.


#En general, ¿cómo tiene que ser la salida de un modelo para que no se necesite esta cuarta  clase? 

# La salida tiene que ser categórica, es decir, que devuelva directamente la clase a la que pertenece la instancia.

# ¿El modelo kNN necesita esta cuarta clase? 

# No, el modelo kNN no necesita esta cuarta clase, ya que devuelve directamente la clase a la que pertenece la instancia.

# ¿Cuántas clases serían necesarias si una RNA quisiera reconocer esos 3 tipos de animales, y, 
#si  no es uno de ellos, decir si es un animal o no?

# Serían necesarias 4 clases, una para cada tipo de animal y una para el caso de que no sea ninguno de ellos.

# ¿Y si el modelo es un kNN?

# En el caso de kNN, serían necesarias 3 clases, una para cada tipo de animal.


# En la descripción anterior, para estos 3 animales se utilizaron 4 clases, incluyendo la clase  “otro”. ¿Por qué no se entrena un clasificador para esta clase? 

# Porque la clase “otro” actúa como un comodín para capturar patrones no clasificados en las categorías principales y simplifica 
# el proceso de entrenamiento al evitar la necesidad de un clasificador separado para cada posible clase no principal.

#¿Se podrían usar las salidas de estos 3 clasificadores como entrada a la función softmax? 

# Sí, se podrían usar las salidas de estos 3 clasificadores como entrada a la función softmax

# ¿Qué consecuencias tendría? 

# La consecuencia sería que la salida de la función softmax sería una probabilidad ponderada de las salidas de los clasificadores.


#En general, cuando hay L clases y la posibilidad de que un patrón no pertenezca a ninguna de 
#ellas, ¿cuál es el impacto de usar la función softmax en las salidas?

# La función softmax devuelve un vector de probabilidades, y para clasificar las salidas de la red neuronal,
# es necesario convertir estas probabilidades en una clase concreta.

#¿En qué casos se podría usar?

# Se podría usar en problemas de clasificación con más de dos clases.

# Por que ?

# Porque la función softmax devuelve un vector de probabilidades que se pueden interpretar como la probabilidad de que la instancia pertenezca a cada una de las clases.

#  La función softmax es útil para conseguir un valor de loss que permita entrenar la RNA. Sin 
#embargo, si no se usara, en el ejemplo anterior de los animales, ¿sería necesaria la cuarta 
#clase “otro”? 

# No, si no se usara la función softmax, no sería necesaria la cuarta clase “otro”, ya que la salida de la red sería directamente la clase a la que pertenece la instancia.


#  ¿Por qué ya no se necesita esta clase extra? 


#la necesidad de una clase adicional al utilizar la función softmax se debe a la naturaleza de esta función, que garantiza
# que las probabilidades de pertenencia a cada clase sumen 1 y asegura una clasificación exhaustiva y exclusiva.



using DelimitedFiles
using Flux, Plots


function confusionMatrix(outputs::AbstractArray{Bool,2}, targets::AbstractArray{Bool,2}; weighted::Bool=true)
    # Comprobar que el número de columnas de ambas matrices es igual y distinto de 2
    if size(outputs, 2) != size(targets, 2) || size(outputs, 2) == 2
        error("Las matrices de entrada no son válidas.")
    end
    
    # Reservar memoria para los vectores de métricas
    num_classes = size(outputs, 2)
    sensitivity = zeros(num_classes)
    specificity = zeros(num_classes)
    VPP = zeros(num_classes)
    VPN = zeros(num_classes)
    F1 = zeros(num_classes)
    
    # Calcular métricas para cada clase
    for class_idx in 1:num_classes
        # Llamar a la función confusionMatrix para las salidas y objetivos de la clase actual
        cm = confusionMatrix(outputs[:, class_idx], targets[:, class_idx])
        
        # Asignar resultados a vectores correspondientes
        sensitivity[class_idx] = cm.sensitivity
        specificity[class_idx] = cm.specificity
        VPP[class_idx] = cm.VPP
        VPN[class_idx] = cm.VPN
        F1[class_idx] = cm.F1
    end
    
    # Calcular matriz de confusión
    confusion_matrix = [confusionMatrix(outputs[:, i], targets[:, j]).confusionMatrix for i in 1:num_classes, j in 1:num_classes]
    
    # Calcular métricas macro o weighted según se especifique
    if weighted
        # Calcular métricas ponderadas
        precision = weightedAverage(F1, sum(targets, dims=1)[1])
    else
        # Calcular métricas macro
        precision = mean(F1)
    end
    
    # Calcular tasa de error
    error_rate = 1.0 - precision
    
    # Devolver resultados como una tupla
    return (precision, error_rate, sensitivity, specificity, VPP, VPN, F1, confusion_matrix)
end


# ¿Por qué no son válidas las matrices de dos columnas? 

#Las matrices de dos columnas no son válidas porque en el contexto de la función confusionMatrix 
#se espera que tanto las salidas predichas (outputs) como las salidas deseadas (targets) 
#representen la clasificación de cada patrón en múltiples clases. Por lo tanto, se espera que 
#estas matrices tengan más de dos columnas, donde cada columna representa una clase diferente


function confusionMatrix(outputs::AbstractArray{<:Real,2}, targets::AbstractArray{Bool,2}; weighted::Bool=true)
    # Convertir los valores de salida a valores booleanos
    bool_outputs = classifyOutputs(outputs)
    
    # Llamar a la función anterior con las matrices convertidas
    return confusionMatrix(bool_outputs, targets; weighted=weighted)
end



function confusionMatrix(outputs::AbstractArray{<:Any,1}, targets::AbstractArray{<:Any,1}; weighted::Bool=true)
    # Asegurar que todas las clases de salida estén incluidas en las clases deseadas
    @assert all(output -> output in targets, outputs)
    
    # Obtener las posibles clases tanto de outputs como de targets
    classes = unique(vcat(outputs, targets))
    
    # Codificar las matrices outputs y targets mediante one-hot encoding
    encoded_outputs = oneHotEncoding(outputs, classes)
    encoded_targets = oneHotEncoding(targets, classes)
    
    # Llamar a la función confusionMatrix con las matrices codificadas
    return confusionMatrix(encoded_outputs, encoded_targets; weighted=weighted)
end


#¿Cómo es posible que se emita una salida que no esté entre las salidas 
#deseadas? 

#¿En qué casos puede ocurrir esto? 

#Puede ocurrir si el modelo no ha sido entrenado correctamente o si el modelo no es capaz de generalizar

#Es importante que se calcule primer el vector de clases y se pase este 
#en ambas llamadas de codificación. ¿Qué podría ocurrir si no se hace 
#de esta manera?

#Si no se hace de esta manera, es posible que las salidas y las salidas deseadas no tengan el mismo número de clases,
#lo que podría llevar a errores en el cálculo de las métricas de evaluación.

function printConfusionMatrix(outputs::AbstractArray{Bool,2}, targets::AbstractArray{Bool,2}; weighted::Bool=true)
    # Calcular la matriz de confusión
    confusion_matrix = confusionMatrix(outputs, targets; weighted=weighted)
    
    # Imprimir la matriz de confusión
    println("Confusion Matrix:")
    println(confusion_matrix)
end

function printConfusionMatrix(outputs::AbstractArray{<:Real,2}, targets::AbstractArray{Bool,2}; weighted::Bool=true)
    # Calcular la matriz de confusión
    confusion_matrix = confusionMatrix(outputs, targets; weighted=weighted)
    
    # Imprimir la matriz de confusión
    println("Confusion Matrix:")
    println(confusion_matrix)
end

function printConfusionMatrix(outputs::AbstractArray{<:Any,1}, targets::AbstractArray{<:Any,1}; weighted::Bool=true)
    # Calcular la matriz de confusión
    confusion_matrix = confusionMatrix(outputs, targets; weighted=weighted)
    
    # Imprimir la matriz de confusión
    println("Confusion Matrix:")
    println(confusion_matrix)
end

#pruebas con la función y el dataset iris

# Cargar el dataset iris
ruta = pwd()
ruta_completa = ruta * "\\iris\\iris.data"
dataset = readdlm(ruta_completa, ',')
inputs = dataset[:, 1:4]
targets = dataset[:, 5]

# Convertir las entradas a Float32
inputs = convert(Array{Float32, 2}, inputs)

# Codificar las salidas en one-hot encoding
targets = oneHotEncoding(targets)

# Realizar pruebas con la función printConfusionMatrix
# Aquí se pueden proporcionar las salidas predichas y las salidas deseadas para ver la matriz de confusión

# Prueba 1
printConfusionMatrix(
    [true, false, true, false, true, false, true, false, true, false], 
    [true, false, true, false, true, false, true, false, true, false]
)

# Prueba 2
printConfusionMatrix(
    [0.9, 0.1, 0.8, 0.2, 0.7, 0.3, 0.6, 0.4, 0.5, 0.5],
    [true, false, true, false, true, false, true, false, true, false]
)








