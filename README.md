# UBIMUS

# amt_tutorial

## Portuguese instructions
# Se o plot no gnu-octave não funcionar direito, tentar o comando abaixo:
graphics_toolkit('gnuplot')

# pacotes para processamento de sinais
pkg install -forge signal control
# pkg: please install the Debian package "liboctave-dev"
 pkg install -forge image

pkg load signal
pkg load image



# Audio configurations on gnu-octave:
jackd -d dummy -p 512 &

