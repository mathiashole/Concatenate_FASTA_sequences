import sys
import os
#from datetime import datetime

file_paths = sys.argv[1:]  # Obtener los nombres de archivo pasados como argumentos

data = {}  # Diccionario para almacenar los datos de los archivos

# Leer los IDs y textos de los archivos
for file_path in file_paths:
    with open(file_path, 'r') as file:
        lines = file.read().splitlines()

    current_id = None

    for line in lines:
        if line.startswith('>'):
            current_id = line
            data.setdefault(current_id, '')
        else:
            data[current_id] += line

# Depuración: Imprimir los datos leídos
#for file_path, file_data in data.items():
#    print(f"{file_path}:")
#    print(file_data)

resultados = ""
for file_path, file_data in data.items():
    resultados += f"{file_path}\n"
    resultados += str(file_data) + "\n"

#print(resultados)

# Crear la carpeta "concatResult" si no existe
output_folder = 'concatResult'
if not os.path.exists(output_folder):
    os.makedirs(output_folder)


# Escribir los resultados en un nuevo archivo dentro de la carpeta "concatResult"
output_file_path = os.path.join(output_folder, 'concatSeq.fasta')
with open(output_file_path, 'w') as output_file:
    output_file.write(resultados)

# Generar el nombre de archivo con fecha y hora actual
#current_datetime = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
#output_file_name = f'concatSeq_{current_datetime}.fasta'

# Crear la ruta completa al archivo de salida
#output_file_path = os.path.join(output_folder, output_file_name)

# Escribir los resultados en el archivo de salida
#with open(output_file_path, 'w') as output_file:
#    output_file.write(resultados)


print(f"El resultado se ha guardado en el archivo {output_file_path}")
