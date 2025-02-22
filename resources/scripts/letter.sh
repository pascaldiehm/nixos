#!/usr/bin/env bash

set -e

function readline() {
  read -r -p "$1" "$2"
}

function readmultiline() {
  local BUILD=""
  local READ=""

  while true; do
    read -r -p "$1" READ
    [ "$READ" = "" ] && break
    BUILD="$BUILD${BUILD:+$3}$READ"
  done

  export "$2"="$BUILD"
}

readline "From name: " FROM_NAME
readmultiline "From address: " FROM_ADDRESS "\\\\"
echo

readmultiline "Recipient: " RECIPIENT "\\\\"
echo

readline "Subject: " SUBJECT
readline "Date: " DATE
echo

readline "Opening: " OPENING
echo

readmultiline "> " TEXT $'\n\n'
echo

readline "Closing: " CLOSING
echo

if [ "$RECIPIENT" = "" ]; then
  echo "RECIPIENT is required"
  exit 1
fi

DIR="$(mktemp -d)"
pushd "$DIR"

cat <<EOF >letter.tex
\documentclass[parskip=half]{scrlttr2}

\usepackage[ngerman]{babel}

\renewcommand{\raggedsignature}{\raggedright}

${FROM_NAME:+"\\setkomavar\{fromname}{$FROM_NAME}"}
${FROM_ADDRESS:+"\\setkomavar{fromaddress}{$FROM_ADDRESS}"}
${SUBJECT:+"\\setkomavar{subject}{$SUBJECT}"}
${DATE:+"\\setkomavar{date}{$DATE}"}

\begin{document}
\begin{letter}{$RECIPIENT}
  ${OPENING:+"\\opening{$OPENING}"}

  $TEXT

  ${CLOSING:+"\\closing{$CLOSING}"}
\end{letter}
\end{document}
EOF

pdflatex letter.tex
popd

mv "$DIR/letter.pdf" .
rm -rf "$DIR"
