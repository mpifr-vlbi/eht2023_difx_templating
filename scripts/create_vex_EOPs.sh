#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
OUTDIR=../templates/common_sections/

pushd $SCRIPT_DIR  2>&1 > /dev/null

# e23d15.vex:*    year, doy: 2023, 105
# e23c16.vex:*    year, doy: 2023, 106
# e23g17.vex:*    year, doy: 2023, 107
# e23c18.vex:*    year, doy: 2023, 108
# e23e19.vex:*    year, doy: 2023, 109
# e23a22.vex:*    year, doy: 2023, 111

./geteop.pl 2023-103  5 $OUTDIR/eop_e23d15.vex
./geteop.pl 2023-104  5 $OUTDIR/eop_e23c16.vex
./geteop.pl 2023-105  5 $OUTDIR/eop_e23g17.vex
./geteop.pl 2023-106  5 $OUTDIR/eop_e23c18.vex
./geteop.pl 2023-107  5 $OUTDIR/eop_e23e19.vex
./geteop.pl 2023-109  5 $OUTDIR/eop_e23a22.vex

popd  2>&1 > /dev/null

