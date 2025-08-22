package e2;

import java.util.*;

public class DependenciaDebil implements Algoritmo{

    List<Tarea> cola = new ArrayList<>();
    List<Tarea> lista = new ArrayList<>();

    @Override
    public String ordenar(Tarea ... raiz) {

        StringBuilder info = new StringBuilder();
        Tarea tareaAnalizada;
        int i, j;

        cola.addAll(Arrays.asList(raiz));

        while(!cola.isEmpty()){

            for (i = 0; i<cola.size(); i++){

                raiz[0].ordenaList(cola);

                tareaAnalizada = cola.get(0);

                lista.add(tareaAnalizada);
                cola.remove(tareaAnalizada);

                if (tareaAnalizada.getSig() != null){
                    cola.add(tareaAnalizada.getSig());
                }
                if (tareaAnalizada.getAnt() != null){
                    cola.add(tareaAnalizada.getAnt());
                }
                for(j = 0; j<cola.size();j++){
                    if(lista.contains(cola.get(j))){
                        cola.remove(cola.get(j));
                    }
                }
            }
        }
        for (Tarea tarea : lista) {
            info.append(tarea.getDato()).append(" ");
        }
        return info.toString();
    }
}