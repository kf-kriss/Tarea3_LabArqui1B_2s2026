# Makefile para Tarea 3 

AS = aarch64-linux-gnu-as
LD = aarch64-linux-gnu-ld
GDB = gdb-multiarch
QEMU = qemu-aarch64

SRC = main.s
OBJ = main.o
TARGET = programa

all: $(TARGET)

# Paso 1: Ensamblar (convierte main.s a main.o)
$(OBJ): $(SRC)
	$(AS) -g $(SRC) -o $(OBJ)

# Paso 2: Enlazar (convierte main.o al ejecutable 'programa')
$(TARGET): $(OBJ)
	$(LD) $(OBJ) -o $(TARGET)

# Paso 3: Ejecutar con QEMU
run: $(TARGET)
	$(QEMU) ./$(TARGET)

# Depuración con GDB
debug: $(TARGET)
	$(QEMU) -g 1234 ./$(TARGET) &
	$(GDB) ./$(TARGET) -ex "target remote :1234"

# Limpieza de archivos generados
clean:
	rm -f $(OBJ) $(TARGET)
