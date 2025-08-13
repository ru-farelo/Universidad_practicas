package e4;

import java.util.ArrayList;
import java.util.Objects;

public class Calculator {

    private boolean first = true;
    ArrayList<String> operaciones = new ArrayList<>();
    ArrayList<Float> operandos = new ArrayList<>();

    enum Operations{
        SUMA("+"),
        RESTA("-"),
        MULTIPLICACION("*"),
        DIVISION("/");

        String simbolo;

        Operations(String simbol){
            this.simbolo = simbol;
        }
    }

    public Calculator () {
    }

    public void cleanOperations () {
        first = true;
        operaciones.clear();
        operandos.clear();
    }

    public void addOperation(String operation , float ... values) {

        if(first){
            first = false;
            operandos.add(values[0]);
            operandos.add(values[1]);
        }
        else{
            operandos.add(values[0]);
        }
        if(operation == null){
            cleanOperations();
            throw new IllegalArgumentException();
        }
        else if((!Objects.equals(operation, Operations.SUMA.simbolo)) && (!Objects.equals(operation,Operations.RESTA.simbolo)) && (!Objects.equals(operation,Operations.MULTIPLICACION.simbolo))
                && (!Objects.equals(operation,Operations.DIVISION.simbolo))){
            cleanOperations();
            throw new IllegalArgumentException();
        }
        operaciones.add(operation);
    }

    public float executeOperations () {

        int i;
        Float operationPrev = operandos.get(0);

        for(i = 0; i<operaciones.size(); i++){
            if(Objects.equals(operaciones.get(i),Operations.SUMA.simbolo)){
                operationPrev += operandos.get(i+1);
            }
            else if(Objects.equals(operaciones.get(i),Operations.RESTA.simbolo)){
                operationPrev -= operandos.get(i+1);
            }
            else if(Objects.equals(operaciones.get(i),Operations.MULTIPLICACION.simbolo)){
                operationPrev *= operandos.get(i+1);
            }
            else if(Objects.equals(operaciones.get(i),Operations.DIVISION.simbolo)){
                if (operandos.get(i+1)==0) { // n/0
                    cleanOperations();
                    throw new ArithmeticException();
                }
                operationPrev /= operandos.get(i+1);
            }
        }
        cleanOperations();
        return operationPrev;
    }

    @Override
    public String toString () {

        int i;
        StringBuilder cadena  = new StringBuilder();
        cadena.append("[STATE:");

        if(operaciones.size() > 0){
            cadena.append("[").append(operaciones.get(0)).append("]").append(operandos.get(0)).append("_").append(operandos.get(1));
            for(i=1; i < operaciones.size(); i++){
                cadena.append("[").append(operaciones.get(i)).append("]").append(operandos.get(i+1));
            }
        }
        cadena.append("]");
        return cadena.toString();
    }
}