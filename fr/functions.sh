jv_pg_ct_volumealsamixerMute () {
say "Ok prononce simplement Jarvisse ! tu es là ? pour reprendre une conversation avec moi."
amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME mute >> null
}

jv_pg_ct_volumealsamixerNormal () {
jv_pg_ct_volumealsamixerTestVariable
amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME unmute >> null
RegAlsaVolamixer=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
say "Voilà j'ai remis mon volume comme avant à $RegAlsaVolamixer -c $ALSAMIXERCARTEVOLUME pourcents"
}

jv_pg_ct_volumealsamixer100 () {
jv_pg_ct_volumealsamixerTestVariable
amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME 100% > null
echo "100" > $jarvischemin
say "Voilà, mon volume est à cent pourcents"
}

jv_pg_ct_volumealsamixerTestVariable () {
jarvischemin=$jv_dir/plugins/jarvis-alsamixer/alsamixervol.txt
if [ -f "$jarvischemin" ]; then
alsamixervol=$(cat $jarvischemin)
return
else 
echo "Pas de Variable de volume... Création en cours"
echo "100" > $jarvischemin
alsamixervol=100
fi
}

jv_pg_ct_volumealsamixerTestVariableMicro () {
jarvischeminMic=$jv_dir/plugins/jarvis-alsamixer/alsamixermicro.txt
jarvischeminMicAncien=$jv_dir/plugins/jarvis-alsamixer/alsamixermicroOld.txt

if [ -f "$jarvischeminMic" ]; then
alsamixerMic=$(cat $jarvischeminMic)
return
else 
echo "Pas de Variable pour le micro... Création en cours"
echo "100" > $jarvischeminMic
alsamixerMic=100
fi
}


jv_pg_ct_volumealsamixerNUIT () {
alsamixervol=`echo "$alsamixervol 50%" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
echo $alsamixervol > $jarvischemin
}


jv_pg_ct_volumealsamixerPlus () {
jv_pg_ct_volumealsamixerTestVariable
	RegAlsaVolamixer=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixervol=`echo "$alsamixervol + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixervol > $jarvischemin

		if [[ "$alsamixervol" -ge "100" ]]; then
		alsamixervol=100
		say "Je suis déja à 100 pourcents."
		return
		fi
	               	
amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME $alsamixervol% >> null
RegAlsaVolamixer1=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaVolamixer" == "$RegAlsaVolamixer1" && "$RegAlsaVolamixer1" -lt "95" ]]; then
	echo "$alsamixervol + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischemin
	echo $alsamixervol > $jarvischemin	
	jv_pg_ct_volumealsamixerPlus
	return
	fi
say "Voilà j'augmente mon volume à $RegAlsaVolamixer1 pourcents."
}



jv_pg_ct_volumealsamixerMoins () {
jv_pg_ct_volumealsamixerTestVariable

	RegAlsaVolamixer=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixervol=`echo "$alsamixervol - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixervol > $jarvischemin
		if [[ "$alsamixervol" -le "0" ]]; then
		alsamixervol=0
		echo "Je suis déja à 0"
		return
		fi
	               	
amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME $alsamixervol% > nul
RegAlsaVolamixer1=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaVolamixer" == "$RegAlsaVolamixer1" && "$RegAlsaVolamixer1" -gt "0" ]]; then
	echo "$alsamixervol - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischemin
	echo $alsamixervol > $jarvischemin
	jv_pg_ct_volumealsamixerMoins
	return
	fi

say "Voilà je baisse mon volume à $RegAlsaVolamixer1 pourcents."
}

jv_pg_ct_volumealsamixerMicroP () {
	RegAlsaMicamixerMic=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixerMic=`echo "$alsamixerMic + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixerMic > $jarvischeminMicAncien

		if [[ "$alsamixerMic" -ge "100" ]]; then
		alsamixerMic=100
		say "Je suis déja à 100 pourcents."
		return
		fi
	               	
amixer -c $ALSAMIXERCARTEMICRO -M set $ALSAMIXERNOMMICRO $alsamixerMic% >> null
RegAlsaVolamixerMic1=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaMicamixerMic" == "$RegAlsaVolamixerMic1" && "$RegAlsaVolamixerMic1" -lt "95" ]]; then
	echo "$alsamixerMic + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischeminMicAncien
	echo $alsamixerMic > $jarvischeminMicAncien	
	jv_pg_ct_volumealsamixerMicroP
	return
	fi
say "Voilà j'augmente la sensibilité du micro à $RegAlsaVolamixerMic1 pourcents."

}

jv_pg_ct_volumealsamixerMicroM () {
	RegAlsaMicamixerMic=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixerMic=`echo "$alsamixerMic - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixerMic > $jarvischeminMicAncien

		if [[ "$alsamixerMic" -le "0" ]]; then
		alsamixerMic=0
		say "Je suis déja à 0 pourcents."
		return
		fi
	               	
amixer -c $ALSAMIXERCARTEMICRO -M set $ALSAMIXERNOMMICRO $alsamixerMic% >> null
RegAlsaVolamixerMic1=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaMicamixerMic" -le "$RegAlsaVolamixerMic1" && "$RegAlsaMicamixerMic1" -lt "95" ]]; then
	echo "$alsamixerMic - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischeminMicAncien
	echo $alsamixerMic > $jarvischeminMicAncien	
	jv_pg_ct_volumealsamixerMicroM
	return
	fi
say "Voilà je baisse la sensibilité du micro à $RegAlsaVolamixerMic1 pourcents."
}

jv_pg_ct_volumealsamixerMicroMNON() {
jv_pg_ct_volumealsamixerTestVariableMicro
sudo rm $jarvischeminMicAncien
alsamixerMic=$(cat $jarvischeminMic)
RegAlsaVolamixerMic1=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
say "Réglage du micro au paramètre d'avant soit à $alsamixerMic pourcents"
}

jv_pg_ct_volumealsamixerMicroMOUI() {
jv_pg_ct_volumealsamixerTestVariableMicro
alsamixerMic=$(cat $jarvischeminMicAncien)
echo $(cat $jarvischeminMicAncien) > $jarvischeminMic
sudo rm $jarvischeminMicAncien
RegAlsaVolamixerMic1=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
say "Je concerve donc le réglage du micro au paramètre de $RegAlsaVolamixerMic1 pourcents"
}


jv_pg_ct_volumealsamixerMute () {
say "Ok prononce simplement Jarvisse ! tu es là ? pour reprendre une conversation avec moi."
amixer -c $ALSAMIXERCARTEOLUME -M set $ALSAMIXERNOMVOLUME mute >> null
}

jv_pg_ct_volumealsamixerNormal () {
jv_pg_ct_volumealsamixerTestVariable
amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME unmute >> null
RegAlsaVolamixer=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
say "Voilà j'ai remis mon volume comme avant à $RegAlsaVolamixer -c $RegAlsaVolamixer pourcents"
}

jv_pg_ct_volumealsamixer100 () {
jv_pg_ct_volumealsamixerTestVariable
amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME 100% > null
echo "100" > $jarvischemin
say "Voilà, mon volume est à cent pourcents"
}

jv_pg_ct_volumealsamixerTestVariable () {
jarvischemin=$jv_dir/plugins/jarvis-alsamixer/alsamixervol.txt
if [ -f "$jarvischemin" ]; then
alsamixervol=$(cat $jarvischemin)
return
else 
echo "Pas de Variable de volume... Création en cours"
echo "100" > $jarvischemin
alsamixervol=100
fi
}

jv_pg_ct_volumealsamixerTestVariableMicro () {
jarvischeminMic=$jv_dir/plugins/jarvis-alsamixer/alsamixermicro.txt
jarvischeminMicAncien=$jv_dir/plugins/jarvis-alsamixer/alsamixermicroOld.txt

if [ -f "$jarvischeminMic" ]; then
alsamixerMic=$(cat $jarvischeminMic)
return
else 
echo "Pas de Variable pour le micro... Création en cours"
echo "100" > $jarvischeminMic
alsamixerMic=100
fi
}


jv_pg_ct_volumealsamixerNUIT () {
alsamixervol=`echo "$alsamixervol 50%" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
echo $alsamixervol > $jarvischemin
}




jv_pg_ct_volumealsamixerPlus () {
jv_pg_ct_volumealsamixerTestVariable
	RegAlsaVolamixer=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixervol=`echo "$alsamixervol + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixervol > $jarvischemin

		if [[ "$alsamixervol" -ge "100" ]]; then
		alsamixervol=100
		say "Je suis déja à 100 pourcents."
		return
		fi
	               	
amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME $alsamixervol% >> null
RegAlsaVolamixer1=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaVolamixer" == "$RegAlsaVolamixer1" && "$RegAlsaVolamixer1" -lt "95" ]]; then
	echo "$alsamixervol + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischemin
	echo $alsamixervol > $jarvischemin	
	jv_pg_ct_volumealsamixerPlus
	return
	fi
say "Voilà j'augmente mon volume à $RegAlsaVolamixer1 pourcents."
}



jv_pg_ct_volumealsamixerMoins () {
jv_pg_ct_volumealsamixerTestVariable

	RegAlsaVolamixer=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixervol=`echo "$alsamixervol - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixervol > $jarvischemin
		if [[ "$alsamixervol" -le "0" ]]; then
		alsamixervol=0
		echo "Je suis déja à 0"
		return
		fi
	               	
amixer -c $ALSAMIXERCARTEVOLUME -M set $ALSAMIXERNOMVOLUME $alsamixervol% > nul
RegAlsaVolamixer1=$(amixer -c $ALSAMIXERCARTEVOLUME set $ALSAMIXERNOMVOLUME $alsamixervol% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaVolamixer" == "$RegAlsaVolamixer1" && "$RegAlsaVolamixer1" -gt "0" ]]; then
	echo "$alsamixervol - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischemin
	echo $alsamixervol > $jarvischemin
	jv_pg_ct_volumealsamixerMoins
	return
	fi

say "Voilà je baisse mon volume à $RegAlsaVolamixer1 pourcents."
}

jv_pg_ct_volumealsamixerMicroP () {
	RegAlsaMicamixerMic=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixerMic=`echo "$alsamixerMic + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixerMic > $jarvischeminMicAncien

		if [[ "$alsamixerMic" -ge "100" ]]; then
		alsamixerMic=100
		say "Je suis déja à 100 pourcents."
		return
		fi
	               	
amixer -c $ALSAMIXERCARTEMICRO -M set $ALSAMIXERNOMMICRO $alsamixerMic% >> null
RegAlsaVolamixerMic1=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaMicamixerMic" == "$RegAlsaVolamixerMic1" && "$RegAlsaVolamixerMic1" -lt "95" ]]; then
	echo "$alsamixerMic + 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischeminMicAncien
	echo $alsamixerMic > $jarvischeminMicAncien	
	jv_pg_ct_volumealsamixerMicroP
	return
	fi
say "Voilà j'augmente la sensibilité du micro à $RegAlsaVolamixerMic1 pourcents."

}

jv_pg_ct_volumealsamixerMicroM () {
	RegAlsaMicamixerMic=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	alsamixerMic=`echo "$alsamixerMic - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/"`
        echo $alsamixerMic > $jarvischeminMicAncien

		if [[ "$alsamixerMic" -le "0" ]]; then
		alsamixerMic=0
		say "Je suis déja à 0 pourcents."
		return
		fi
	               	
amixer -c $ALSAMIXERCARTEMICRO -M set $ALSAMIXERNOMMICRO $alsamixerMic% >> null
RegAlsaVolamixerMic1=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
	if [[ "$RegAlsaMicamixerMic" -le "$RegAlsaVolamixerMic1" && "$RegAlsaMicamixerMic1" -lt "95" ]]; then
	echo "$alsamixerMic - 5" | bc -l | sed "s/\([0-9]*\.[0-9][0-9]\).*/\1/" > $jarvischeminMicAncien
	echo $alsamixerMic > $jarvischeminMicAncien	
	jv_pg_ct_volumealsamixerMicroM
	return
	fi
say "Voilà je baisse la sensibilité du micro à $RegAlsaVolamixerMic1 pourcents."
}

jv_pg_ct_volumealsamixerMicroMNON() {
jv_pg_ct_volumealsamixerTestVariableMicro
sudo rm $jarvischeminMicAncien
alsamixerMic=$(cat $jarvischeminMic)
RegAlsaVolamixerMic1=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
say "Réglage du micro au paramètre d'avant soit à $alsamixerMic pourcents"
}

jv_pg_ct_volumealsamixerMicroMOUI() {
jv_pg_ct_volumealsamixerTestVariableMicro
alsamixerMic=$(cat $jarvischeminMicAncien)
echo $(cat $jarvischeminMicAncien) > $jarvischeminMic
sudo rm $jarvischeminMicAncien
RegAlsaVolamixerMic1=$(amixer -c $ALSAMIXERCARTEMICRO set $ALSAMIXERNOMMICRO $alsamixerMic% | grep % | awk -F \[ '{print $2}' | awk -F \% '{print $1}')
say "Je concerve donc le réglage du micro au paramètre de $RegAlsaVolamixerMic1 pourcents"
}









