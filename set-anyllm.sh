#!/bin/bash
#set-anyllm.sh v05.41023.0711 
         aVer="v05.41023.0711"

# ---------------------------------------------------------------------------

    echo ""

# ---------------------------------------------------------------------------

                                  aCmd=""
   if [[ "$1" == ""      ]]; then aCmd="help";   fi
   if [[ "$1" == "help"  ]]; then aCmd="help";   fi
   if [[ "$1" == "doit"  ]]; then aCmd="doIt";   fi
   if [[ "$1" == "show"  ]]; then aCmd="showEm"; fi
   if [[ "$1" == "wipe"  ]]; then aCmd="wipeIt"; fi

# ---------------------------------------------------------------------------

function exit_withCR() {
  if [[ "${OSTYPE:0:6}" == "darwin" ]]; then echo ""; fi
     }
# -----------------------------------------------------------

function help() {
  echo "  Usage: . ./set-anyllm.sh {Cmd} (${aVer})"
  echo "   where Cmd can be: "
  echo "         help  This help"
  echo "         doit  Make Folders"
  echo "         wipe  Wipe all the setup"
  }
# -----------------------------------------------------------

function setOSvars() {

     aTS=$( date '+%y%m%d.%H%M' ); aTS=${aTS:2}
     aBashrc="$HOME/.bashrc"
     aBinDir="/Home/._0/bin"
  if [[ "${OSTYPE:0:6}" == "darwin" ]]; then
     aBashrc="$HOME/.zshrc"
     aBinDir="/Users/Shared/._0/bin"
     fi
     }
# -----------------------------------------------------------

function showEm() {

  echo "  aBinDir: '${aBinDir}'"
  ls -l "${aBinDir}" | awk 'NR > 1 { print "    " $0 }'
  echo ""

  echo "  aBascrc: '${aBashrc}'"
  cat  "${aBashrc}" | awk '{ print "    " $0 }'
  echo -e "    -------\n"

  echo "  PATH:"
  echo "${PATH}" | awk '{ gsub( /:/, "\n" );  print }' | awk '{ print "    " $0 }'
  }
# -----------------------------------------------------------

function clnHouse() {

  PATH="${PATH/${aBinDir}:}"

  if [[ -f "${aBinDir}"/* ]]; then rm "${aBinDir}"/*; fi

  cat   "${aBashrc}" | awk '/._0/ { exit }; NF > 0 { print }' >"${aBashrc}_@tmp"
  mv "${aBashrc}_@tmp" "${aBashrc}"
  }
# -----------------------------------------------------------

function  mkScript() {
# echo "    aAnyLLMscr:  $2/$3"
  echo "#!/bin/bash"   >"$2/$3"
  echo "  $1 \"\$@\"" >>"$2/$3"
  chmod 777 "$2/$3"
  }
# -----------------------------------------------------------

function setBashrc() {

# if [ "${PATH/._0/}" != "${PATH}" ]; then

     inRC=$( cat "${aBashrc}" | awk '/._0/ { print 1 }' )
  if [[ "${inRC}" == "1" ]]; then

     echo "* The path, '${aBinDir}', is already in the User's PATH."

   else
     cp -p "${aBashrc}" "${aBashrc}_${aTS}"

     echo "  Adding path, '${aBinDir}', to User's PATH in '${aBashrc}'."

     echo ""                                     		    >>"${aBashrc}"
#    echo "export PATH=\"/Users/Shared/._0/bin:\$PATH\""    >>"${aBashrc}"
     echo "export PATH=\"${aBinDir}:\$PATH\""               >>"${aBashrc}"
     echo ""                                     		    >>"${aBashrc}"
     echo "function git_branch_name() {"                                     	 	                   >>"${aBashrc}"
     echo "  branch=\$( git symbolic-ref HEAD 2>/dev/null | awk 'BEGIN{ FS=\"/\" } { print \$NF }' )"  >>"${aBashrc}"
     echo "  if [[ \$branch == \"\" ]]; then"                                 		                   >>"${aBashrc}"
     echo "    :"                                     		>>"${aBashrc}"
     echo "  else"                                     		>>"${aBashrc}"
     echo "    echo ' ('\$branch')'"                        >>"${aBashrc}"
     echo "  fi"                                     		>>"${aBashrc}"
     echo "  }"                                     		>>"${aBashrc}"
     echo ""                                     		    >>"${aBashrc}"
     echo "# Add timestamps and user to history" 		    >>"${aBashrc}"
     echo "export HISTTIMEFORMAT=\"%F %T $(whoami) \""      >>"${aBashrc}"
     echo ""                                     		    >>"${aBashrc}"
     echo "# Append to history file, don't overwrite it"    >>"${aBashrc}"
  if [ "${OSTYPE:0:6}" != "darwin" ]; then
     echo "shopt -s histappend"                             >>"${aBashrc}"
     fi
     echo ""                                     		    >>"${aBashrc}"
     echo "# Write history after every command"             >>"${aBashrc}"
     echo "PROMPT_COMMAND=\"history -a; $PROMPT_COMMAND\""  >>"${aBashrc}"
     echo ""                                     		    >>"${aBashrc}"
     echo "setopt PROMPT_SUBST"		                        >>"${aBashrc}"
     echo "PROMPT='%n@%m %1~\$(git_branch_name): '"		    >>"${aBashrc}"

     source "${aBashrc}"
     fi
  }
# -----------------------------------------------------------

function cpyToBin() {
# return

  aJPTs_JDir="/Users/Shared/._0/bin"
  aJPTs_GitR="${aRepo_Dir}/._2/JPTs/gitr.sh"
  aAnyLLMscr="${aRepo_Dir}/run-anyllm.sh"

# echo ""
# echo "  aJPTs_JDir: ${aJPTs_JDir}";
# echo "  aJPTs_GitR: ${aJPTs_GitR}";
# echo "  alias gitr: ${aJPTs_JDir}/gitr.sh";

  if [ ! -d  "${aJPTs_JDir}" ]; then sudo mkdir -p  "${aJPTs_JDir}";                     echo "  Done: created ${aJPTs_JDir}";
                                     sudo chmod 777 "${aJPTs_JDir}"; fi

# if [   -f  "${aJPTs_GitR}" ]; then cp    -p "${aJPTs_GitR}" "${aJPTs_JDir}/";          echo "  Done: copied  ${aJPTs_GitR}"; fi
  if [   -f  "${aJPTs_GitR}" ]; then mkScript "${aJPTs_GitR}" "${aJPTs_JDir}" "gitr";    echo "  Done: created ${aJPTs_GitR}";
                                     sudo chmod 777 "${aJPTs_GitR}"; fi

  if [   -f  "${aAnyLLMscr}" ]; then mkScript "${aAnyLLMscr}" "${aJPTs_JDir}" "anyllm";  echo "  Done: created ${aJPTs_JDir}/anyllm";
                                     sudo chmod 777 "${aAnyLLMscr}"; fi

# alias gitr="${aJPTs_JDir}/gitr";      echo "  Done: created alias gitr   = ${aJPTs_JDir}/gitr"
# alias anyllm="${aJPTs_JDir}/anyllm";  echo "  Done: created alias anyllm = ${aJPTs_JDir}/anyllm"
  }
# ---------------------------------------------------------------------------

  aRepo_Dir="$(pwd)"
  cd ..
  aProj_Dir="$(pwd)"

  setOSvars

  if [[ "${aCmd}" == "help"   ]]; then help; fi
  if [[ "${aCmd}" == "showEm" ]]; then showEm; fi
  if [[ "${aCmd}" == "wipeIt" ]]; then clnHouse; fi
  if [[ "${aCmd}" == "doIt"   ]]; then setBashrc; fi
  if [[ "${aCmd}" == "doIt"   ]]; then cpyToBin; fi

# ---------------------------------------------------------------------------

  cd "${aRepo_Dir}"

  exit_withCR


