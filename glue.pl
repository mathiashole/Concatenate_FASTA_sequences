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
    die "Uso: $0 file1.fasta file2.fasta [file3.fasta ...] file_concatenado.fasta\n";
}

# my ($sequence_by_header, $header_count) = read_sequence(@ARGV);
# concatenar_secuencias($sequence_by_header, "concatenado.fasta");
# crear_file_de_conteo($header_count, "conteo.txt");

#Last command line argument is the name of the concatenated file
my $output_file = pop @ARGV;

# Open the output file
open my $output_fh, '>', $output_file or die "No se pudo abrir el file de salida $output_file: $!";

my $current_header = "";
my $current_sequence = "";

# Hash para almacenar las secuencias por encabezado
my %sequence_by_header;
my %header_count;  # Inicializa el contador

# Itera a través de los nombres de file proporcionados en la línea de comandos
foreach my $input_file (@ARGV) {
    # Abre el file de entrada
    open my $fh, '<', $input_file or die "No se pudo abrir el file $input_file: $!";
    print "file: $input_file\n\n";
    # Procesa las líneas del file de entrada
    while (my $line = <$fh>) {
        chomp $line;

        if ($line =~ /^>/) {
            # Es un encabezado
            $header_count{$line}++;
            #print "init if: $current_sequence\n\n";
            if ($current_header) {
                # Si hay una secuencia anterior, la concatena y la almacena
                #$current_header =~ s/\s.*//; # Elimina cualquier texto después del primer espacio
                $sequence_by_header{$current_header} .= $current_sequence;
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
    $sequence_by_header{$current_header} .= $current_sequence;
    # Cierra el file de entrada
    close $fh;
}

# Agregar un print para ver los encabezados y las secuencias almacenadas
foreach my $header (sort keys %sequence_by_header) {
    print "Encabezado: $header\n";
    print "Secuencia: $sequence_by_header{$header}\n";
}

# Write the concatenated sequences to the output file
foreach my $header (sort keys %sequence_by_header) {
    print $output_fh "$header\n$sequence_by_header{$header}\n";
}
#$sequence_by_header{$current_header} .= $current_sequence;


# Close the output file
close $output_fh;

# Abre un nuevo file de texto para el conteo
# open my $count_fh, '>', 'conteo.txt' or die "No se pudo abrir el file de conteo: $!";
# print $count_fh "Número de encabezados: $header_count\n";
# close $count_fh;
open my $count_fh, '>', 'conteo.txt' or die "No se pudo abrir el file de conteo: $!";
foreach my $header (sort keys %header_count) {
    print $count_fh "$header\t$header_count{$header}\n";  # Formato "header (tab) número (newline)"
}
close $count_fh;
print "La concatenación se ha completado en el file $output_file.\n";


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

# sub read_sequence {
#     my @files = @_;

#     my %sequence_by_header;
#     my %header_count;

#     foreach my $file (@files) {
#         open my $fh, '<', $file or die "No se pudo abrir el file $file: $!";

#         my $current_header = "";
#         my $current_sequence = "";

#         while (my $line = <$fh>) {
#             chomp $line;

#             if ($line =~ /^>/) {
#                 $header_count{$line}++;
#                 if ($current_header) {
#                     $sequence_by_header{$current_header} .= $current_sequence;
#                 }

#                 $current_header = $line;
#                 $current_sequence = "";
#             } else {
#                 $current_sequence .= $line;
#             }
#         }

#         $sequence_by_header{$current_header} .= $current_sequence;

#         close $fh;
#     }

#     return (\%sequence_by_header, \%header_count);
# }

# sub concatenar_secuencias {
#     my ($secuencias, $file_salida) = @_;

#     open my $output_fh, '>', $file_salida or die "No se pudo abrir el file de salida $file_salida: $!";

#     foreach my $header (sort keys %$secuencias) {
#         print $output_fh "$header\n$secuencias->{$header}\n";
#     }

#     close $output_fh;
# }

# sub crear_file_de_conteo {
#     my ($conteo, $nombre_file) = @_;

#     open my $count_fh, '>', $nombre_file or die "No se pudo abrir el file de conteo: $!";
#     foreach my $header (sort keys %$conteo) {
#         print $count_fh "$header\t$conteo->{$header}\n";
#     }
#     close $count_fh;
# }
