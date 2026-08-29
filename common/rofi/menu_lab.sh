#!/bin/bash

declare -A categorias
categorias["🔍 Reconocimiento"]="nmap masscan enum4linux smbclient"
categorias["🌐 Web"]="burpsuite nikto sqlmap gobuster wfuzz firefox"
categorias["🔑 Credenciales"]="hydra hashcat"
categorias["📡 Wireless"]="aircrack-ng"
categorias["🛠️ Explotacion"]="msfconsole"
categorias["🔬 Forense"]="autopsy binwalk wireshark"
categorias["🌍 Red"]="wireshark netcat curl wget"
categorias["🐍 Dev"]="python3"

declare -A descripciones
descripciones["nmap"]="Escanea puertos y servicios de una máquina.\nEjemplo: nmap -sV -sC 10.10.10.1"
descripciones["masscan"]="Escaneo masivo ultrarrápido de puertos.\nEjemplo: masscan -p1-65535 10.10.10.1"
descripciones["enum4linux"]="Enumera info de sistemas Windows/Samba (usuarios, shares).\nEjemplo: enum4linux -a 10.10.10.1"
descripciones["smbclient"]="Accede a carpetas compartidas Windows (como FTP).\nEjemplo: smbclient //10.10.10.1/share"
descripciones["burpsuite"]="Intercepta y modifica tráfico web. Proxy entre tú y la web.\nUso: abrir, configurar proxy en browser"
descripciones["nikto"]="Escanea vulnerabilidades en servidores web.\nEjemplo: nikto -h http://10.10.10.1"
descripciones["sqlmap"]="Detecta y explota inyecciones SQL automáticamente.\nEjemplo: sqlmap -u 'http://web.com?id=1'"
descripciones["gobuster"]="Fuerza bruta de directorios/archivos en webs.\nEjemplo: gobuster dir -u http://10.10.10.1 -w wordlist.txt"
descripciones["wfuzz"]="Fuzzing web — prueba parámetros, directorios, usuarios.\nEjemplo: wfuzz -w wordlist.txt http://web.com/FUZZ"
descripciones["firefox"]="Navegador web."
descripciones["hydra"]="Fuerza bruta de contraseñas en servicios (SSH, FTP, web).\nEjemplo: hydra -l admin -P pass.txt ssh://10.10.10.1"
descripciones["hashcat"]="Crackea hashes (MD5, SHA1, bcrypt, etc) con GPU.\nEjemplo: hashcat -m 0 hash.txt wordlist.txt"
descripciones["aircrack-ng"]="Crackea redes WiFi WEP/WPA capturando handshake.\nEjemplo: aircrack-ng -w wordlist.txt captura.cap"
descripciones["msfconsole"]="Framework de explotación — lanza exploits contra vulnerabilidades.\nUso: msfconsole → search → use → exploit"
descripciones["autopsy"]="Forense digital — analiza discos, recupera archivos borrados.\nUso: interfaz gráfica"
descripciones["binwalk"]="Analiza firmware y archivos binarios, extrae contenido oculto.\nEjemplo: binwalk -e archivo.bin"
descripciones["wireshark"]="Captura y analiza tráfico de red en tiempo real.\nUso: interfaz gráfica"
descripciones["netcat"]="Navaja suiza de red — conecta, escucha, transfiere datos.\nEjemplo: nc -lvnp 4444"
descripciones["curl"]="Hace peticiones HTTP desde terminal.\nEjemplo: curl -I http://10.10.10.1"
descripciones["wget"]="Descarga archivos desde terminal.\nEjemplo: wget http://10.10.10.1/archivo"
descripciones["python3"]="Lenguaje de scripting — exploits, servers, automatización.\nEjemplo: python3 -m http.server 8080"

menu() {
    orden=(
        "🔍 Reconocimiento"
        "🌐 Web"
        "🔑 Credenciales"
        "📡 Wireless"
        "🛠️ Explotacion"
        "🔬 Forense"
        "🌍 Red"
        "🐍 Dev"
    )
    for cat in "${orden[@]}"; do
        echo "$cat"
    done
}

selcat=$(menu | rofi -dmenu -p " Lab" -i)
[ -z "$selcat" ] && exit

herramientas="${categorias[$selcat]}"
seltool=$(echo "$herramientas" | tr ' ' '\n' | rofi -dmenu -p "$selcat" -i)
[ -z "$seltool" ] && exit

desc="${descripciones[$seltool]}"
confirmacion=$(echo -e "✅ Abrir $seltool\n❌ Cancelar" | rofi -dmenu -p "$(echo -e "$desc")" -i)

[[ "$confirmacion" == "✅ Abrir $seltool" ]] && kitty -e bash -c "$seltool; exec bash" &
