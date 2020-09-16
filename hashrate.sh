#!/bin/bash

# Script creado para blockmit.com

#VARIABLES
tactual=$(date +%s)

# Cambiar por la direccion completa de bitcoin-cli
# Ejemplo
# raiz="/home/bitcoin/bin/bitcoin-0.19.0.1/bin/bitcoin-cli"

raiz=""

bactual=$($raiz getblockcount)
bloque=$bactual
final=1
dif=$($raiz getblockchaininfo | grep "difficulty" | tr -d , | tr -s "." " " | cut -d" " -f3)
h=$(($tactual - 86400))


############################################################

# BUCLE PARA BUSCAR EL BLOQUE GENERADO HACE 24H

buscar=$tactual

until [ "$buscar" -le "$h" ]
do
bactual=$(( $bactual - 1 ))
hactual=$($raiz getblockhash $bactual)
buscar=$($raiz getblock $hactual | grep \"time | tr -d , | cut -d" " -f4)
final=$(($final + 1))
done

hashrate="$(echo "$final/144*$dif*4294967296/600/1000000000000000000" | bc -l | cut -c 1-6)"
########################################################

# Hashrate desde el ultimo cambio de dificultad

anterior=$(($bloque / 2016))
antbloque=$(($anterior * 2016))

resta=$(($bloque - $antbloque))

hactual=$($raiz getblockhash $antbloque)
buscar=$($raiz getblock $hactual | grep \"time | tr -d , | cut -d" " -f4)

diferencia=$(($tactual - $buscar))
deberia=$(($diferencia / 60 / 10))

hashratefin="$(echo "$resta/$deberia*$dif*4294967296/600/1000000000000000000" | bc -l | cut -c 1-6)"
hashdif="$(echo "$dif*4294967296/600/1000000000000000000" | bc -l | cut -c 1-6)"

cambiodif="$(echo "1/$hashdif*$hashratefin*100" | bc -l | cut -c 1-6)"
cambiodif="$(echo "$cambiodif-100" | bc -l)"

########################################################
## Resultado final
########################################################

echo "------------------------------------------------------------"
echo ""
echo "El hashrate de la actual dificultad es: $hashdif" EH/s
echo ""
echo "------------------------------------------------------------"
echo ""
echo ""
echo "El hashrate de las ultimas 24 horas es: $hashrate" EH/s
echo ""
echo "El hashrate desde el ultimo cambio de dificultad es: $hashratefin" EH/s
echo ""
echo "Porcentaje final de posible cambio: $cambiodif""%"
echo ""
echo "------------------------------------------------------------"
