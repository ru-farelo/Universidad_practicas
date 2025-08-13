using DelimitedFiles 
dataset = readdlm("iris.data",',');
#  ¿Cuál será el resultado de las siguientes llamadas?
inputs = dataset[:,1:4];
targets = dataset[:,5];
typeof(Array{Float64,2}) 
typeof(DataType)
typeof(Any) 

isa(DataType, Any) ;
isa(Any, Any) ;
isa(Array{Float32,2}, Any); 
isa(typeof(Array{Float64,2}), Any) ;







