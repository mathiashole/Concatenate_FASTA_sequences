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

# Handling command line arguments
if ($help_flag) {
    show_help();
    exit;
} elsif ($version_flag) {
    show_version();
    exit;
}

if (scalar(@ARGV) < 2) {
    die "Uso: $0 archivo1.fasta archivo2.fasta [archivo3.fasta ...] archivo_concatenado.fasta\n";
}

# my ($secuencias_por_encabezado, $header_count) = leer_secuencias(@ARGV);
# concatenar_secuencias($secuencias_por_encabezado, "concatenado.fasta");
# crear_archivo_de_conteo($header_count, "conteo.txt");

#Último argumento de la línea de comandos es el nombre del archivo concatenado
my $output_file = pop @ARGV;

# Abre el archivo de salida
open my $output_fh, '>', $output_file or die "No se pudo abrir el archivo de salida $output_file: $!";

my $current_header = "";
my $current_sequence = "";

# Hash para almacenar las secuencias por encabezado
my %secuencias_por_encabezado;
my %header_count;  # Inicializa el contador

# Itera a través de los nombres de archivo proporcionados en la línea de comandos
foreach my $input_file (@ARGV) {
    # Abre el archivo de entrada
    open my $fh, '<', $input_file or die "No se pudo abrir el archivo $input_file: $!";

    # Procesa las líneas del archivo de entrada
    while (my $line = <$fh>) {
        chomp $line;

        if ($line =~ /^>/) {
            # Es un encabezado
            $header_count{$line}++;
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

# Write the concatenated sequences to the output file
foreach my $header (sort keys %secuencias_por_encabezado) {
    print $output_fh "$header\n$secuencias_por_encabezado{$header}\n";
}

# Close the output file
close $output_fh;

# Abre un nuevo archivo de texto para el conteo
# open my $count_fh, '>', 'conteo.txt' or die "No se pudo abrir el archivo de conteo: $!";
# print $count_fh "Número de encabezados: $header_count\n";
# close $count_fh;
open my $count_fh, '>', 'conteo.txt' or die "No se pudo abrir el archivo de conteo: $!";
foreach my $header (sort keys %header_count) {
    print $count_fh "$header\t$header_count{$header}\n";  # Formato "header (tab) número (newline)"
}
close $count_fh;
print "La concatenación se ha completado en el archivo $output_file.\n";


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

# sub leer_secuencias {
#     my @archivos = @_;

#     my %secuencias_por_encabezado;
#     my %header_count;

#     foreach my $archivo (@archivos) {
#         open my $fh, '<', $archivo or die "No se pudo abrir el archivo $archivo: $!";

#         my $current_header = "";
#         my $current_sequence = "";

#         while (my $line = <$fh>) {
#             chomp $line;

#             if ($line =~ /^>/) {
#                 $header_count{$line}++;
#                 if ($current_header) {
#                     $secuencias_por_encabezado{$current_header} .= $current_sequence;
#                 }

#                 $current_header = $line;
#                 $current_sequence = "";
#             } else {
#                 $current_sequence .= $line;
#             }
#         }

#         $secuencias_por_encabezado{$current_header} .= $current_sequence;

#         close $fh;
#     }

#     return (\%secuencias_por_encabezado, \%header_count);
# }

# sub concatenar_secuencias {
#     my ($secuencias, $archivo_salida) = @_;

#     open my $output_fh, '>', $archivo_salida or die "No se pudo abrir el archivo de salida $archivo_salida: $!";

#     foreach my $header (sort keys %$secuencias) {
#         print $output_fh "$header\n$secuencias->{$header}\n";
#     }

#     close $output_fh;
# }

# sub crear_archivo_de_conteo {
#     my ($conteo, $nombre_archivo) = @_;

#     open my $count_fh, '>', $nombre_archivo or die "No se pudo abrir el archivo de conteo: $!";
#     foreach my $header (sort keys %$conteo) {
#         print $count_fh "$header\t$conteo->{$header}\n";
#     }
#     close $count_fh;
# }


