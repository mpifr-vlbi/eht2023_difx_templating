# Which tracks to generate
TRACKS_230G := e23c16 e23g17 e23c18 e23e19 e23a22
TRACKS_345G := e23d15

# Revision of correlation run, e.g., v1a, gold253, gold261, gold262
#REV  := v1
REV := FRINGE

# Release version, e.g., 1 as in e22d23-1-b1
REL  := 0

# Name of site; used for ./filelists_<SITE>/
SITE := mpifr

# Top-level directory for Correlator output, any experiment
# The generated files <trackname>-$REL-{b1,b2,b3,b4}.{v2d,vex.obs}
# will be placed under directories $EXPROOT/<trackname>/$REV/<band>/
EXPROOT := /Exps/

