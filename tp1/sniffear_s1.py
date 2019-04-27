from scapy.all import sniff


def tipo_de_destino(paquete):
    if paquete.dst == 'ff:ff:ff:ff:ff:ff':  # es broadcast
        return 'bcast'
    else:  # es unicast (o quiza multicast)
        return 'unicast'


def mostrar_paquete(paquete):
    print(
        ','.join([
            str(paquete.type),
            tipo_de_destino(paquete),
        ])
    )


print('method,dest_type')
sniff(prn=mostrar_paquete)
