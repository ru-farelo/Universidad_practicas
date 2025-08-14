#!/bin/bash

# Directorios donde se encuentran los archivos de prueba
TEST_DIR_FAIL="./test/fail/"
TEST_DIR_PASS="./test/pass/"

# Ejecutable
EXECUTABLE="./practica"

# Función para ejecutar pruebas en un directorio
run_tests() {
    local dir=$1
    local expected_result=$2
    
    echo "Ejecutando pruebas en $dir (Resultado esperado: $expected_result)"
    echo "----------------------------------------"
    
    for test_file in "$dir"/*
    do
        if [ -f "$test_file" ]; then
            echo "Ejecutando prueba: $test_file"
            $EXECUTABLE < "$test_file"
            exit_code=$?
            
            if [ $exit_code -eq 0 ] && [ "$expected_result" == "PASS" ]; then
                echo "Resultado: PASS (como se esperaba)"
            elif [ $exit_code -ne 0 ] && [ "$expected_result" == "FAIL" ]; then
                echo "Resultado: FAIL (como se esperaba)"
            else
                echo "Resultado: INESPERADO (se esperaba $expected_result)"
            fi
            echo "----------------------------------------"
        fi
    done
}

# Ejecutar pruebas que deberían fallar
run_tests "$TEST_DIR_FAIL" "FAIL"

# Ejecutar pruebas que deberían pasar
run_tests "$TEST_DIR_PASS" "PASS"

echo "Todas las pruebas han sido ejecutadas."