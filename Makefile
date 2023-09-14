
## Get global settings; TRACKS (e23...,) REV (v0), REL (0), SITE (mpifr), EXPROOT (/Exps)
# e23d15 : 345 GHz SgrA* track
# e23??? : 230 GHz tracks
include Makefile.inc

## Derived set of v2d,vex in both conventional zoom setup and outputband setup
DIFX_TARGETS_ZOOM := $(addsuffix _b1,$(TRACKS)) $(addsuffix _b2,$(TRACKS)) $(addsuffix _b3,$(TRACKS)) $(addsuffix _b4,$(TRACKS))
DIFX_TARGETS_OUTPUTBAND := $(addsuffix _ob,$(DIFX_TARGETS_ZOOM))
DIFX_TARGETS_345G_ZOOM := $(addsuffix _b1_345,$(TRACKS_345G)) $(addsuffix _b2_345,$(TRACKS_345G)) $(addsuffix _b3_345,$(TRACKS_345G)) # $(addsuffix _b4_345,$(TRACKS_345G))
DIFX_TARGETS_345G_OUTPUTBAND := $(addsuffix _ob,$(DIFX_TARGETS_345G_ZOOM))
# DIFX_TARGETS := $(DIFX_TARGETS_OUTPUTBAND) $(DIFX_TARGETS_345G_OUTPUTBAND)
# TODO: make 345 GHz band 1 to 4 defaults
DIFX_TARGETS := $(DIFX_TARGETS_OUTPUTBAND)

# .NOTPARALLEL:  # note: quite slow build, commented out again; but be careful to do 'make all' and then 'make install' as separate steps, not 'make all install'

default: all

## Target 'prerequisites' for the first run only:
##  - split observed VEX into shared file fragments common to all bands and setups
##  - produce common EOP for all bands and setups
##  - create blank clock files (later refined/overwritten by actual results from manual fringe searches)
##  - create initial clock files for SMA from their spreadsheet data files for each day
##  - create NOEMA phase ref $SITE coordinates for each track (to avoid shadowing they often switch ref antenna on different days)
##  - create standard ALMA and NOEMA freq setup VEX chan_def's
prerequisites:
	mkdir -p out
	mkdir -p out/conventional/
	mkdir -p out/outputbands/
	. scripts/extract_vex_portions.sh
	. scripts/create_vex_EOPs.sh
	. scripts/make_initial_clocks.sh
	. scripts/make_initial_notes.sh
	## NOEMA Array Reference Positions
	for exptname in $(TRACKS); do \
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
	##       vs own ./scripts/alma-vex-defs.py usable for that but is not 4-8/5-9 aware plus b2 offset trickyness
	## SMA a priori clock CSV files
	./scripts/vexdelay.py -f ./priors/sma-delays.rx230.sbLSB.quad1.b1.csv -c 0.5126 --rate=-0.090e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/230G/band1/clocks_SMA.vex
	./scripts/vexdelay.py -f ./priors/sma-delays.rx230.sbLSB.quad0.b2.csv -c 0.5126 --rate=-0.090e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/230G/band2/clocks_SMA.vex
	./scripts/vexdelay.py -f ./priors/sma-delays.rx230.sbUSB.quad1.b3.csv -c 0.5126 --rate=-0.090e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/230G/band3/clocks_SMA.vex
	./scripts/vexdelay.py -f ./priors/sma-delays.rx230.sbUSB.quad2.b4.csv -c 0.5126 --rate=-0.090e-12 -s Sw -g 0.0 2023y105d01h40m00s 2023y112d07h55m00s > templates/230G/band4/clocks_SMA.vex

datadirsDR2023:
	for exptname in $(TRACKS); do \
		mkdatadir $${exptname} ; \
		for station in Aa Pv Lm Gl Sw; do \
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

all: $(DIFX_TARGETS)

install: b1_install b2_install b3_install b4_install

diff: b1_diff b2_diff b3_diff b4_diff

%_install:
	for exptname in $(TRACKS); do \
		mkdir -p $(EXPROOT)/$${exptname}/$(REV)/$*/ ; \
		mkdir -p $(EXPROOT)/$${exptname}/$(REV)/$*_outputbands/ ; \
		cp -av out/conventional/$${exptname}-${REL}-$*.{v2d,vex.obs} $(EXPROOT)/$${exptname}/$(REV)/$*/ ; \
		cp -av out/outputbands/$${exptname}-${REL}-$*.{v2d,vex.obs} $(EXPROOT)/$${exptname}/$(REV)/$*_outputbands/ ; \
	done

%_diff:
	for exptname in $(TRACKS); do \
		diff -u out/outputbands/$${exptname}-$(REL)-$*.vex.obs $(EXPROOT)/$${exptname}/$(REV)/$*_outputbands/$${exptname}-$(REL)-$*.vex.obs && true ; \
	done ; exit 0

####################################################################################
## EHT 2023 -- Band 1
####################################################################################

# Generic band 1 build patterns
%_b1:
	@ ./tvex2vex.py -I./templates/230G/band1/ -I./templates/common_sections/ templates/$*.vext out/conventional/$*-$(REL)-b1.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band1/ -I./templates/common_sections/ templates/$*.v2dt out/conventional/$*-$(REL)-b1.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b1.vex.obs/g" out/conventional/$*-$(REL)-b1.v2d

%_b1_ob:
	@ ./tvex2vex.py -I./templates/230G/band1/ -I./templates/common_sections/ templates/$*.vext out/outputbands/$*-$(REL)-b1.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band1/ -I./templates/common_sections/ templates/$*_outputbands.v2dt out/outputbands/$*-$(REL)-b1.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b1.vex.obs/g" out/outputbands/$*-$(REL)-b1.v2d

%_b1_345_ob:
	@ ./tvex2vex.py -I./templates/345G/band1/ -I./templates/common_sections/ templates/$*.vext out/outputbands/$*-$(REL)-b1.vex.obs
	@ ./tvex2vex.py -I./templates/345G/band1/ -I./templates/common_sections/ templates/$*_outputbands.v2dt out/outputbands/$*-$(REL)-b1.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b1.vex.obs/g" out/outputbands/$*-$(REL)-b1.v2d

# Custom-fiddled band 1 builds
# (none)

####################################################################################
## EHT 2023 -- Band 2
####################################################################################

# Generic band 2 build patterns
%_b2:
	@ ./tvex2vex.py -I./templates/230G/band2/ -I./templates/common_sections/ templates/$*.vext out/conventional/$*-$(REL)-b2.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band2/ -I./templates/common_sections/ templates/$*.v2dt out/conventional/$*-$(REL)-b2.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b2.vex.obs/g" out/conventional/$*-$(REL)-b2.v2d

%_b2_ob:
	@ ./tvex2vex.py -I./templates/230G/band2/ -I./templates/common_sections/ templates/$*.vext out/outputbands/$*-$(REL)-b2.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band2/ -I./templates/common_sections/ templates/$*_outputbands.v2dt out/outputbands/$*-$(REL)-b2.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b2.vex.obs/g" out/outputbands/$*-$(REL)-b2.v2d

%_b2_345_ob:
	@ ./tvex2vex.py -I./templates/345G/band2/ -I./templates/common_sections/ templates/$*.vext out/outputbands/$*-$(REL)-b2.vex.obs
	@ ./tvex2vex.py -I./templates/345G/band2/ -I./templates/common_sections/ templates/$*_outputbands.v2dt out/outputbands/$*-$(REL)-b2.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b2.vex.obs/g" out/outputbands/$*-$(REL)-b2.v2d

# Custom-fiddled band 2 builds
# (none)

####################################################################################
## EHT 2023 -- Band 3
####################################################################################

# Generic band 3 build patterns
%_b3:
	@ ./tvex2vex.py -I./templates/230G/band3/ -I./templates/common_sections/ templates/$*.vext out/conventional/$*-$(REL)-b3.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band3/ -I./templates/common_sections/ templates/$*.v2dt out/conventional/$*-$(REL)-b3.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b3.vex.obs/g" out/conventional/$*-$(REL)-b3.v2d

%_b3_ob:
	@ ./tvex2vex.py -I./templates/230G/band3/ -I./templates/common_sections/ templates/$*.vext out/outputbands/$*-$(REL)-b3.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band3/ -I./templates/common_sections/ templates/$*_outputbands.v2dt out/outputbands/$*-$(REL)-b3.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b3.vex.obs/g" out/outputbands/$*-$(REL)-b3.v2d

%_b3_345_ob:
	@ ./tvex2vex.py -I./templates/345G/band3/ -I./templates/common_sections/ templates/$*.vext out/outputbands/$*-$(REL)-b3.vex.obs
	@ ./tvex2vex.py -I./templates/345G/band3/ -I./templates/common_sections/ templates/$*_outputbands.v2dt out/outputbands/$*-$(REL)-b3.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b3.vex.obs/g" out/outputbands/$*-$(REL)-b3.v2d

# Custom-fiddled band 3 builds
# (none)

####################################################################################
## EHT 2023 -- Band 4
####################################################################################

# Generic band 4 build patterns
%_b4:
	@ ./tvex2vex.py -I./templates/230G/band4/ -I./templates/common_sections/ templates/$*.vext out/conventional/$*-$(REL)-b4.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band4/ -I./templates/common_sections/ templates/$*.v2dt out/conventional/$*-$(REL)-b4.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b4.vex.obs/g" out/conventional/$*-$(REL)-b4.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.0 # LMT extra offsets/g" out/conventional/e23d15-$(REL)-b4.v2d
	# ...
	#
	# sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = 0.0 # SMA extra offsets/g" out/conventional/e23d15-$(REL)-b4.v2d
	# ...

%_b4_ob:
	@ ./tvex2vex.py -I./templates/230G/band4/ -I./templates/common_sections/ templates/$*.vext out/outputbands/$*-$(REL)-b4.vex.obs
	@ ./tvex2vex.py -I./templates/230G/band4/ -I./templates/common_sections/ templates/$*_outputbands.v2dt out/outputbands/$*-$(REL)-b4.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b4.vex.obs/g" out/outputbands/$*-$(REL)-b4.v2d
	# sed -i "s/deltaClock = 0 # LMT extra offsets/deltaClock = 0.424 # LMT extra offsets/g" out/outputbands/e22c20-$(REL)-b4.v2d
	# ...
	#
	# sed -i "s/deltaClock = 0 # SMA extra offsets/deltaClock = -105.462 # SMA extra offsets/g" out/outputbands/e22g18-$(REL)-b4.v2d
	# ...

%_b4_345_ob:
	@ ./tvex2vex.py -I./templates/345G/band4/ -I./templates/common_sections/ templates/$*.vext out/outputbands/$*-$(REL)-b4.vex.obs
	@ ./tvex2vex.py -I./templates/345G/band4/ -I./templates/common_sections/ templates/$*_outputbands.v2dt out/outputbands/$*-$(REL)-b4.v2d
	@ sed -i "s/vexfilename/$*-${REL}-b4.vex.obs/g" out/outputbands/$*-$(REL)-b4.v2d

# Custom-fiddled band 3 builds
# (none)

####################################################################################

