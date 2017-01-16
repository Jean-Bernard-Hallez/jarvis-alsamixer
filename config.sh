# $verbose && jv_debug "DEBUG: entering_cmd hook"
# if [[ "$radioOnOff" == "On" ]]; then
# mpc stop
# mpc clear
# radioOnOff="Off"
# fi

# Avec Jarvis UI vous pouvez l'arrêter en écrivant: stop radio

volumeradio="100" # Volume de 0 à 100


# Vous trouverez par exemple les adresses des flux radio Française ici:
# http://fluxradios.blogspot.fr/p/flux-radios-francaise.html
# Récupérez celles qui sont au format mp3
#
# Dans Adresse vous mettrez l'adresse complète du flux radio
# Dans NomRadio vous lui donnez le nom que vous souhaitez


chercheradio='{ "devices":[
{ "Adresse": "http://radio-contact.ice.infomaniak.ch/radio-contact-high", "NomRadio": "contact"},
{ "Adresse": "http://media.funradio.fr/online/sound/2016/0111/7781276516_m-carter-tuner.mp3", "NomRadio": "Fun Radio"},
{ "Adresse": "http://185.52.127.157/fr/30411/mp3_128.mp3", "NomRadio": "Rire et Chanson"},
{ "Adresse": "http://aifae8cah8.lb.vip.cdn.dvmr.fr/fbvaucluse-midfi.mp3", "NomRadio": "France Bleu Vaucluse"},
{ "Adresse": "http://185.52.127.160/fr/30001/mp3_128.mp3", "NomRadio": "JE SAIS"}
]}'

