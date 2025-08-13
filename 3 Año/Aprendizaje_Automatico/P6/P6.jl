using ScikitLearn

@sk_import svm: SVC 
@sk_import tree: DecisionTreeClassifier 
@sk_import neighbors: KNeighborsClassifier

#A continuación se muestran 3 ejemplos, uno para cada tipo de modelo que se va a usar en estas 
#prácticas de esta asignatura: 
#model = SVC(kernel=”rbf”, degree=3, gamma=2, C=1); 
#model = DecisionTreeClassifier(max_depth=4, random_state=1) 
#model = KNeighborsClassifier(3); 


