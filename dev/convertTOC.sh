#!/usr/bin/env bash

# This script assumes that the wow-ui-source repo exists in a directory at the 
# same level as the Aurora directory. Run this file using "Classic" or "Retail"
# as a parameter and it will locate any TOC files to update the FrameXML*.xml
# files used in this addon.

header="<Ui xmlns=\"http://www.blizzard.com/wow/ui/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.blizzard.com/wow/ui/\nhttps://raw.githubusercontent.com/Meorawr/wow-ui-schema/main/UI.xsd\">\n"
space="\n\n\n\n\n\n"
footer="</Ui>"

skin="./Skin/$1/Interface/FrameXML/"
FrameXML='../wow-ui-source/Interface/FrameXML/*.toc'
for TOC in $FrameXML
do
	echo "Processing $TOC"
	tocName="${TOC##*/}"
	tocName="${tocName%.*}"
	tocFile="$skin$tocName.xml"

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
				if [ -e "$skin$filePath.lua" ]; then
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

	echo $footer >>"$tocFile"
done
