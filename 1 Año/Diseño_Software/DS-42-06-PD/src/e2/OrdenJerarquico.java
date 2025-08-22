package e2;

import java.util.ArrayList;
import java.util.List;

public class OrdenJerarquico implements Algoritmo{

    List<Tarea> cola = new ArrayList<>();
    List<Tarea> lista = new ArrayList<>();

    @Override
    public String ordenar(Tarea ... raiz) {

        StringBuilder info = new StringBuilder();
        Tarea tareaAnalizada;
        int i, j, z;

        for(z = 0; z< raiz.length;z++){
            cola.add(raiz[z]);
            raiz[z].ordenaList(cola);
        }

        while (!cola.isEmpty()){

            for(i = 0; i<cola.size();i++){

                tareaAnalizada = cola.get(0);
                lista.add(cola.get(0));
                cola.remove(cola.get(0));

                if (tareaAnalizada.getSig() != null){
                    cola.add(tareaAnalizada.getSig());
                }
                if (tareaAnalizada.getAnt() != null){
                    cola.add(tareaAnalizada.getAnt());
                }

                for(j = 0; j<cola.size();j++){
                    if(lista.contains(tareaAnalizada)){
                        cola.remove(tareaAnalizada);
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