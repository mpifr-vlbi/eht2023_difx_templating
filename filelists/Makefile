## Get global settings; TRACKS (e23...), REV (FRINGE), REL (0), SITE (mpifr), EXPROOT (/Exps)
include ../Makefile.inc

M6DIRS := /cluster/difx/directories/

TRACKS_ALL := $(TRACKS_230G) $(TRACKS_345G)

mk6dir2filelist = grep "^e23" $(M6DIRS)/$(3).filelist | sort -k 2 | sed -e 's/^/\/$(1)_fuse\/$(2)\//' | cut -d' ' -f 1,2,3 > $(4)

#.NOTPARALLEL:

all:
	@echo "Options:  'make bonn'  or  'make hays'"

bonn: aa_b1 ax_b1 gl_b1 kt_b1 lm_b1 mg_b1 mm_b1 nn_b1 sw_b1 sz_b1 \
	aa_b4 ax_b4 gl_b4 kt_b4 lm_b4 mg_b4 mm_b4 nn_b4 sw_b4 sz_b4

hays: aa_b2 ax_b2 gl_b2 kt_b2 lm_b2 mg_b2 mm_b2 nn_b2 sw_b2 sz_b2 \
	aa_b3 ax_b3 gl_b3 kt_b3 lm_b3 mg_b3 mm_b3 nn_b3 sw_b3 sz_b3

## ALMA
# undocumented and Confluence.alma.cl inaccessible

aa_b1:
	$(call mk6dir2filelist,mark6-01,12,SAO%0025,ALMA_b1.12.filelist)
	$(call mk6dir2filelist,mark6-01,34,SAO%0027,ALMA_b1.34.filelist)

aa_b2:
	@echo "TODO get ALMA Band 2 MSNs list!"
	touch ALMA_b2.12.filelist ALMA_b2.34.filelist

aa_b3:
	@echo "TODO get ALMA Band 3 MSNs list!"
	touch ALMA_b3.12.filelist ALMA_b3.34.filelist

aa_b4:
	$(call mk6dir2filelist,mark6-01,12,SAO%0040,ALMA_b4.12.filelist)
	$(call mk6dir2filelist,mark6-01,34,SAO%0031,ALMA_b4.34.filelist)

## APEX
#
# https://eht-wiki.haystack.mit.edu/Event_Horizon_Telescope_Home/Observing/2023_April/APEX_2023-04
# slot 1,2 = RCP, slot 3,4 = LCP
# band 4 PCal tone at 423 MHz

ax_b1:
	$(call mk6dir2filelist,mark6-09,12,PERI%015,APEX_b1.12.filelist)
	$(call mk6dir2filelist,mark6-09,34,PERI%019,APEX_b1.34.filelist)

ax_b2:
	$(call mk6dir2filelist,mark6-09,12,PERI%021,APEX_b2.12.filelist)
	$(call mk6dir2filelist,mark6-09,34,PERI%023,APEX_b2.34.filelist)

ax_b3:
	$(call mk6dir2filelist,mark6-09,12,PERI%003,APEX_b3.12.filelist)
	$(call mk6dir2filelist,mark6-09,34,PERI%005,APEX_b3.34.filelist)

ax_b4:
	$(call mk6dir2filelist,mark6-09,12,PERI%007,APEX_b4.12.filelist)
	$(call mk6dir2filelist,mark6-09,34,PERI%009,APEX_b4.34.filelist)

## GLT
#
# https://eht-wiki.haystack.mit.edu/Event_Horizon_Telescope_Home/Observing/2023_April/GLT_2023-04
# slot 1,2 = V-LCP, slot 3,4 = H-RCP

gl_b1:
	$(call mk6dir2filelist,mark6-02,12,BHC%0045,GLT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-02,34,BHC%0065,GLT_b1.34.filelist)

gl_b2:
	$(call mk6dir2filelist,mark6-02,12,MPHI%018,GLT_b2.12.filelist)
	$(call mk6dir2filelist,mark6-02,34,EHT%0033,GLT_b2.34.filelist)

gl_b3:
	$(call mk6dir2filelist,mark6-02,12,BHC%0087,GLT_b3.12.filelist)
	$(call mk6dir2filelist,mark6-02,34,BHC%0105,GLT_b3.34.filelist)

gl_b4:
	$(call mk6dir2filelist,mark6-02,12,BHC%0135,GLT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-02,34,BHC%0139,GLT_b4.34.filelist)

## JCMT
#
# https://eht-wiki.haystack.mit.edu/Event_Horizon_Telescope_Home/Observing/2023_April/JCMT_2023-04
# slot 1,2 = LCP, slot 3,4 = RCP

mm_b1:
	$(call mk6dir2filelist,mark6-05,12,MPI%6415,JCMT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-05,34,MPI%6417,JCMT_b1.34.filelist)

mm_b2:
	$(call mk6dir2filelist,mark6-05,12,BHC%0070,JCMT_b2.12.filelist)
	$(call mk6dir2filelist,mark6-05,34,BHC%0081,JCMT_b2.34.filelist)

mm_b3:
	$(call mk6dir2filelist,mark6-05,12,BHC%0050,JCMT_b3.12.filelist)
	$(call mk6dir2filelist,mark6-05,34,BHC%0052,JCMT_b3.34.filelist)

mm_b4:
	$(call mk6dir2filelist,mark6-05,12,MPI%6411,JCMT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-05,34,MPI%6413,JCMT_b4.34.filelist)

## Kitt Peak
#
# https://eht-wiki.haystack.mit.edu/Event_Horizon_Telescope_Home/Observing/2023_April/KP_2023-04
# slot 1,2 = LCP-V-0, slot 3,4 = RCP-H-1

kt_b1:
	$(call mk6dir2filelist,mark6-10,12,PERI%011,KT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-10,34,PERI%013,KT_b1.34.filelist)

kt_b2:
	$(call mk6dir2filelist,mark6-10,12,MPI%8005,KT_b2.12.filelist)
	$(call mk6dir2filelist,mark6-10,34,MPI%8033,KT_b2.34.filelist)

kt_b3:
	$(call mk6dir2filelist,mark6-10,12,ALMA%001,KT_b3.12.filelist)
	$(call mk6dir2filelist,mark6-10,34,ALMA%003,KT_b3.34.filelist)

kt_b4:
	$(call mk6dir2filelist,mark6-10,12,PERI%046,KT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-10,34,PERI%048,KT_b4.34.filelist)

## LMT
#
# https://eht-wiki.haystack.mit.edu/Event_Horizon_Telescope_Home/Observing/2023_April/LMT_2023-04
# recorder3 absent and no recordings in band3 (?)
# slot 1,2= L, slot 3,4 = R

lm_b1:
	$(call mk6dir2filelist,mark6-03,12,EHT%0053,LMT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-03,34,EHT%0055,LMT_b1.34.filelist)

lm_b2:
	$(call mk6dir2filelist,mark6-03,12,BHC%0128,LMT_b2.12.filelist)
	$(call mk6dir2filelist,mark6-03,34,BHC%0136,LMT_b2.34.filelist)

lm_b3:
	touch LMT_b3.12.filelist LMT_b3.34.filelist

lm_b4:
	$(call mk6dir2filelist,mark6-03,12,EHT%0049,LMT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-03,34,EHT%0051,LMT_b4.34.filelist)

## NOEMA
#
# https://eht-wiki.haystack.mit.edu/Event_Horizon_Telescope_Home/Observing/2023_April/NOEMA_2023-04
# https://eht-wiki.haystack.mit.edu/@api/deki/files/6739/=2022_pNOEMA_EHT_backend_freq_setup_230G.xlsx
# slot 1,2 = L, slot 3,4 = R

nn_b1:
	$(call mk6dir2filelist,mark6-07,1,MPI%6433,NOEMA_b1.1.filelist)
	$(call mk6dir2filelist,mark6-07,2,MPI%6428,NOEMA_b1.2.filelist)
	$(call mk6dir2filelist,mark6-07,3,MPI%6426,NOEMA_b1.3.filelist)
	$(call mk6dir2filelist,mark6-07,4,MPI%6445,NOEMA_b1.4.filelist)

nn_b2:
	$(call mk6dir2filelist,mark6-07,1,MPI%6446,NOEMA_b2.1.filelist)
	$(call mk6dir2filelist,mark6-07,2,MPI%6429,NOEMA_b2.2.filelist)
	$(call mk6dir2filelist,mark6-07,3,MPI%6430,NOEMA_b2.3.filelist)
	$(call mk6dir2filelist,mark6-07,4,MPI%6425,NOEMA_b2.4.filelist)

nn_b3:
	$(call mk6dir2filelist,mark6-07,1,MPI%6423,NOEMA_b3.1.filelist)
	$(call mk6dir2filelist,mark6-07,2,MPI%6431,NOEMA_b3.2.filelist)
	$(call mk6dir2filelist,mark6-07,3,MPI%6424,NOEMA_b3.3.filelist)
	$(call mk6dir2filelist,mark6-07,4,MPI%6441,NOEMA_b3.4.filelist)

nn_b4:
	$(call mk6dir2filelist,mark6-07,1,MPI%6442,NOEMA_b4.1.filelist)
	$(call mk6dir2filelist,mark6-07,2,MPI%6444,NOEMA_b4.2.filelist)
	$(call mk6dir2filelist,mark6-07,3,MPI%6427,NOEMA_b4.3.filelist)
	$(call mk6dir2filelist,mark6-07,4,MPI%6432,NOEMA_b4.4.filelist)

## Pico - did not observe EHT 2023

pv_b1:
	touch Pico_b1.12.filelist Pico_b1.34.filelist

pv_b2:
	touch Pico_b2.12.filelist Pico_b2.34.filelist

pv_b3:
	touch Pico_b3.12.filelist Pico_b3.34.filelist

pv_b4:
	touch Pico_b4.12.filelist Pico_b4.34.filelist

## SMA APHIDS - todo
#
# https://eht-wiki.haystack.mit.edu/Event_Horizon_Telescope_Home/Observing/2023_April/SMA_2023-04
# pol = ?

sw_b1:
	$(call mk6dir2filelist,mark6-08,12,BHC%0014,SMA_b1.12.filelist)
	$(call mk6dir2filelist,mark6-08,34,BHC%0028,SMA_b1.34.filelist)

sw_b2: # todo, not shipped yet (as of 03/2024)
	$(call mk6dir2filelist,mark6-08,12,MBHC%009,SMA_b2.12.filelist)
	$(call mk6dir2filelist,mark6-08,34,MBHC%011,SMA_b2.34.filelist)

sw_b3: # todo, not shipped yet (as of 03/2024)
	$(call mk6dir2filelist,mark6-08,12,MBHC%001,SMA_b3.12.filelist)
	$(call mk6dir2filelist,mark6-08,34,MBHC%003,SMA_b3.34.filelist)

sw_b4:
	$(call mk6dir2filelist,mark6-08,12,MPIH%031,SMA_b4.12.filelist)
	$(call mk6dir2filelist,mark6-08,34,MPIH%045,SMA_b4.34.filelist)

## SMT
#
# https://eht-wiki.haystack.mit.edu/Event_Horizon_Telescope_Home/Observing/2023_April/SMT_2023-04
# slot 1,2 = V-LCP, slot 3,4 = H-RCP

mg_b1:
	$(call mk6dir2filelist,mark6-04,12,PERI%035,SMT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-04,34,PERI%036,SMT_b1.34.filelist)

mg_b2:
	$(call mk6dir2filelist,mark6-04,12,PERI%028,SMT_b2.12.filelist)
	$(call mk6dir2filelist,mark6-04,34,MPI%8036,SMT_b2.34.filelist)

mg_b3:
	$(call mk6dir2filelist,mark6-04,12,PERI%033,SMT_b3.12.filelist)
	$(call mk6dir2filelist,mark6-04,34,PERI%038,SMT_b3.34.filelist)

mg_b4:
	$(call mk6dir2filelist,mark6-04,12,MPI%8037,SMT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-04,34,PERI%026,SMT_b4.34.filelist)

## SPT
#
# https://eht-wiki.haystack.mit.edu/Event_Horizon_Telescope_Home/Observing/2023_April/SPT_2023-04\
# slot 1,2 = LCP-V, slot 3,4 - RCP-H

sz_b1:
	$(call mk6dir2filelist,mark6-11,12,BHC%0060,SPT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-11,34,BHC%0061,SPT_b1.34.filelist)

sz_b2:
	$(call mk6dir2filelist,mark6-11,12,BHC%0095,SPT_b2.12.filelist)
	$(call mk6dir2filelist,mark6-11,34,BHC%0059,SPT_b2.34.filelist)

sz_b3:
	$(call mk6dir2filelist,mark6-11,12,BHC%0124,SPT_b3.12.filelist)
	$(call mk6dir2filelist,mark6-11,34,EHT%0075,SPT_b3.34.filelist)

sz_b4:
	$(call mk6dir2filelist,mark6-11,12,BHC%0104,SPT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-11,34,BHC%0103,SPT_b4.34.filelist)



## CHECKING

buglist:
	# List all entries/scans that have unexpected time stamps
	grep -v " 600" *.filelist || true
	grep " 51544." *.filelist || true


## COPY INTO DiFX DIRS

install:
	mkdir -p /Exps/$${exptname}/$(REV)/b1/
	mkdir -p /Exps/$${exptname}/$(REV)/b2/
	mkdir -p /Exps/$${exptname}/$(REV)/b3/
	mkdir -p /Exps/$${exptname}/$(REV)/b4/
	for exptname in $(TRACKS_ALL); do cp -av *_b1.* /Exps/$${exptname}/$(REV)/b1/ || true;	done
	for exptname in $(TRACKS_ALL); do cp -av *_b2.* /Exps/$${exptname}/$(REV)/b2/ || true;	done
	for exptname in $(TRACKS_ALL); do cp -av *_b3.* /Exps/$${exptname}/$(REV)/b3/ || true;	done
	for exptname in $(TRACKS_ALL); do cp -av *_b4.* /Exps/$${exptname}/$(REV)/b4/|| true;	done
