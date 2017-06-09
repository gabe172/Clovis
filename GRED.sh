#!/bin/bash
ADDR(){
	ip addr > /tmp/lista
	dialog			\
	--exit-label 'Voltar'	\
	--textbox /tmp/lista 0 0
}
	
AIP(){
IP=$(dialog						\
--nocancel						\
--stdout						\
--title 'Adicionar IP'					\
--inputbox 'Digite o IP desejado (incluindo a faixa) ou aperte (2X) ESC voltar'	\
0 0							)
if [ $? = 0 ]; then
	if [ $IP =  ]; then
	dialog --title 'Erro' --msgbox 'Não foi digitado nada, voltando ao Menu de Gerenciamento de redes' 0 0	
	
	else
	 	ip addr add $IP dev eth0 && ADDR
	fi
fi
GRED			
}

RIP(){
IPR=$(dialog --stdout --title "Remover IP" --yes-label 'Sim' --no-label 'Não' --yesno "Quer mesmo remover tudo?" 0 0)
if [ $? = 0 ]; then
	ip addr flush dev eth0 && ADDR 
fi
GRED
}



RES(){
OPC=$(dialog --stdout --title "Restart" --yes-label 'Sim' --no-label 'Não' --yesno "Quer mesmo reestartar a placa de rede?" 0 0)
if [ $? = 0 ]; then
  	echo -n "/etc/init.d/networking restart" && dialog --msgbox 'A placa foi reestartada com sucesso' 0 0 
fi
GRED
}

HOS(){
HST=$(dialog 					\
	--nocancel				\
	--stdout				\
	--title 'HOST'				\
	--inputbox 'Digite o IP a ser adicionado'\
	0 0 )
if [ $? = 0 ]; then
  if [ $HST =  ]; then
	dialog --title 'Erro' --msgbox 'Não foi digitado nada, voltando ao Menu de Gerenciamento de redes' 0 0		
  else 
	HOT=$(dialog 					\
		--nocancel				\
		--stdout				\
		--title 'HOST'				\
		--inputbox 'Digite o nome a ser adicionado'\
		0 0 )
	if [ $? = 0 ]; then
	  if [ $HOT =  ]; then
		dialog --title 'Erro' --msgbox 'Não foi digitado nada, voltando ao Menu de Gerenciamento de redes' 0 0		
	  else 
		echo $HST $HOT >> /etc/hosts && dialog --exit-label 'Voltar' --textbox /etc/hosts 0 0 
	  fi
	fi
  fi
fi
GRED
}

DNS(){
DIG1=$(dialog 					\
	--nocancel				\
	--stdout				\
	--title 'DNS'				\
	--inputbox 'Digite o IP a ser adicionado no DNS'\
	0 0 )
if [ $? = 0 ]; then
  if [ $DIG1 != 0  ]; then  
	DIG2=$(dialog 					\
		--nocancel				\
		--stdout				\
		--title 'DNS'				\
		--inputbox 'Digite um segundo IP a ser adicionado no DNS'\
		0 0 )
  
	if [ $? = 0 ]; then
	  if [ $DIG2 != 0 ]; then
		cp /etc/resolv.conf /root/
		rm /resolv.conf
		touch /etc/resolv.conf
		echo "nameserver" $DIG1 >> /etc/resolv.conf
		echo "nameserver" $DIG2 >> /etc/resolv.conf
		dialog --exit-label "Voltar" --textbox /etc/resolv.conf 0 0
	  else
	dialog --title 'Erro' --msgbox 'Inválido, voltando ao Menu de Gerenciamento de redes' 0 0
	  fi
	fi
  else
	dialog --title 'Erro' --msgbox 'Inválido, voltando ao Menu de Gerenciamento de redes' 0 0
  fi
fi
GRED
}

NAM(){
NAME=$(dialog					\
--nocancel					\
--stdout					\
--title 'Hostname'				\
--inputbox "Digite um nome para a máquina"	\
0 0)
if [ $? = 0 ]; then
  if [ $NAME =  ]; then
	dialog --title 'Erro' --msgbox 'Não foi digitado nada, voltando ao Menu de Gerenciamento de redes' 0 0	
  else
	cp /etc/hostname /root/
	rm /etc/hostname	
	touch /etc/hostname
		echo $NAME >> /etc/hostname
	dialog --exit-label --textbox /etc/hostname 0 0
  fi
fi
GRED
} 

GRED(){
OPC=$(dialog					\
--cancel-label 'Voltar'				\
--stdout					\
--title 'Gerenciamento de Redes'		\
--menu 'Escolha a opção desejada:'		\
0 0 0 						\
	1 'Vizualizar IPs'			\
	2 'Adicionar IP'			\
	3 'Remover IP'				\
	4 'Restart na Placa de Rede'		\
	5 'Host'				\
	6 'DNS'					\
	7 'Hostname'				)

case $OPC in
	1)ADDR && GRED  ;;
	2)AIP	;;
	3)RIP	;;
	4)RES	;;
	5)HOS	;;
	6)DNS	;;
	7)NAM	;;
	*) cd /home/vagrant/ && ./Menu.sh ;;
esac
}
GRED
	
