# Nombre del programa a generar
TARGET = practica

# Archivos de salida
BISON_FILE = practica.y
FLEX_FILE = practica.l
BISON_OUTPUT = practica.tab.c
FLEX_OUTPUT = lex.yy.c
HEADER_FILE = practica.tab.h
SCRIPT = test.sh
PRUEBA = ./test/pass/testP01.txt
OUTPUT = practica.output

# Comandos
BISON = bison
FLEX = flex
GCC = gcc

# Opciones de Bison
BISON_FLAGS = -o $(BISON_OUTPUT) -d -r all

# Regla principal
all: $(TARGET)

# Compilación del programa final
$(TARGET): $(BISON_OUTPUT) $(FLEX_OUTPUT)
	$(GCC) -o $(TARGET) $(BISON_OUTPUT) $(FLEX_OUTPUT) -lfl 

# Generar el archivo practica.tab.c a partir de practica.y
$(BISON_OUTPUT): $(BISON_FILE)
	$(BISON) $(BISON_FLAGS) $(BISON_FILE) 

# Generar el archivo lex.yy.c a partir de practica.l
$(FLEX_OUTPUT): $(FLEX_FILE)
	$(FLEX) $(FLEX_FILE)

run:
	./$(TARGET) < $(PRUEBA) 

run2:
	./$(TARGET)  $(PRUEBA)

# Limpiar archivos generados
clean:
	rm -f $(BISON_OUTPUT) $(FLEX_OUTPUT) $(HEADER_FILE) $(TARGET) $(OUTPUT)

# Forzar la regeneración de practica.tab.h
$(HEADER_FILE): $(BISON_FILE)
	$(BISON) $(BISON_FLAGS) $(BISON_FILE)

# Ejecutar el script de pruebas
test: $(TARGET)
	@echo "Ejecutando las pruebas..."
	@chmod +x $(SCRIPT)  # Asegurarse de que el script tiene permisos de ejecución
	@./$(SCRIPT)         # Ejecutar el script de pruebas

# Mostrar instrucciones de uso
help:
	@echo "Makefile para generar el validador XML"
	@echo "Uso:"
	@echo "  make            - Compila el programa $(TARGET)"
	@echo "  make clean      - Elimina archivos generados"
	@echo "  make help       - Muestra este mensaje de ayuda"
	@echo "  make test       - Ejecuta el script de pruebas $(SCRIPT)"