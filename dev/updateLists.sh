#!/usr/bin/env bash

# This script assumes that the gethe/wow-ui-source repo exists in a directory at
# the same level as the Aurora directory. Change WOW_SOURCE if you're setup is
# different.

# Usage #
# In a bash shell, run
# ./dev/updateLists.sh Retail
# OR
# ./dev/updateLists.sh Classic

# This script will:
# 1) Locate any FrameXML_*.toc files in wow-ui-source to update the
#    corrisponding FrameXML_*.xml file in Aurora
# 2) Run through the AddOns folder and update the AddOns.xml file

WOW_SOURCE="../wow-ui-source"

branch=$1

header="<Ui xmlns=\"http://www.blizzard.com/wow/ui/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.blizzard.com/wow/ui/\nhttps://raw.githubusercontent.com/Meorawr/wow-ui-schema/main/UI.xsd\">\n"
space="\n\n\n\n\n\n"
footer="</Ui>"

skin="./Skin/Interface"

FrameXML="${skin}/FrameXML/"
FrameXMLList="$WOW_SOURCE/Interface/FrameXML/*.toc"
for TOC in $FrameXMLList; do
	echo "Processing $TOC"
	tocName="${TOC##*/}"
	tocName="${tocName%.*}"
	tocFile="$FrameXML$tocName.xml"

	echo "Create $tocFile"
	# shellcheck disable=SC2059
	printf "$header" >"$tocFile"

	case $tocName in
	FrameXML_Vanilla)
		printf "    <Script>\n        _G.AURORA_DEBUG_PROJECT = 1\n    </Script>" >>"$tocFile"
		;;
	FrameXML_TBC)
		printf "    <Script>\n        _G.AURORA_DEBUG_PROJECT = 2\n    </Script>" >>"$tocFile"
		;;
	FrameXML_Wrath)
		printf "    <Script>\n        _G.AURORA_DEBUG_PROJECT = 3\n    </Script>" >>"$tocFile"
		;;
	*)
		printf "    <Script>\n        _G.AURORA_DEBUG_PROJECT = 0\n    </Script>" >>"$tocFile"
		;;
	esac
	# shellcheck disable=SC2059
	printf "$space" >>"$tocFile"

	fileName=
	while IFS= read -r line; do
		line="${line%[$'\n\r']}"
		line=${line%.*}
		filePath="${line//\\/\/}"
		#echo "fileName $fileName"

		if echo "$filePath" | grep -q "#"; then
			#echo "comment $filePath"
			echo "    <!--$line-->" >>"$tocFile"
		elif [ ${#filePath} -eq 0 ]; then
			#echo "Blank line $filePath"
			echo "${line}" >>"$tocFile"
		else
			#echo "Test $filePath $fileName"
			if [[ -n "$fileName" ]]; then
				if [[ "$filePath" =~ \.\.\/ ]]; then
					if [[ "$filePath" =~ \/"$fileName"$ ]]; then
						echo "Same file2 $filePath $fileName"
						line=""
					fi
				else
					if [[ "$filePath" == "$fileName" ]]; then
						echo "Same file $filePath $fileName"
						line=""
					fi
				fi
			fi
			fileName="${filePath##*/}"

			if [[ -n "$line" ]]; then
				if [ -e "$FrameXML$filePath.lua" ]; then
					#echo "File exists ${#filePath} $filePath"
					echo "    <Script file=\"$line.lua\"/>" >>"$tocFile"
				else
					#echo "No file $line"
					echo "    <!--Script file=\"$line.lua\"/-->" >>"$tocFile"
				fi
			else
				echo "" >>"$tocFile"
			fi
		fi
	done <"$TOC"

	{
		# shellcheck disable=SC2059
		printf "$space"
		printf "    <Include file=\"DeprecatedSkins.xml\"/>\n"

		echo $footer
	} >>"$tocFile"
done

if [[ ${branch,,} == "classic" ]]; then
	declare -a addonsIndex
	declare -A addons

	AddOns="${skin}/AddOns/"
	AddOnsFolder="$WOW_SOURCE/Interface/AddOns"
	AddOnsList="${AddOnsFolder}/*"

	for AddOn in $AddOnsList; do
		echo "Processing $AddOn"
		addonName="${AddOn##*/}"
		addonsIndex+=("$addonName")

		addons["$addonName"]=""
		addonPath="${AddOn}/${addonName}"
		if [ -e "${addonPath}_Vanilla.toc" ]; then
			echo "  Vanila addon"
			addons["$addonName"]+="v"
		fi

		if [ -e "${addonPath}_TBC.toc" ]; then
			echo "  TBC addon"
			addons["$addonName"]+="b"
		fi

		if [ -e "${addonPath}_Wrath.toc" ]; then
			echo "  Wrath addon"
			addons["$addonName"]+="w"
		fi

		if [ -e "${addonPath}.toc" ]; then
			flag=""
			while read -r line; do
				if [[ "${line}" == *"Interface: 1"* ]]; then
					echo "  Vanila Interface"
					flag="v"
					break
				elif [[ "${line}" == *"Interface: 2"* ]]; then
					echo "  TBC Interface"
					flag="b"
					break
				elif [[ "${line}" == *"Interface: 3"* ]]; then
					echo "  Wrath Interface"
					flag="w"
					break
				fi
			done <"$addonPath.toc"

			if [ -z $flag ]; then
				if [[ -n "${addons[$addonName]}" ]]; then
					addons["$addonName"]="vbw"
				fi
			else
				addons["$addonName"]+=$flag
			fi
		fi

	done

	addonList="${AddOns}AddOns"
	# shellcheck disable=SC2059
	printf "$header" >"${addonList}_Vanilla.xml"
	# shellcheck disable=SC2059
	printf "$header" >"${addonList}_TBC.xml"
	# shellcheck disable=SC2059
	printf "$header" >"${addonList}_Wrath.xml"

	for addonName in "${addonsIndex[@]}"; do
		echo "Checking flags ${addonName} ${addons[$addonName]}"
		if [[ -z "${addons[$addonName]}" ]]; then
			# Shared addons
			if [ -e "$AddOns$addonName.lua" ]; then
				#echo "File exists ${#filePath} $filePath"
				echo "    <Script file=\"$addonName.lua\"/>" >>"${addonList}_Vanilla.xml"
				echo "    <Script file=\"$addonName.lua\"/>" >>"${addonList}_TBC.xml"
				echo "    <Script file=\"$addonName.lua\"/>" >>"${addonList}_Wrath.xml"
			else
				#echo "No file $addonName"
				echo "    <!--Script file=\"$addonName.lua\"/-->" >>"${addonList}_Vanilla.xml"
				echo "    <!--Script file=\"$addonName.lua\"/-->" >>"${addonList}_TBC.xml"
				echo "    <!--Script file=\"$addonName.lua\"/-->" >>"${addonList}_Wrath.xml"
			fi
		fi

		if [[ "${addons[$addonName]}" == *"v"* ]]; then
			if [ -e "${skin}_Vanilla/AddOns/$addonName.lua" ]; then
				#echo "File exists ${#filePath} $filePath"
				echo "    <Script file=\"..\..\Interface_Vanilla\AddOns\\${addonName}.lua\"/>" >>"${addonList}_Vanilla.xml"
			else
				#echo "No file $addonName"
				echo "    <!--Script file=\"..\..\Interface_Vanilla\AddOns\\${addonName}.lua\"/-->" >>"${addonList}_Vanilla.xml"
			fi
		fi

		if [[ "${addons[$addonName]}" == *"b"* ]]; then
			if [ -e "${skin}_TBC/AddOns/$addonName.lua" ]; then
				#echo "File exists ${#filePath} $filePath"
				echo "    <Script file=\"..\..\Interface_TBC\AddOns\\${addonName}.lua\"/>" >>"${addonList}_TBC.xml"
			else
				#echo "No file $addonName"
				echo "    <!--Script file=\"..\..\Interface_TBC\AddOns\\${addonName}.lua\"/-->" >>"${addonList}_TBC.xml"
			fi
		fi

		if [[ "${addons[$addonName]}" == *"w"* ]]; then
			if [ -e "${skin}_Wrath/AddOns/$addonName.lua" ]; then
				#echo "File exists ${#filePath} $filePath"
				echo "    <Script file=\"..\..\Interface_Wrath\AddOns\\${addonName}.lua\"/>" >>"${addonList}_Wrath.xml"
			else
				#echo "No file $addonName"
				echo "    <!--Script file=\"..\..\Interface_Wrath\AddOns\\${addonName}.lua\"/-->" >>"${addonList}_Wrath.xml"
			fi
		fi
	done

	echo $footer >>"${addonList}_Vanilla.xml"
	echo $footer >>"${addonList}_TBC.xml"
	echo $footer >>"${addonList}_Wrath.xml"
else
	AddOns="${skin}/AddOns/"
	AddOnsList="$WOW_SOURCE/Interface/AddOns/*"

	tocFile="${AddOns}AddOns.xml"
	# shellcheck disable=SC2059
	printf "$header" >"$tocFile"
	for AddOn in $AddOnsList; do
		echo "Processing $AddOn"
		fileName="${AddOn##*/}"

		if [ -e "$AddOns$fileName.lua" ]; then
			#echo "File exists ${#filePath} $filePath"
			echo "    <Script file=\"$fileName.lua\"/>" >>"$tocFile"
		else
			#echo "No file $fileName"
			echo "    <!--Script file=\"$fileName.lua\"/-->" >>"$tocFile"
		fi
	done
	echo $footer >>"$tocFile"
fi
