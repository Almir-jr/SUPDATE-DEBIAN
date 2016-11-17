#!/bin/bash
#---------------------------------------------------------------------------
# SUPDATE.sh - Atualiza caso exista conexão com a internet
# 
# Author: José Almir <jr.almirr@gmail.com>
#
# Versão: 0.4.0 - REMOÇÃO DO IF NA VERIFICAÇÃO DO DIRETÓRIO .SUPDATELOGS 
#               
#		
# "O script irá verificar automaticamente se há internet e atualizará,
# ao fazer isso ele gravará no log localizado em /home/USER/.SUPDATELOGS/"
#
#
# Licença: GPL 
#
#---------------------------------------------------------------------------

# XXX ÁREA DESTINADA APENAS AO CRIADOR XXX XXX XXX XXX XXX XXX XXX XXX :
#
# echo "usuario ALL=NOPASSWD:/etc/scripts/SUPDATE.sh" >> /etc/sudoers
#
# runlevel
# 
# ln -s /etc/scripts/SUPDATE.sh /etc/rcX.d/SXXSUPDATE
#
# XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX XXX

# Declaração das variáveis do script
ENDERECO="8.8.8.8"
TESTE_CONEXAO=`ping -c3 "$ENDERECO" | grep -i "Unreachable"` 
DATA=`date "+%d de %B de %Y"`
HORA=`date +%H:%M`   
# Fim da declaração das variáveis do script

# Loop para testar a conexão a cada 120s
while [ "$TESTE_CONEXAO" = "Unreachable"-o "$TESTE_CONEXAO" = "unreachable" ]
do
   sleep 120
   TESTE_CONEXAO=`ping -c3 "$ENDERECO" | grep -i "Unreachable"`
done
# Fim do loop de testes

# Início da função que guarda os logs
function DATALOG(){
    mkdir -p  /home/"$USER"/.SUPDATELOGS/
    cd /home/"$USER"/.SUPDATELOGS/ 
    echo "________________________________________________________" >> logUP.txt
    echo >> logUP.txt
    echo "Atualizado dia $DATA às $HORA." >> logUP.txt
    echo >> logUP.txt
    echo "________________________________________________________" >> logUP.txt
}
# Fim da função que guardas os logs caso haja sucesso

# Início da função que guarda logs caso haja erro
function DATALOGERROR(){
   mkdir -p /home/pc-20/.SUPDATELOGS/
   cd /home/pc-20/.SUPDATELOGS 
   echo "________________________________________________________" >> logUP.txt
   echo >> logUP.txt
   echo "Erro na atualização dia $DATA às $HORA." >> logUP.txt
   echo >> logUP.txt
   echo "________________________________________________________" >> logUP.txt
}
# Fim da função que guarda logs caso haja erro

# Teste de atualização:
if [ "$TESTE_CONEXAO" != "Destination" ]
then
   apt-get update 
   apt-get upgrade
   DATALOG 
else 
   DATALOGERROR
fi
# Fim do teste de atualização

