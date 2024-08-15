
## Get global settings; TRACKS_230G TRACKS_345G (e23...,) REV (FRINGE, v0), REL (0), SITE (mpifr), EXPROOT (/Exps)
include Makefile.inc

## Derived set of v2d,vex for DiFX outputbands correlation
DIFX_TARGETS_230G := $(addsuffix _b1_230,$(TRACKS_230G)) $(addsuffix _b2_230,$(TRACKS_230G)) $(addsuffix _b3_230,$(TRACKS_230G)) $(addsuffix _b4_230,$(TRACKS_230G))
DIFX_TARGETS_345G := $(addsuffix _b1_345,$(TRACKS_345G)) $(addsuffix _b2_345,$(TRACKS_345G)) $(addsuffix _b3_345,$(TRACKS_345G)) $(addsuffix _b4_345,$(TRACKS_345G))
DIFX_TARGETS_ALL := $(DIFX_TARGETS_230G) $(DIFX_TARGETS_345G)
TRACKS_ALL := $(TRACKS_230G) $(TRACKS_345G)

.NOTPARALLEL:

# dummy target for GNU Make pre-4.4; comment out with newer make versions
.WAIT:

default: all

b1: $(addsuffix _b1_230,$(TRACKS_230G)) $(addsuffix _b1_345,$(TRACKS_345G)) v2d_accels
b2: $(addsuffix _b2_230,$(TRACKS_230G)) $(addsuffix _b2_345,$(TRACKS_345G)) v2d_accels
b3: $(addsuffix _b3_230,$(TRACKS_230G)) $(addsuffix _b3_345,$(TRACKS_345G)) v2d_accels
b4: $(addsuffix _b4_230,$(TRACKS_230G)) $(addsuffix _b4_345,$(TRACKS_345G)) v2d_accels

## Target 'prerequisites' for the first run only:
##  - split observed VEX into shared file fragments common to all bands and setups
##  - produce common EOP for all bands and setups
##  - create blank clock files (later refined/overwritten by actual results from manual fringe searches)
##  - create initial clock files for SMA from their spreadsheet data files for each day
##  - create NOEMA phase ref $SITE coordinates for each track (to avoid shadowing they often switch ref antenna on different days)
##  - create standard ALMA and NOEMA freq setup VEX chan_def's
prerequisites:
	mkdir -p out
	. scripts/extract_vex_portions.sh
	. scripts/create_vex_EOPs.sh
	. scripts/make_initial_clocks.sh
	. scripts/make_initial_notes.sh
	## Recorded Mark6 file lists
	make -C filelists bonn
	make -C filelists hays
	make -C filelists install
	## NOEMA Array Reference Positions
	for exptname in $(TRACKS_ALL); do \
		./scripts/vlbimonitordb/vlbimon-get-noemaPosition.py $${exptname} > ./templates/common_sections/sites_NOEMA_$${exptname}.vex ; \
	done
	# ./scripts/noema-vex-defs.py --lo1 221.100 --lo2 7.744 -r 1,2 > templates/230G/band2/freqs_NOEMA.vex # commented out after decision 5/2021 to ignore the 4x64 MHz overlap of b2 into recorder1
	# ./scripts/noema-vex-defs.py --lo1 221.100 --lo2 7.744 -r 3,4 > templates/230G/band3/freqs_NOEMA.vex
	## 230G
	./scripts/noema-vex-defs.py --lo1 221.100 --lo2 7.744 -r 1   > templates/230G/band1/freqs_NOEMA.vex
	./scripts/noema-vex-defs.py --lo1 221.100 --lo2 7.744 -r 2   > templates/230G/band2/freqs_NOEMA.vex
	./scripts/noema-vex-defs.py --lo1 221.100 --lo2 7.744 -r 4   > templates/230G/band3/freqs_NOEMA.vex
	./scripts/noema-vex-defs.py --lo1 221.100 --lo2 7.744 -r 3   > templates/230G/band4/freqs_NOEMA.vex
	./scripts/alma-vex-defs.py --lo1 221.100 -r 1 > templates/230G/band1/freqs_ALMA.vex
	./scripts/alma-vex-defs.py --lo1 221.100 -r 2 > templates/230G/band2/freqs_ALMA.vex
	./scripts/alma-vex-defs.py --lo1 221.100 -r 3 > templates/230G/band3/freqs_ALMA.vex
	./scripts/alma-vex-defs.py --lo1 221.100 -r 4 > templates/230G/band4/freqs_ALMA.vex
	#
	## 345G
	./scripts/noema-vex-defs.py -c "4-8" --lo1 342.600 --lo2 7.744 -r 1   > templates/345G/band1/freqs_NOEMA.vex
	./scripts/noema-vex-defs.py -c "4-8" --lo1 342.600 --lo2 7.744 -r 2   > templates/345G/band2/freqs_NOEMA.vex
	./scripts/noema-vex-defs.py -c "4-8" --lo1 342.600 --lo2 7.744 -r 4   > templates/345G/band3/freqs_NOEMA.vex
	./scripts/noema-vex-defs.py -c "4-8" --lo1 342.600 --lo2 7.744 -r 3   > templates/345G/band4/freqs_NOEMA.vex
	#    
	./scripts/alma-vex-defs.py --lo1 343.600      -r 1 > templates/345G/band1/freqs_ALMA.vex      # equiv. to $ehtc/alma-vex-defs.py -f335600.00000 -w58.0 -sL -ralma
	#./scripts/alma-vex-defs.py --lo1 343.600     -r 2 > templates/345G/band2/freqs_ALMA_alt.vex  # equiv. to $ehtc/alma-vex-defs.py -f337600.00000 -w58.0 -sL -ralma
	./scripts/alma-vex-defs.py --lo1 343.54140625 -r 2 > templates/345G/band2/freqs_ALMA.vex # equiv. to $ehtc/alma-vex-defs.py -f337541.40625 -w58.0 -sL -ralma; shifted 58.59375 MHz
	./scripts/alma-vex-defs.py --lo1 341.600      -r 3 > templates/345G/band3/freqs_ALMA.vex      # equiv. to $ehtc/alma-vex-defs.py -f347600.00000 -w58.0 -sU -ralma
	./scripts/alma-vex-defs.py --lo1 341.600      -r 4 > templates/345G/band4/freqs_ALMA.vex      # equiv. to $ehtc/alma-vex-defs.py -f349600.00000 -w58.0 -sU -ralma
	## Note: DiFX $ehtc/alma-vex-defs.py would be more direct, but its chan_defs are not useable as-is,
	##       vs own ./scripts/alma-vex-defs.py usable for that while not being 4-8/5-9 aware, plus the 345G b2 offset trickyness
	#
	## SMA a priori clock files; clock rate identical to that of JCMT (shared H-maser)
	#  Note that SMA has no band 4 in 345G track(s) due to capability to switch between 4-8G / 5-9G IF filters
	./scripts/vexdelay.py -f ./priors/sma/eht2023-delays-b1.rx230.sbLSB.quad1.txt -c 0.5126 --rate=-0.158e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/230G/band1/clocks_SMA.vex
	./scripts/vexdelay.py -f ./priors/sma/eht2023-delays-b2.rx230.sbLSB.quad0.txt -c 0.5126 --rate=-0.158e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/230G/band2/clocks_SMA.vex
	./scripts/vexdelay.py -f ./priors/sma/eht2023-delays-b3.rx230.sbUSB.quad1.txt -c 0.5126 --rate=-0.158e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/230G/band3/clocks_SMA.vex
	./scripts/vexdelay.py -f ./priors/sma/eht2023-delays-b4.rx230.sbUSB.quad2.txt -c 0.5126 --rate=-0.158e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/230G/band4/clocks_SMA.vex
	#
	./scripts/vexdelay.py -f ./priors/sma/eht2023-delays-b1.rx345.sbLSB.quad1.txt -c 0.5126 --rate=-0.158e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/345G/band1/clocks_SMA.vex
	./scripts/vexdelay.py -f ./priors/sma/eht2023-delays-b2.rx345.sbLSB.quad0.txt -c 0.5126 --rate=-0.158e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/345G/band2/clocks_SMA.vex
	./scripts/vexdelay.py -f ./priors/sma/eht2023-delays-b3.rx345.sbUSB.quad1.txt -c 0.5126 --rate=-0.158e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/345G/band3/clocks_SMA.vex



etransferDirs:
	for exptname in $(TRACKS_ALL); do \
		mkdatadir $${exptname} ; \
		for station in Aa Ax Pv Lm Kt Mm Sw Gl Sz; do \
			mkdatadir $${exptname}/$${station} ; \
			mkdatadir $${exptname}/$${station}/12 ; \
			mkdatadir $${exptname}/$${station}/34 ; \
		done ; \
		mkdatadir $${exptname}/Nn ; \
		mkdatadir $${exptname}/Nn/1 ; \
		mkdatadir $${exptname}/Nn/2 ; \
		mkdatadir $${exptname}/Nn/3 ; \
		mkdatadir $${exptname}/Nn/4 ; \
	done


####################################################################################
## Build and install full correlation v2d vex config sets
####################################################################################

all: $(DIFX_TARGETS_ALL) .WAIT v2d_accels

install: b1_install b2_install b3_install b4_install

diff: b1_diff b2_diff b3_diff b4_diff

%_install:
	for exptname in $(TRACKS_ALL); do \
		mkdir -p $(EXPROOT)/$${exptname}/$(REV)/$*/ ; \
		cp -av out/$${exptname}-${REL}-$*.{v2d,vex.obs} $(EXPROOT)/$${exptname}/$(REV)/$*/ ; \
	done

%_diff:
	for exptname in $(TRACKS_ALL); do \
		diff -u out/$${exptname}-$(REL)-$*.vex.obs $(EXPROOT)/$${exptname}/$(REV)/$*/$${exptname}-$(REL)-$*.vex.obs && true ; \
	done ; \
	for exptname in $(TRACKS_ALL); do \
		diff -u out/$${exptname}-$(REL)-$*.v2d $(EXPROOT)/$${exptname}/$(REV)/$*/$${exptname}-$(REL)-$*.v2d && true ; \
	done ; exit 0


####################################################################################
## EHT 2023 -- Band 1
####################################################################################

# Generic band 1 build patterns
%_b1_230:
	@ ./tvex2vex.py -I./templates/230G/band1/ -I./templates/common_sections/ templates/$*.vext out/$*-$(REL)-b1.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band1/ -I./templates/common_sections/ templates/$*.v2dt out/$*-$(REL)-b1.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b1.vex.obs/g" out/$*-$(REL)-b1.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.0 # LMT extra offsets/g" out/e23d15-$(REL)-b1.v2d
	# ...
	sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = -37.2 # SMA extra offsets/g" out/e23c16-$(REL)-b1.v2d
	# ...

%_b1_345:
	@ ./tvex2vex.py -I./templates/345G/band1/ -I./templates/common_sections/ templates/$*.vext out/$*-$(REL)-b1.vex.obs
	@ ./tvex2vex.py -I./templates/345G/band1/ -I./templates/common_sections/ templates/$*.v2dt out/$*-$(REL)-b1.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b1.vex.obs/g" out/$*-$(REL)-b1.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.0 # LMT extra offsets/g" out/e23d15-$(REL)-b1.v2d
	# ...
	# sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = 0.0 # SMA extra offsets/g" out/e23d15-$(REL)-b1.v2d
	# ...

# Custom-fiddled band 1 builds
# (none)

####################################################################################
## EHT 2023 -- Band 2
####################################################################################

# Generic band 2 build patterns
%_b2_230:
	@ ./tvex2vex.py -I./templates/230G/band2/ -I./templates/common_sections/ templates/$*.vext out/$*-$(REL)-b2.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band2/ -I./templates/common_sections/ templates/$*.v2dt out/$*-$(REL)-b2.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b2.vex.obs/g" out/$*-$(REL)-b2.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.0 # LMT extra offsets/g" out/e23d15-$(REL)-b2.v2d
	# ...
	# sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = 0.0 # SMA extra offsets/g" out/e23d15-$(REL)-b2.v2d
	# ...

%_b2_345:
	@ ./tvex2vex.py -I./templates/345G/band2/ -I./templates/common_sections/ templates/$*.vext out/$*-$(REL)-b2.vex.obs
	@ ./tvex2vex.py -I./templates/345G/band2/ -I./templates/common_sections/ templates/$*.v2dt out/$*-$(REL)-b2.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b2.vex.obs/g" out/$*-$(REL)-b2.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.0 # LMT extra offsets/g" out/e23d15-$(REL)-b2.v2d
	# ...
	# sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = 0.0 # SMA extra offsets/g" out/e23d15-$(REL)-b2.v2d
	# ...

# Custom-fiddled band 2 builds
# (none)

####################################################################################
## EHT 2023 -- Band 3
####################################################################################

# Generic band 3 build patterns
%_b3_230:
	@ ./tvex2vex.py -I./templates/230G/band3/ -I./templates/common_sections/ templates/$*.vext out/$*-$(REL)-b3.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band3/ -I./templates/common_sections/ templates/$*.v2dt out/$*-$(REL)-b3.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b3.vex.obs/g" out/$*-$(REL)-b3.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.0 # LMT extra offsets/g" out/e23d15-$(REL)-b3.v2d
	# ...
	# sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = 0.0 # SMA extra offsets/g" out/e23d15-$(REL)-b3.v2d
	# ...

%_b3_345:
	@ ./tvex2vex.py -I./templates/345G/band3/ -I./templates/common_sections/ templates/$*.vext out/$*-$(REL)-b3.vex.obs
	@ ./tvex2vex.py -I./templates/345G/band3/ -I./templates/common_sections/ templates/$*.v2dt out/$*-$(REL)-b3.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b3.vex.obs/g" out/$*-$(REL)-b3.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.0 # LMT extra offsets/g" out/e23d15-$(REL)-b3.v2d
	# ...
	# sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = 0.0 # SMA extra offsets/g" out/e23d15-$(REL)-b3.v2d
	# ...

# Custom-fiddled band 3 builds
# (none)

####################################################################################
## EHT 2023 -- Band 4
####################################################################################

# Generic band 4 build patterns
%_b4_230:
	@ ./tvex2vex.py -I./templates/230G/band4/ -I./templates/common_sections/ templates/$*.vext out/$*-$(REL)-b4.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band4/ -I./templates/common_sections/ templates/$*.v2dt out/$*-$(REL)-b4.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b4.vex.obs/g" out/$*-$(REL)-b4.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.0 # LMT extra offsets/g" out/e23d15-$(REL)-b4.v2d
	# ...
	# sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = 0.0 # SMA extra offsets/g" out/e23d15-$(REL)-b4.v2d
	# ...

%_b4_345:
	@ ./tvex2vex.py -I./templates/345G/band4/ -I./templates/common_sections/ templates/$*.vext out/$*-$(REL)-b4.vex.obs
	@ ./tvex2vex.py -I./templates/345G/band4/ -I./templates/common_sections/ templates/$*.v2dt out/$*-$(REL)-b4.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b4.vex.obs/g" out/$*-$(REL)-b4.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.0 # LMT extra offsets/g" out/e23d15-$(REL)-b4.v2d
	# ...
	# sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = 0.0 # SMA extra offsets/g" out/e23d15-$(REL)-b4.v2d
	# ...


# Custom-fiddled band 3 builds
# (none)


####################################################################################
## Common
####################################################################################

v2d_accels:
	sed -i "s/deltaClockAccel = 0 # LMT clock acceleration/deltaClockAccel = -4.317305e-11 # LMT clock acceleration/g" out/e23c16-$(REL)-b?.v2d
	sed -i "s/deltaClockAccel = 0 # LMT clock acceleration/deltaClockAccel = -2.443898e-11 # LMT clock acceleration/g" out/e23g17-$(REL)-b?.v2d
	sed -i "s/deltaClockAccel = 0 # LMT clock acceleration/deltaClockAccel = -1.916262e-11 # LMT clock acceleration/g" out/e23e19-$(REL)-b?.v2d
	#
	sed -i "s/deltaClockAccel = 0 # KT clock acceleration/deltaClockAccel = +7.687584e-10 # KT clock acceleration/g" out/e23c18-$(REL)-b?.v2d
	sed -i "s/deltaClockAccel = 0 # KT clock acceleration/deltaClockAccel = +1.468801e-10 # KT clock acceleration/g" out/e23a22-$(REL)-b?.v2d

####################################################################################

