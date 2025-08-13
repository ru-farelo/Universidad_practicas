#  Si se realiza este segundo bucle con un modelo determinístico, ¿cuál será la desviación típica 
#de los resultados obtenidos en test

#Si se realiza el segundo bucle con un modelo determinístico, es decir, un modelo cuyo entrenamiento 
#siempre produce los mismos resultados dado un conjunto de datos y una inicialización de pesos fija, 
#entonces la desviación típica de los resultados obtenidos en el test sería cero.


# ¿Existe alguna diferencia entre realizar este segundo 
#bucle y promediar los resultados, o hacer un único entrenamiento? 

#Realizar el segundo bucle y promediar los resultados ofrece una evaluación más confiable
 #y representativa del rendimiento del modelo en datos no vistos en comparación con un único entrenamiento.

using Random
include("../P2/pruebasconIris.jl")
function crossvalidation(N::Int64, k::Int64)
    # Paso 1: Crear un vector con k elementos ordenados desde 1 hasta k
    subconjuntos = collect(1:k)
    
    # Paso 2: Crear un vector nuevo con repeticiones de subconjuntos
    subconjuntos_repetidos = repeat(subconjuntos, ceil(Int, N / k))
    
    # Paso 3: Tomar los N primeros valores
    subconjuntos_final = subconjuntos_repetidos[1:N]
    
    # Paso 4: Desordenar el vector utilizando shuffle!
    Random.seed!(123)  # Fijar la semilla aleatoria para reproducibilidad
    shuffle!(subconjuntos_final)
    
    return subconjuntos_final
end

function crossvalidation(targets::AbstractArray{Bool,1}, k::Int64)
    # Paso 1: Crear un vector de índices con tantos valores como filas en targets
    indices = 1:length(targets)
    
    # Paso 2 y 3: Asignar subconjuntos a instancias positivas
    indices[targets] .= crossvalidation(sum(targets), k)
    
    # Paso 4 y 5: Asignar subconjuntos a instancias negativas
    indices[.!targets] .= crossvalidation(sum(.!targets), k)
    
    return indices
end

#3.¿Podrías hacer estas 2 operaciones en una sola línea? (Esto no es un requisito 
#de la función)


#Sí, es posible realizar ambas operaciones en una sola línea utilizando el broadcasting y el índice lógico
#indices .= ifelse.(targets, crossvalidation(sum(targets), k), indices)


function crossvalidation(targets::AbstractArray{Bool,2}, k::Int64)
    # Obtener los tamaños de los arrays
    n, m = size(targets)
    
    # Crear un vector de índices con tantos valores como filas en targets
    indices = collect(1:n)
    
    # Paso 2: Iterar sobre las clases y realizar la estratificación
    for clase in 1:m
        # Calcular los subconjuntos para la clase actual
        subconjuntos = crossvalidation(sum(targets[:, clase]), k)
        
        # Verificar que el tamaño de subconjuntos coincida con el número de filas en targets
        if length(subconjuntos) != n
            error("Dimension mismatch: Size of subconjuntos does not match the number of rows in targets.")
        end
        
        # Asignar los subconjuntos a los índices correspondientes
        for i in eachindex(indices)
            indices[i] = ifelse(targets[i, clase], subconjuntos[i], indices[i])
        end
    end
    
    return indices
end





#  ¿Podrías hacer estas 3 operaciones en una sola línea? (Esto no es un requisito  de la función) 
#Sí, es posible realizar estas tres operaciones en una sola línea utilizando el broadcasting y el índice lógico.

# indices .= ifelse.(targets, repeat(crossvalidation.(sum(targets, dims=1), k), size(targets, 1)), indices)

#¿Qué ocurriría si alguna clase tiene un número de patrones inferior a k? ¿Qué 
#consecuencias tendría a la hora de calcular las métricas?

#si alguna clase tiene un número de patrones inferior a k, podría llevar a problemas de estratificación, 
#sesgo en la evaluación del modelo y estimaciones poco confiables de las métricas de desempeño.
# Es fundamental asegurarse de tener suficientes instancias de cada clase para una evaluación precisa 
# y confiable del model




function crossvalidation(targets::AbstractArray{<:Any,1}, k::Int64)
    # Verificar el número de clases en los targets
    num_clases = length(unique(targets))
    
    # Si hay más de dos clases, aplicar one-hot encoding
    if num_clases > 2
        targets_encoded = oneHotEncoding(targets)
    else
        targets_encoded = targets
    end
    
    # Llamar a la función crossvalidation con los targets encodificados
    return crossvalidation(targets_encoded, k)
end


#¿Podrías desarrollar esta función sin llamar a oneHotEncoding?
  
function crossvalidation(targets::AbstractArray{<:Any,1}, k::Int64)
    # Crear un diccionario para mapear clases a índices únicos
    clase_indices = Dict(unique(targets) .=> 1:length(unique(targets)))
    
    # Codificar los objetivos utilizando el diccionario
    targets_encoded = [clase_indices[t] for t in targets]
    
    # Llamar a la función crossvalidation con los targets encodificados
    return crossvalidation(targets_encoded, k)
end


function ANNCrossValidation(topology::AbstractArray{<:Int,1}, 
    inputs::AbstractArray{<:Real,2}, 
    targets::AbstractArray{<:Any,1}, 
    crossValidationIndices::Array{Int64,1}; 
    numExecutions::Int=50, 
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)), 
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01, 
    validationRatio::Real=0, maxEpochsVal::Int=20)

    # Calcular el número de folds
    num_folds = maximum(crossValidationIndices)

    # Inicializar vectores para almacenar las métricas
    precision = zeros(num_folds)
    error_rate = zeros(num_folds)
    sensitivity = zeros(num_folds)
    specificity = zeros(num_folds)
    VPP = zeros(num_folds)
    VPN = zeros(num_folds)
    F1 = zeros(num_folds)

    # Bucle sobre los folds
    for fold in 1:num_folds
        # Obtener índices para entrenamiento y test
        train_indices = findall(x -> x != fold, crossValidationIndices)
        test_indices = findall(x -> x == fold, crossValidationIndices)

        # Separar datos de entrenamiento y test
        inputs_train = inputs[:, train_indices]
        targets_train = targets[train_indices]
        inputs_test = inputs[:, test_indices]
        targets_test = targets[test_indices]

        # Bucle para repetir el entrenamiento numExecutions veces
        for _ in 1:numExecutions
            # Entrenar RNA
            model, _ = trainClassANN(topology, (inputs_train, targets_train);
                                    transferFunctions=transferFunctions,
                                    maxEpochs=maxEpochs, minLoss=minLoss,
                                    learningRate=learningRate)

            # Evaluar con el conjunto de test
            outputs = model(inputs_test)'
            cm = confusionMatrix(classifyOutputs(outputs), targets_test)

            # Almacenar métricas
            precision[fold] += cm.precision
            error_rate[fold] += cm.error_rate
            sensitivity[fold] += cm.sensitivity
            specificity[fold] += cm.specificity
            VPP[fold] += cm.VPP
            VPN[fold] += cm.VPN
            F1[fold] += cm.F1
        end

        # Calcular medias de las métricas para este fold
        precision[fold] /= numExecutions
        error_rate[fold] /= numExecutions
        sensitivity[fold] /= numExecutions
        specificity[fold] /= numExecutions
        VPP[fold] /= numExecutions
        VPN[fold] /= numExecutions
        F1[fold] /= numExecutions
    end

    # Calcular medias y desviaciones típicas de las métricas
    precision_mean = mean(precision)
    error_rate_mean = mean(error_rate)
    sensitivity_mean = mean(sensitivity)
    specificity_mean = mean(specificity)
    VPP_mean = mean(VPP)
    VPN_mean = mean(VPN)
    F1_mean = mean(F1)

    precision_std = std(precision)
    error_rate_std = std(error_rate)
    sensitivity_std = std(sensitivity)
    specificity_std = std(specificity)
    VPP_std = std(VPP)
    VPN_std = std(VPN)
    F1_std = std(F1)

    # Devolver resultados como tuplas
    precision_results = (precision_mean, precision_std)
    error_rate_results = (error_rate_mean, error_rate_std)
    sensitivity_results = (sensitivity_mean, sensitivity_std)
    specificity_results = (specificity_mean, specificity_std)
    VPP_results = (VPP_mean, VPP_std)
    VPN_results = (VPN_mean, VPN_std)
    F1_results = (F1_mean, F1_std)

    return precision_results, error_rate_results, sensitivity_results, specificity_results, VPP_results, VPN_results, F1_results
end


#  transferFunctions, con las funciones de activación o transferencia de la RNA.
# ¿Tendría sentido usar una función de transferencia lineal en las 
#neuronas de las capas ocultas? 

#No, usar una función de transferencia lineal en las neuronas de las capas ocultas
#no tendría mucho sentido en la mayoría de los casos. La razón principal es que una 
#función de transferencia lineal simplemente produciría una combinación lineal de las entradas, 
#lo que resultaría en una red neuronal que no puede modelar relaciones no lineales complejas entre 
#las características de entrada y las salidas.

# Quiero probar la función de transferencia ReLU en las neuronas de las capas ocultas. con mi dataset iris
# podrias hacer las pruebas correspondientes


# Cargar el dataset iris
ruta = pwd()
ruta_completa = ruta * "\\iris\\iris.data"
dataset = readdlm(ruta_completa, ',')
inputs = dataset[:, 1:4]
targets = dataset[:, 5]



