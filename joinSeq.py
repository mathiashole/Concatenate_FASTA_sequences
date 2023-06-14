import sys
import os
#from datetime import datetime

file_paths = sys.argv[1:]  # Get the filenames passed as arguments

data = {}  # Dictionary to store file data

# Read file IDs and texts
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

# Debug: Print the data read
#for file_path, file_data in data.items():
#    print(f"{file_path}:")
#    print(file_data)

resultados = ""
for file_path, file_data in data.items():
    resultados += f"{file_path}\n"
    resultados += str(file_data) + "\n"

#print(resultados)

# Create "concatResult" folder if it doesn't exist
output_folder = 'concatResult'
if not os.path.exists(output_folder):
    os.makedirs(output_folder)


# Write the results to a new file inside the "concatResult" folder
output_file_path = os.path.join(output_folder, 'concatSeq.fasta')
with open(output_file_path, 'w') as output_file:
    output_file.write(resultados)

# Generate file name with current date and time
#current_datetime = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
#output_file_name = f'concatSeq_{current_datetime}.fasta'

# Create the full path to the output file
#output_file_path = os.path.join(output_folder, output_file_name)

# Write the results to the output file
#with open(output_file_path, 'w') as output_file:
#    output_file.write(resultados)


print(f"The result has been saved to the file {output_file_path}")
