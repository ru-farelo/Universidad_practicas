package e1;

import java.util.ArrayList;
import e1.Docentes.*;
import e1.Residentes.*;

public class Colegio {

    public final ArrayList<Integrantes> integrantesList;
    public final ArrayList<Residentes> residentesList;

    public Colegio(ArrayList<Integrantes> integrantesList, ArrayList<Residentes> residentesList){
        this.integrantesList = integrantesList;
        this.residentesList = residentesList;
    }

    public String imprimirRecompensa(){

        StringBuilder recompensa = new StringBuilder();
        int i=0;
        float galeones = 0f;
        float galeonesTotal = 0f;

        while(i < integrantesList.size()){
            recompensa.append(integrantesList.get(i).nombre).append(" ").append(integrantesList.get(i).apellido).append("(");

            if(integrantesList.get(i) instanceof Residentes){
                if(integrantesList.get(i) instanceof Estudiantes){
                    galeones = 90;
                    recompensa.append("Estudiante de ");
                    recompensa.append(residentesList.get(i).getCasa()).append(" ,");
                    recompensa.append(integrantesList.get(i).horrocruxes).append(" horrocruxes ): ");

                    if(residentesList.get(i).casa.equals(Casas.Slytherin)){
                        galeones*=2;
                    }
                    recompensa.append(galeones * integrantesList.get(i).horrocruxes).append(" galeones\n");
                }
                else if(integrantesList.get(i) instanceof Fantasmas){
                    galeones = 80;
                    recompensa.append("Fantasma de ");
                    recompensa.append(residentesList.get(i).getCasa());
                    recompensa.append(" ,").append(integrantesList.get(i).horrocruxes).append(" horrocruxes ): ");

                    if(residentesList.get(i).casa.equals(Casas.Slytherin)){
                        galeones*=2;
                    }
                    recompensa.append(galeones * integrantesList.get(i).horrocruxes).append(" galeones\n");
                }
            }
            else if(integrantesList.get(i) instanceof Personal){
                if(integrantesList.get(i) instanceof Docentes){
                    galeones = 50;
                    recompensa.append("Docente de ");
                    recompensa.append((((Docentes) integrantesList.get(i)).getAsignatura())).append(" ,");
                    recompensa.append(integrantesList.get(i).horrocruxes).append(" horrocruxes ): ");

                    if(((Docentes) integrantesList.get(i)).asig.equals(Asignaturas.Defensa)){
                        galeones *= 0.75;
                    }
                    recompensa.append(galeones*integrantesList.get(i).horrocruxes).append(" galeones\n");
                }
                else if(integrantesList.get(i) instanceof Conserjes){
                    galeones = 65;
                    recompensa.append("Conserje ,");
                    recompensa.append(integrantesList.get(i).horrocruxes).append(" horrocruxes ): ");
                    recompensa.append(galeones*integrantesList.get(i).horrocruxes).append(" galeones\n");
                }
                else if(integrantesList.get(i) instanceof Guardabosques){
                    galeones = 75;
                    recompensa.append("Guardabosques ,");
                    recompensa.append(integrantesList.get(i).horrocruxes).append(" horrocruxes ): ");
                    recompensa.append(galeones*integrantesList.get(i).horrocruxes).append(" galeones\n");
                }
            }
            integrantesList.get(i).recompensa = integrantesList.get(i).horrocruxes * galeones;
            galeonesTotal += integrantesList.get(i).recompensa;
            i++;
        }
        recompensa.append("La recompensa total del Colegio Hogwarts es de ").append(galeonesTotal).append(" galeones");
        return recompensa.toString();
    }

    public String imprimirSalarios(){

        StringBuilder salarios = new StringBuilder();
        int i = 0;
        int galeonesSalario = 0;
        int salarioTotal = 0;

        while(i < integrantesList.size()){
            if(integrantesList.get(i) instanceof Guardabosques){
                salarios.append(integrantesList.get(i).nombre).append(" ").append(integrantesList.get(i).apellido).append("(");
                galeonesSalario = 170 + 10;
                salarios.append("Guardabosques ): ");
                salarios.append(galeonesSalario).append(" galeones\n");
            }
            else if(integrantesList.get(i) instanceof Conserjes){
                salarios.append(integrantesList.get(i).nombre).append(" ").append(integrantesList.get(i).apellido).append("(");
                galeonesSalario = 150 + 10;
                salarios.append("Conserje ): ").append(galeonesSalario).append(" galeones\n");
            }
            else if(integrantesList.get(i) instanceof Docentes){
                salarios.append(integrantesList.get(i).nombre).append(" ").append(integrantesList.get(i).apellido).append("(");
                if(((Docentes) integrantesList.get(i)).asig.equals(Asignaturas.Defensa)){
                    galeonesSalario = 500;
                    salarios.append("Docente de Defensa ): ").append(galeonesSalario).append(" galeones\n");
                }
                else if(((Docentes) integrantesList.get(i)).asig.equals(Asignaturas.Transformaciones)){
                    galeonesSalario = 400;
                    salarios.append("Docente de Transformaciones ): ").append(galeonesSalario).append(" galeones\n");
                }
                else if(((Docentes) integrantesList.get(i)).asig.equals(Asignaturas.Pociones)){
                    galeonesSalario = 350;
                    salarios.append("Docente de Pociones ): ").append(galeonesSalario).append(" galeones\n");
                }
                else if(((Docentes) integrantesList.get(i)).asig.equals(Asignaturas.Herbologia)){
                    galeonesSalario = 250;
                    salarios.append("Docente de Herbologia ): ").append(galeonesSalario).append(" galeones\n");
                }
                else if(((Docentes) integrantesList.get(i)).asig.equals(Asignaturas.Historia)){
                    galeonesSalario = 200;
                    salarios.append("Docente de Historia ): ").append(galeonesSalario).append(" galeones\n");
                }
            }
            salarioTotal += galeonesSalario;
            i++;
        }
        salarios.append("El gasto de Hogwarts en personal es de ").append(salarioTotal).append(" galeones");
        return salarios.toString();
    }
}