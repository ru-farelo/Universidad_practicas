package e2;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class DependenciaFuerte implements Algoritmo{

    List<Tarea> lista = new ArrayList<>();
    List<Tarea> tareaUltima = new ArrayList<>();
    List<Tarea> auxCola = new ArrayList<>();
    List<Tarea> cola = new ArrayList<>();

    @Override
    public String ordenar(Tarea ... raiz) {

        auxCola.addAll(Arrays.asList(raiz));
        StringBuilder info = new StringBuilder();
        Tarea tareaAnalizada;
        int i,j, cnt;

        for (Tarea value : raiz) {
            cola.add(value);
            value.ordenaList(cola);
        }
        while (!cola.isEmpty()) {
            for (i = 0; i < cola.size(); i++) {

                raiz[0].ordenaList(cola);
                tareaAnalizada = cola.get(i);

                if (tareaAnalizada.getSig() == null && tareaAnalizada.getAnt() == null){
                    tareaUltima.add(tareaAnalizada);
                    tareaAnalizada.ordenaList(tareaUltima);
                }

                cola.remove(tareaAnalizada);

                if (tareaAnalizada.getSig() != null){
                    cola.add(tareaAnalizada.getSig());
                }
                if (tareaAnalizada.getAnt() != null){
                    cola.add(tareaAnalizada.getAnt());
                }

                if(tareaAnalizada.getPadres().isEmpty()) {
                    if(!lista.contains(tareaAnalizada)){
                        lista.add(tareaAnalizada);
                        tareaUltima.add(tareaAnalizada);
                        cola.remove(tareaAnalizada);
                        break;
                    }
                }
                else{
                    cnt = 0;
                    for(j = 0; j < tareaUltima.size();j++){
                        if(tareaAnalizada.getPadres().contains(tareaUltima.get(j).getDato())){
                            cnt += 1;
                        }
                    }
                    if(cnt == tareaAnalizada.getPadres().size()){
                        if(!lista.contains(tareaAnalizada)){
                            lista.add(tareaAnalizada);
                            tareaUltima.add(tareaAnalizada);
                            cola.remove(tareaAnalizada);
                            break;
                        }
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