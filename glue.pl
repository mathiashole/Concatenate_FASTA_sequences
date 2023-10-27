#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

# # define flag
# my $output_flag = 0;
my $help_flag = 0;
my $version_flag = 0;

# name of flag
GetOptions(
#    "output" => \$output_flag,
"help" => \$help_flag,
"version" => \$version_flag,
);

# Verifica que se proporcionen al menos dos argumentos en la línea de comandos
# if (@ARGV < 2) {
#     die "Uso: $0 archivo1.fasta archivo2.fasta [archivo3.fasta ...] archivo_concatenado.fasta\n";
# }

# Handling command line arguments
if (scalar(@ARGV) == 0 || scalar(@ARGV) == 1) {
    show_help();
} elsif ($help_flag) {
    show_help();
} elsif ($version_flag) {
    show_version();
} else {

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
                #$current_header =~ s/\s.*//; # Elimina cualquier texto después del primer espacio
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
}

# Function to show help
sub show_help {
    print <<'HELP';
Use: genomics concatenat sequece [OPTIONS]

 Opciones disponibles:
    -help, --help     Show this help.
    -version, --version  Show the version of the program.

 Examples:
    glue.pl -help
    glue.pl -version
HELP
}

# Function to show the version of the program
sub show_version {
    print "genomics concate sequence v0.0.1\n";
}
