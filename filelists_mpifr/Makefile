## Get global settings; TRACKS (e23...), REV (FRINGE), REL (0), SITE (mpifr), EXPROOT (/Exps)
include ../Makefile.inc

M6DIRS := /cluster/difx/directories/

all:
	@echo "Options:  'make bonn'  or  'make hays'"

mk6dir2filelist = grep "^e23" $(M6DIRS)/$(3).filelist | sort -k 2 | sed -e 's/^/\/$(1)_fuse\/$(2)\//' | cut -d' ' -f 1,2,3 > $(4)

bonn: aa_b1 aa_b4 ax_b1 ax_b4 gl_b1 gl_b4 mm_b1 mm_b4 mg_b1 mg_b4 \
	kt_b1 kt_b4 lm_b1 lm_b4 nn_b1 nn_b4 sw_b1 sw_b4 sz_b1 sz_b4

hays: pv_b2 pv_b3

## ALMA

aa_b1:
	$(call mk6dir2filelist,mark6-10,12,SAO%0025,ALMA_b1.12.filelist)
	$(call mk6dir2filelist,mark6-10,34,SAO%0027,ALMA_b1.34.filelist)

aa_b4:
	$(call mk6dir2filelist,mark6-10,12,SAO%0040,ALMA_b4.12.filelist)
	$(call mk6dir2filelist,mark6-10,34,SAO%0031,ALMA_b4.34.filelist)

## APEX - todo

ax_b1: # todo, not shipped yet (as of 09/2023)
	#$(call mk6dir2filelist,mark6-10,12,EHT%1248,APEX_b1.12.filelist)
	#$(call mk6dir2filelist,mark6-09,34,EHT%1249,APEX_b1.34.filelist)

ax_b4: # todo, not shipped yet (as of 09/2023)
	#$(call mk6dir2filelist,mark6-10,12,MPI%6400,APEX_b4.12.set1.filelist)
	#$(call mk6dir2filelist,mark6-10,12,MPI%6418,APEX_b4.12.set2.filelist)
	#$(call mk6dir2filelist,mark6-09,34,EHT%1246,APEX_b4.34.filelist)
	#cat APEX_b4.12.set1.filelist APEX_b4.12.set2.filelist > APEX_b4.12.filelist

## GLT

gl_b1:
	$(call mk6dir2filelist,mark6-06,12,BHC%0045,GLT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-06,34,BHC%0065,GLT_b1.34.filelist)

gl_b4:
	$(call mk6dir2filelist,mark6-06,12,BHC%0135,GLT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-06,34,BHC%0139,GLT_b4.34.filelist)

## JCMT

mm_b1:
	$(call mk6dir2filelist,mark6-11,12,MPI%6415,JCMT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-11,34,MPI%6417,JCMT_b1.34.filelist)

mm_b4:
	$(call mk6dir2filelist,mark6-08,12,MPI%6411,JCMT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-08,34,MPI%6413,JCMT_b4.34.filelist)

## Kitt Peak

kt_b1:
	$(call mk6dir2filelist,mark6-02,12,PERI%011,KT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-02,34,PERI%013,KT_b1.34.filelist)

kt_b4:
	$(call mk6dir2filelist,mark6-02,12,PERI%046,KT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-02,34,PERI%048,KT_b4.34.filelist)

## LMT

lm_b1:
	$(call mk6dir2filelist,mark6-07,12,EHT%0049,LMT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-07,34,EHT%0055,LMT_b1.34.filelist)

lm_b4:
	$(call mk6dir2filelist,mark6-07,12,EHT%0053,LMT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-07,34,EHT%0051,LMT_b4.34.filelist)

## NOEMA
	
nn_b1:
	$(call mk6dir2filelist,mark6-09,1,MPI%6443,NOEMA_b1.1.filelist)
	$(call mk6dir2filelist,mark6-09,2,MPI%6428,NOEMA_b1.2.filelist)
	$(call mk6dir2filelist,mark6-09,3,MPI%6426,NOEMA_b1.3.filelist)
	$(call mk6dir2filelist,mark6-09,4,MPI%6445,NOEMA_b1.4.filelist)

nn_b4:
	$(call mk6dir2filelist,mark6-09,1,MPI%6442,NOEMA_b4.1.filelist)
	$(call mk6dir2filelist,mark6-09,2,MPI%6444,NOEMA_b4.2.filelist)
	$(call mk6dir2filelist,mark6-09,3,MPI%6427,NOEMA_b4.3.filelist)
	$(call mk6dir2filelist,mark6-09,4,MPI%6432,NOEMA_b4.4.filelist)

## Pico - did not observe EHT 2023

#pv_b1:
#	$(call mk6dir2filelist,mark6-05,12,EHT%0076,Pico_b1.12.filelist)
#	$(call mk6dir2filelist,mark6-05,34,EHT%0082,Pico_b1.34.filelist)

#pv_b4:
#	$(call mk6dir2filelist,mark6-05,12,EHT%0092,Pico_b4.12.filelist)
#	$(call mk6dir2filelist,mark6-05,34,EHT%0098,Pico_b4.34.filelist)

## SMA APHIDS - todo

sw_b1: # todo, not shipped yet (as of 09/2023)
	$(call mk6dir2filelist,mark6-05,12,PERI%039,SMA_b1.12.filelist)
	$(call mk6dir2filelist,mark6-05,34,PERI%041,SMA_b1.34.filelist)

sw_b4: # todo, not shipped yet (as of 09/2023)
	$(call mk6dir2filelist,mark6-05,12,BHC%0106,SMA_b4.12.filelist)
	$(call mk6dir2filelist,mark6-05,34,BHC%0108,SMA_b4.34.filelist)

## SMT

mg_b1:
	$(call mk6dir2filelist,mark6-04,12,PERI%035,SMT_b1.12.filelist)
	$(call mk6dir2filelist,mark6-04,34,PERI%036,SMT_b1.34.filelist)

mg_b4:
	$(call mk6dir2filelist,mark6-04,12,MPI%8037,SMT_b4.12.filelist)
	$(call mk6dir2filelist,mark6-04,34,PERI%026,SMT_b4.34.filelist)

## SPT - todo

sz_b1: # todo, not shipped yet (as of 09/2023)
	#$(call mk6dir2filelist,mark6-04,12,EHT%0078,SPT_b1.12.filelist)
	#$(call mk6dir2filelist,mark6-04,34,EHT%0080,SPT_b1.34.filelist)

sz_b4: # todo, not shipped yet (as of 09/2023)
	#$(call mk6dir2filelist,mark6-04,12,SHAO%049,SPT_b4.34.filelist)
	#$(call mk6dir2filelist,mark6-04,34,SHAO%016,SPT_b4.12.filelist)


## CHECKING

buglist:
	# All scans that have unexpected time stamps
	grep -v " 600" *.filelist || true
	grep " 51544." *.filelist || true


## COPY

install:
	#for exptname in $(TRACKS); do \
	#	mkdir -p /Exps/$${exptname}/$(REV)/b1/ /Exps/$${exptname}/$(REV)/b1_outputbands/ ; \
	#	mkdir -p /Exps/$${exptname}/$(REV)/b4/ /Exps/$${exptname}/$(REV)/b4_outputbands/ ; \
	#done
	#for exptname in $(TRACKS); do \
	#	cp -a *_b1.* /Exps/$${exptname}/$(REV)/b1/ ;				\
	#	cp -a *_b1.* /Exps/$${exptname}/$(REV)/b1_outputbands/ ;	\
	#	cp -a *_b4.* /Exps/$${exptname}/$(REV)/b4/ ;				\
	#	cp -a *_b4.* /Exps/$${exptname}/$(REV)/b4_outputbands/;		\
	#done
	for exptname in $(TRACKS); do \
		cp -a *_b1.* /Exps/$${exptname}/$(REV)/b1_outputbands/ ;	\
		cp -a *_b4.* /Exps/$${exptname}/$(REV)/b4_outputbands/;		\
	done

