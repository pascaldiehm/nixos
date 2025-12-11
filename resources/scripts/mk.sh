#!/usr/bin/env bash

if [ "$#" = 0 ]; then
  echo "Usage: mk <what>"
  exit 1
elif [ "$1" = "cmake" ]; then
  cat <<EOF >CMakeLists.txt
cmake_minimum_required(VERSION 3.10.0)
project(Project)
EOF
elif [ "$1" = "flake" ]; then
  cat <<EOF >flake.nix
{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { flake-utils, nixpkgs, ... }: flake-utils.lib.eachDefaultSystem (
    system: let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lib = pkgs.lib;
    in { packages.default = pkgs.hello; }
  );
}
EOF
elif [ "$1" = "license" ]; then
  cat <<EOF >LICENSE
MIT License

Copyright (c) $(date "+%Y") Pascal Diehm

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
elif [ "$1" = "tex" ]; then
  cat <<EOF >main.tex
\documentclass[parskip=half]{scrartcl}
\usepackage[margin=1cm, bottom=2cm]{geometry}

\title{}
\author{}

\begin{document}
\maketitle
\end{document}
EOF
elif [ "$1" = "tex-letter" ]; then
  cat <<EOF >letter.tex
\documentclass[parskip=half]{scrlttr2}
\usepackage[ngerman]{babel}

\renewcommand{\raggedsignature}{\raggedright}

\setkomavar{fromname}{}
\setkomavar{fromaddress}{}
\setkomavar{subject}{}

\begin{document}
\begin{letter}{}
  \opening{}
  \closing{}
\end{letter}
\end{document}
EOF
else
  echo "Cannot make $1"
  exit 1
fi
