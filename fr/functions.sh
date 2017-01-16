jv_pg_ct_volumealsamixerMute () {
say "Ok prononce simplement Jarvisse ! tu es là ? pour reprendre une conversation avec moi."
amixer -M set PCM mute >> null
}

jv_pg_ct_volumealsamixerNormal () {
jv_pg_ct_volumealsamixerTestVariable
amixer -M set PCM unmute >> null
RegAlsaVolamixer=$(amixer set PCM $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
say "Voilà j'ai remis mon volume comme avant à $RegAlsaVolamixer pourcent"
}

jv_pg_ct_volumealsamixer100 () {
jv_pg_ct_volumealsamixerTestVariable
amixer -M set PCM 100% > null
echo "100" > $jarvischemin
say "Voilà, mon volume est à cent pourcent"
}

jv_pg_ct_volumealsamixerTestVariable () {
jarvischemin=$jv_dir/plugins/jarvis-alsamixer/alsamixervol.txt
if [ -f "$jarvischemin" ]; then
alsamixervol=$(cat $jarvischemin)
return
else 
echo "Pas de Variable de volume"
echo "100" > $jarvischemin
alsamixervol=100
fi
}



jv_pg_ct_volumealsamixerPlus () {
jv_pg_ct_volumealsamixerTestVariable
	RegAlsaVolamixer=$(amixer set PCM $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixervol=`echo "$alsamixervol + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixervol > $jarvischemin

		if [[ "$alsamixervol" -ge "100" ]]; then
		alsamixervol=100
		say "Je suis déja à 100 Pourcent."
		return
		fi
	               	
amixer -M set PCM $alsamixervol% >> null
RegAlsaVolamixer1=$(amixer set PCM $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaVolamixer" == "$RegAlsaVolamixer1" && "$RegAlsaVolamixer1" -lt "95" ]]; then
	echo "$alsamixervol + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischemin
	echo $alsamixervol > $jarvischemin	
	jv_pg_ct_volumealsamixerPlus
	return
	fi
say "Voilà j'augmente mon volume à $RegAlsaVolamixer1 Pourcent."
}



jv_pg_ct_volumealsamixerMoins () {
jv_pg_ct_volumealsamixerTestVariable
	RegAlsaVolamixer=$(amixer set PCM $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixervol=`echo "$alsamixervol - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixervol > $jarvischemin
		if [[ "$alsamixervol" -le "0" ]]; then
		alsamixervol=0
		echo "Je suis déja à 0"
		return
		fi
	               	
amixer -M set PCM $alsamixervol% > nul
RegAlsaVolamixer1=$(amixer set PCM $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaVolamixer" == "$RegAlsaVolamixer1" && "$RegAlsaVolamixer1" -gt "0" ]]; then
	echo "$alsamixervol - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischemin
	echo $alsamixervol > $jarvischemin
	jv_pg_ct_volumealsamixerMoins
	return
	fi

say "Voilà je baisse mon volume à $RegAlsaVolamixer1 Pourcent."

}


