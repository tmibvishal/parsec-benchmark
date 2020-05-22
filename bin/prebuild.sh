#!/bin/bash
# Compiles some libs and tools related to app using gcc (and put them in clang folder) that cannot be compiled using clang

p=${p:-none}
c=${c:-none}

while [ $# -gt 0 ]; do

   if [[ $1 == *"-"* ]]; then
        param="${1/-/}"
        declare $param="$2"
        # echo $1 $2
   fi

  shift
done

echo $p $c

# We need to hard-wire a few commands because we need them for the path detection
PWD="pwd"
BASENAME="basename"
DIRNAME="dirname"

# Determine script name
eval me=$(${BASENAME} $0)

# Try to find path
uniquefile=".parsec_uniquefile"
parsecdir=""
if [ ! -z "${PARSECDIR}" ]; then
# User defined PARSECDIR, check it
parsecdir="${PARSECDIR}"
if [ ! -f "${parsecdir}/${uniquefile}" ]; then
  echo "${oprefix} Error: Variable PARSECDIR points to '${PARSECDIR}', but this does not seem to be the PARSEC directory. Either unset PARSECDIR to make me try to autodetect the path or set it to the correct value."
  exit 1
fi
else
# Try to autodetect path by looking at path used to invoke this script

# Try to extract absoute or relative path
if [ "${0:0:1}" == "/" ]; then
  # Absolute path given
  eval parsecdir=$(${DIRNAME} $(${DIRNAME} $0))
  # Check
  if [ -f "${parsecdir}/${uniquefile}" ]; then
    PARSECDIR=${parsecdir}
  fi
else
  # No absolute path, maybe relative path?
  eval parsecdir=$(${PWD})/$(${DIRNAME} $(${DIRNAME} $0))
  # Check
  if [ -f "${parsecdir}/${uniquefile}" ]; then
    PARSECDIR=${parsecdir}
  fi
fi

# If PARSECDIR is still undefined, we try to guess the path
if [ -z "${PARSECDIR}" ]; then
  # Check current directory
  if [ -f "./${uniquefile}" ]; then
    parsecdir="$(${PWD})"
    PARSECDIR=${parsecdir}
  fi
fi
if [ -z "${PARSECDIR}" ]; then
  # Check next-higher directory
  if [ -f "../${uniquefile}" ]; then
    parsecdir="$(${PWD})/.."
    PARSECDIR=${parsecdir}
  fi
fi
fi

if [ $p == "none" ]
then
	echo format ./bin/prebuild.sh -p program -c config
else
	if [ $c == "none" ]
	then
		echo format ./bin/prebuild.sh -p program -c config
	else
		if [ $p == "raytrace" ]
		then
			${parsecdir}/bin/parsecmgmt -a build -p mesa -c gcc
			cp -r ${parsecdir}/pkgs/libs/mesa/inst/amd64-linux.gcc ${parsecdir}/pkgs/libs/mesa/inst/amd64-linux.${c}
		fi
	fi
fi


