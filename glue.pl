#!/usr/bin/perl
use strict;
use warnings;

# Verifica que se proporcionen al menos dos argumentos en la línea de comandos
if (@ARGV < 2) {
    die "Uso: $0 archivo1.fasta archivo2.fasta [archivo3.fasta ...] archivo_concatenado.fasta\n";
}

# Último argumento de la línea de comandos es el nombre del archivo concatenado
my $output_file = pop @ARGV;

# Abre el archivo de salida
open my $output_fh, '>', $output_file or die "No se pudo abrir el archivo de salida $output_file: $!";

my $current_header = "";
my $current_sequence = "";

# Hash para almacenar las secuencias por encabezado
my %secuencias_por_encabezado;

# Itera a través de los nombres de archivo proporcionados en la línea de comandos
foreach my $input_file (@ARGV) {
    # Abre el archivo de entrada
    open my $fh, '<', $input_file or die "No se pudo abrir el archivo $input_file: $!";

    # Procesa las líneas del archivo de entrada
    while (my $line = <$fh>) {
        chomp $line;

        if ($line =~ /^>/) {
            # Es un encabezado
            if ($current_header) {
                # Si hay una secuencia anterior, la concatena y la almacena
                $current_header =~ s/\s.*//; # Elimina cualquier texto después del primer espacio
                $secuencias_por_encabezado{$current_header} .= $current_sequence;
            }

            # Inicializa el encabezado y la secuencia actual
            $current_header = $line;
            $current_sequence = "";
        } else {
            # Es una línea de secuencia, la concatena
            $current_sequence .= $line;
        }
    }

    # Almacena la última secuencia
    $secuencias_por_encabezado{$current_header} .= $current_sequence;

    # Cierra el archivo de entrada
    close $fh;
}

# Escribe las secuencias concatenadas en el archivo de salida
foreach my $header (sort keys %secuencias_por_encabezado) {
    print $output_fh "$header\n$secuencias_por_encabezado{$header}\n";
}

# Cierra el archivo de salida
close $output_fh;

print "La concatenación se ha completado en el archivo $output_file.\n";