#!/usr/bin/env bash

# This script assumes that the wow-ui-source repo exists in a directory at the 
# same level as the Aurora directory. Run this file using "Classic" or "Retail"
# as a parameter and it will 1) locate any FrameXML_*.toc files to update the 
# corrisponding FrameXML_*.xml file, and 2) run through the AddOns folder and
# update the AddOns.xml file

header="<Ui xmlns=\"http://www.blizzard.com/wow/ui/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.blizzard.com/wow/ui/\nhttps://raw.githubusercontent.com/Meorawr/wow-ui-schema/main/UI.xsd\">\n"
space="\n\n\n\n\n\n"
footer="</Ui>"

skin="./Skin/$1/Interface/"

FrameXML="${skin}FrameXML/"
FrameXMLList='../wow-ui-source/Interface/FrameXML/*.toc'
for TOC in $FrameXMLList
do
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
	while IFS= read -r line
	do
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
	done < "$TOC"

	{
		# shellcheck disable=SC2059
		printf "$space"
		printf "    <Include file=\"DeprecatedSkins.xml\"/>\n"

		echo $footer
	} >>"$tocFile"
done


AddOns="${skin}AddOns/"
AddOnsList='../wow-ui-source/Interface/AddOns/*'

tocFile="${AddOns}AddOns.xml"
# shellcheck disable=SC2059
printf "$header" >"$tocFile"
for AddOn in $AddOnsList
do
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

