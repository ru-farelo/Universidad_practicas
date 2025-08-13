#####  Desarrollar una función llamada holdOut que dados dos parámetros, N (igual al número de patrones) y P (valor entre 0 y 1, que indica el porcentaje de patrones que se separarán para el conjunto de test), devuelva una tupla con dos vectores con los índices de los patrones que serán utilizados para entrenamiento y test. La suma de longitudes de ambos vectores tiene que ser igual a N, y estos dos vectores tienen que ser disjuntos. 

###### * Esta función se puede hacer en de una forma muy sencilla usando la función randperm (para usarla, cargar el módulo con using Random) 

###### A partir de esta función, partir una base de datos en dos subconjuntos se realiza de una forma inmediata. 
######  Para realizar esta función no se permite el uso de bucles. 
######  Ejemplo de uso:

function holdOut(N::Int, P::Real)
    if P < 0 || P > 1
        error("P debe ser un valor entre 0 y 1")
    end
    if N < 1
        error("N debe ser un valor mayor a 0")
    end
    indices = randperm(N)
    n_test = round(Int, N*P)
    return indices[n_test+1:end], indices[1:n_test]
end


##### Desarrollar otra función llamada holdOut, igual que en la anterior y que, basándose en ella, tome 3 parámetros: N (número de patrones), Pval (tasa de patrones en el conjunto de validación) y Ptest (tasa de patrones en el conjunto de test), y devuelva una tupla con 3 vectores, con los índices de los elementos de los conjuntos de entrenamiento, validación y test. La suma de las longitudes de estos 3 vectores tiene que ser igual a N. 
###### * Para realizar esto, simplemente hay que hacer dos llamadas a la función holdOut desarrollada previamente. 
###### Al igual que en la función anterior, para realizar esta no se permite el uso de bucles

function holdOut(N::Int, Pval::Real, Ptest::Real) 
    if Pval < 0 || Pval > 1 || Ptest < 0 || Ptest > 1
        error("Pval y Ptest deben ser valores entre 0 y 1")
    end
    if N < 1
        error("N debe ser un valor mayor a 0")
    end
    if Pval + Ptest > 1
        error("La suma de Pval y Ptest debe ser menor o igual a 1")
    end
    indices = randperm(N)
    n_val = round(Int, N*Pval)
    n_test = round(Int, N*Ptest)
    return indices[n_val+n_test+1:end], indices[n_val+1:n_val+n_test], indices[1:n_val]
end




#ESTA ES LA PRIMERA TRAIN CLASS DE LA PRÁCTICA ANTERIOR
function trainClassANN(topology::AbstractArray{<:Int,1},
    dataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}};
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01)
    
    inputs = dataset[1]'
    targets = dataset[2]'
    loss_vector = zeros(maxEpochs)
    numInputs = size(inputs, 1)
    numOutputs = size(targets, 1)
    ann = buildClassANN(numInputs, topology, numOutputs; transferFunctions=transferFunctions)
    loss(model, x,y) = (size(y,1) == 1) ? Losses.binarycrossentropy(model(x),y) : Losses.crossentropy(model(x),y);
    opt_state = Flux.setup(Adam(learningRate), ann)
    for epoch in 1:maxEpochs
      
        Flux.train!(loss, ann, [(inputs,targets)], opt_state)
        loss_vector[epoch] = loss(ann, inputs, targets)
        if loss(ann, inputs, targets) <= minLoss
            break
        end
    end 
    return (ann, loss_vector)
end 

#Modificar la función trainClassANN de entrenamiento de la RNA realizada en la práctica 
#anterior para que acepte los siguientes parámetros opcionales a mayores de los definidos en 
#la práctica anterior: 
#o Conjunto de validación, de tipo Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}, 
#es decir, una tupla de 2 matrices: entradas y salidas deseadas. Su valor por defecto 
#son matrices vacías. 
#o Conjunto de test, de tipo Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}, es 
#decir, una tupla de 2 matrices: entradas y salidas deseadas. Su valor por defecto son 
#matrices vacías. 
#o maxEpochsVal, de tipo Int, que define el número de ciclos sin mejorar el mejor loss de 
#validación encontrado hasta el momento que han de transcurrir para parar el 
#entrenamiento. Es decir, define un nuevo criterio de parada. Su valor por defecto es 
#20. 
#Con estos parámetros, esta función debería implementar la estrategia de parada temprana, 
#para lo cual es necesario tener cuidado con que la RNA que se devuelve al final de la función 
#debe ser: 
# Si se ha pasado un conjunto de validación como parámetro (es decir, si este 
#no es vacío), la RNA a devolver no tiene que ser la que se está entrenando, 
#sino la que haya obtenido un mejor error de validación. 
# Si no se ha pasado un conjunto de validación como parámetro (es decir, si 
#este es vacío), la RNA a devolver deberá ser la correspondiente al último ciclo 
#de entrenamiento. Por lo tanto, esta nueva función de entrenamiento debería 
#funcionar igual que la anterior en caso de que no se pase como parámetro un 
#conjunto de validación. 
#Además, esta función debería devolver una tupla con 4 elementos. El primero debe de ser la 
#RNA entrenada, y los 3 siguientes deberían de ser vectores con los valores de loss obtenidos 
#en los conjuntos de entrenamiento, validación y test en cada ciclo. 
#o Para añadir elementos al final de un vector, consultar la función push!
#o Tened en cuenta que los valores de loss obtenidos con la RNA con pesos aleatorios, 
#previos a realizar el entrenamiento, se suelen considerar como el ciclo 0. 
#Como se pone en la descripción anterior, será necesario almacenar la mejor RNA alcanzada 
#hasta el momento y actualizarla en algunas iteraciones del bucle. Para realizar esto, no se 
#puede hacer sencillamente una asignación a una nueva variable, puesto que sólo se asignaría 
#el puntero, que apuntaría a la misma dirección de memoria con la RNA que se modificaría en 
#la siguiente iteración. Para hacer una copia de un objeto de tal forma que todos los objetos (y 
#datos, como en este caso pesos y bias) que contiene se copien también, de forma recursiva, 
#se puede usar la función deepcopy. 
#Al igual que en la práctica anterior, para realizar esta función se puede utilizar un único bucle, 
#para iterar por los ciclos de entrenamiento o epochs


function trainClassANN(topology::AbstractArray{<:Int,1}, 
    trainingDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}};
    validationDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}=
        (Array{eltype(trainingDataset[1]),2}(undef,0,0), falses(0,0)),
    testDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,2}}=
        (Array{eltype(trainingDataset[1]),2}(undef,0,0), falses(0,0)),
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01, 
    maxEpochsVal::Int=20)

inputs = trainingDataset[1]'
targets = trainingDataset[2]'
numInputs = size(inputs, 1)
numOutputs = size(targets, 1)
ann = buildClassANN(numInputs, topology, numOutputs; transferFunctions=transferFunctions)

loss(model, x, y) = (size(y,1) == 1) ? Losses.binarycrossentropy(model(x),y) : Losses.crossentropy(model(x),y)

opt_state = Flux.setup(Adam(learningRate), ann)

loss_vector_train = zeros(maxEpochs)
loss_vector_val = zeros(maxEpochs)
loss_vector_test = zeros(maxEpochs)

best_ann = deepcopy(ann)
best_loss_val = Inf
patience = 0

for epoch in 1:maxEpochs
Flux.train!(loss, ann, [(inputs, targets)], opt_state)

loss_vector_train[epoch] = loss(ann, inputs, targets)

if !isempty(validationDataset[1])
inputs_val = validationDataset[1]'
targets_val = validationDataset[2]'
loss_vector_val[epoch] = loss(ann, inputs_val, targets_val)

if loss_vector_val[epoch] < best_loss_val
best_loss_val = loss_vector_val[epoch]
best_ann = deepcopy(ann)
patience = 0
else
patience += 1
if patience >= maxEpochsVal
 break
end
end
end

if !isempty(testDataset[1])
inputs_test = testDataset[1]'
targets_test = testDataset[2]'
loss_vector_test[epoch] = loss(ann, inputs_test, targets_test)
end
end 

if isempty(validationDataset[1])
best_ann = deepcopy(ann)
end

return (best_ann, loss_vector_train[1:epoch], loss_vector_val[1:epoch], loss_vector_test[1:epoch])
end 



# ESTA ES LA SEGUNDA TRAIN CLASS DE LA PRÁCTICA ANTERIOR

function trainClassANN(topology::AbstractArray{<:Int,1},
    (inputs, targets)::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}};
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01) 

    targets = reshape(targets, (size(targets, 2), 1))
    trainClassANN(topology, (inputs, targets); transferFunctions = transferFunctions, maxEpochs, minLoss, learningRate)
end

#Dado que había dos versiones de la función de entrenamiento de RR.NN.AA. (la segunda 
#aceptaba como salidas deseadas un vector), modificar de la misma manera esta función para 
#que las salidas deseadas sean vectores en lugar de matrices para el caso de clasificación en 
#dos clases. Tened en cuenta que en este caso los tipos de los conjuntos de entrenamiento, 
#validación y test pasados como parámetros serán Tuple{AbstractArray{<:Real,2}, 
#AbstractArray{Bool,1}} para los tres y por tanto será necesario llamar a la función reshape en 
#los tres. 
#Esta función debe devolver lo mismo que la anterior. Además, al igual que en la práctica 
#anterior, esta función no debe utilizar ningún bucle. 

function trainClassANN(topology::AbstractArray{<:Int,1},
    (inputs, targets)::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}};
    validationDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}=
        (Array{eltype(inputs),2}(undef,0,0), falses(0)),
    testDataset::Tuple{AbstractArray{<:Real,2}, AbstractArray{Bool,1}}=
        (Array{eltype(inputs),2}(undef,0,0), falses(0)),
    transferFunctions::AbstractArray{<:Function,1}=fill(σ, length(topology)),
    maxEpochs::Int=1000, minLoss::Real=0.0, learningRate::Real=0.01, 
    maxEpochsVal::Int=20) 

    targets = reshape(targets, (size(targets, 2), 1))
    trainClassANN(topology, (inputs, targets); validationDataset, testDataset, transferFunctions, maxEpochs, minLoss, learningRate, maxEpochsVal)
end

#Integrar el código con el resultante de las prácticas anteriores, de tal manera que la secuencia 
#de pasos sea la siguiente: 
#1. Cargar la base de datos, teniendo los patrones en filas y atributos y salidas deseadas en 
# columnas.

using DelimitedFiles
using Flux, Plots
using Random

include("../P2/P2.jl")
ruta = pwd()
ruta_completa = ruta*"\\iris\\iris.data"
dataset = readdlm(ruta_completa, ',')
inputs = dataset[:, 1:4]
targets = dataset[:, 5]

#Codificar las salidas deseadas al formato correcto.

inputs = convert(Array{Float32, 2}, inputs)
targets = oneHotEncoding(targets)

#Normalizar los datos de entrada.

normalized_inputs = normalizeMinMax(inputs)

#2. Utilizar la función holdOut para dividir el conjunto de datos en entrenamiento, validación 
#y test con los porcentajes que se desee. Estos porcentajes pueden ser igual a 0. Se tendrá, 
#por lo tanto, 6 matrices: entradas y salidas deseadas en entrenamiento, validación y test 
#(algunas podrían estar vacías si el porcentaje correspondiente es 0). 

indices_train, indices_val, indices_test = holdOut(size(inputs, 1), 0.6, 0.2)
trainingDataset = (normalized_inputs[indices_train, :], targets[indices_train, :])
validationDataset = (normalized_inputs[indices_val, :], targets[indices_val, :])
testDataset = (normalized_inputs[indices_test, :], targets[indices_test, :])

#Calcular los valores de los parámetros correspondientes al tipo de normalización que se 
#va a usar con vuestros datos (máximo/mínimo o media/desviación típica para cada 
#atributo), únicamente del conjunto de entrenamiento. 
# En esta parte no se pide normalizar el conjunto de entrenamiento, sino calcular 
#los valores de normalización a partir del conjunto de entrenamiento. 

maximos = maximum(trainingDataset[1], dims=1)
minimos = minimum(trainingDataset[1], dims=1)
medias = mean(trainingDataset[1], dims=1)
desviaciones = std(trainingDataset[1], dims=1)

# 4. Con estos valores calculados en el paso anterior, normalizar conjuntos de entrenamiento, validación y test. 

normalized_training_inputs = normalizeMinMax(trainingDataset[1], (maximos, minimos))
normalized_validation_inputs = normalizeMinMax(validationDataset[1], (maximos, minimos))
normalized_test_inputs = normalizeMinMax(testDataset[1], (maximos, minimos))

#5. Entrenar distintas arquitecturas, y, para cada una de ellas, sacar gráficas de cómo ha sido 
#la evolución de los valores de loss de entrenamiento, validación y test en la misma 
#gráfica, incluyendo el ciclo 0. 

topologies = [[8], [10, 6], [50, 100, 50, 20]]

# Realiza pruebas 
plot_layout1 = plot(xlabel="Epoch", ylabel="Loss", title="Loss: Unnormalized Data")
for topology in topologies
    _, lossVector = trainClassANN(topology, (trainingDataset[1], trainingDataset[2]))
    plot!(lossVector, label=string(topology))
end

plot_layout2 = plot(xlabel="Epoch", ylabel="Loss", title="Loss: Normalized Data")
for topology in topologies
    _, lossVector = trainClassANN(topology, (normalized_training_inputs, trainingDataset[2]))
    plot!(lossVector, label=string(topology))
end


plot(plot_layout1, plot_layout2)


#  ¿El error de test ha disminuido siempre o ha llegado un punto en el que ha empezado a aumentar?

# El error de test ha disminuido siempre, pero en la topología [50, 100, 50, 20] ha llegado un punto en el que ha empezado a aumentar. 
#Esto es debido a que la red ha empezado a sobreajustarse a los datos de entrenamiento, 
#y por tanto, ha empezado a perder generalización.

#  ¿Cómo es la evolución de los 3 valores de precisión?

# La evolución de los 3 valores de precisión es similar, pero el error de test es siempre mayor que el de validación,

#¿Por qué se suele parar el entrenamiento?

# Se suele parar el entrenamiento cuando el error de validación no disminuye durante un número de ciclos determinado,

#¿A qué ciclo se corresponde la RNA que devuelve la función?

# La RNA que devuelve la función se corresponde al ciclo en el que el error de validación ha sido menor.




