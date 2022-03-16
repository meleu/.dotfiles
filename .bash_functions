# meleu's .bash_function
########################

# private stuff
if [ -f "${HOME}/.bash_functions_private" ]; then
  source "${HOME}/.bash_functions_private"
fi


# urlencode(): URL encode using pure bash.
urlencode() {
  local LC_ALL=C
  local string="$*"
  local length="${#string}"
  local char

  for (( i = 0; i < length; i++ )); do
    char="${string:i:1}"
    if [[ "$char" == [a-zA-Z0-9.~_-] ]]; then
      printf "$char" 
    else
      printf '%%%02X' "'$char" 
    fi
  done
  printf '\n' # opcional
}


# urldecode(): URL decode using pure bash.
urldecode() {
  local encoded="${*//+/ }"
  printf '%b' "${encoded//%/\\x}"
}


# launch(): Open the file/URL with the default application.
launch() {
  local args="$@"

  case "$OSTYPE" in
    "cygwin"*)
      cygstart "$args"
      ;;
    "darwin"*) # MacOS
      open "$args"
      ;;
    *)
      xdg-open "$args"
      ;;
  esac
}


# google(): Open google.com in the default browser, arguments are used as search terms.
google() {
  local terms
  terms="$(urlencode $@)"
  launch "https://www.google.com/search?q=${terms}"
}


# 0x0(): Upload file or URL shortener. See more info at https://0x0.st/
0x0() {
  local arg="$1"
  local curlArg

  if [[ -f "${arg}" ]]; then
    curlArg="file=@${arg}"
  elif [[ ${arg} =~ ^https?://.* ]]; then
    curlArg="shorten=${arg}"
  else
    echo "error: '${arg}': invalid argument (not a file neither a URL)" >&2
    return 1
  fi

  curl -F"${curlArg}" https://0x0.st
}


# transfer(): upload file to https://transfer.sh
transfer() {
  local url='https://transfer.sh'
  local file
  local file_name

  uploadFile() {
    curl --progress-bar --upload-file "-" "${url}/${file_name}" \
      | tee /dev/null
  }

  # usage
  if [ $# -eq 0 ]; then
    echo -e "No arguments specified.\nUsage:\n  transfer <file|directory>\n  ... | transfer <file_name>">&2
    return 1
  fi

  # check if there's a terminal connected to the standard input
  if tty -s; then
    file="$1"
    file_name=$(basename "$file")

    if [ ! -e "$file" ]; then
      echo "$file: No such file or directory">&2
      return 1
    fi

    # if it's a dir, create a zip
    if [ -d "$file" ]; then
      file_name="$file_name.zip" ,
      (cd "$file" && zip -r -q - .) | uploadFile
    else
      cat "$file" | uploadFile
    fi

  else
    file_name=$1
    uploadFile
  fi
  echo 
}


dud() {
  du --max-depth 1 --human-readable "${@:-.}" | sort --human-numeric-sort
}
