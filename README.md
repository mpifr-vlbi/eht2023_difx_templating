# eht2023_difx_templating

Correlation setup for EHT 2023 VLBI under DiFX 2.7.1/2.8.1

All tracks were observed at 230 GHz except for the 345 GHz track e23d15.

Channel definitions are now sorted in numerically increasing order in the DiFX v2d file.
This addresses feedback from EHT 2021 by the L1/CE group, 2021 b1 b2 had decreasing freq
order (and b3 b4 increasing order), and this lead to problems in postprocessing.

The VLBI Monitor database contains incorrect (truncated) reference pad name entries for NOEMA.
M. Bremer provided the pad info separately by email; tracks g17 e19 a22 pad N007, c16 c18 pad E003).

Coordinates for Sgr A* by V. Fish using position and proper motion from 2022ApJ...940...15X for J2000
epoch 2023.29 are 17 45 40.032073 -29 00 28.26098. Results look good with that.

Tracks e23g17 and e23a22 had single-station scans scheduled at ALMA and or SMA.
These scans were recorded at ALMA/SMA but have no baselines. This cause issues in the CASA pipeline.
The problematic scans are thus commented out in the DiFX correlation setup.

The SMT 345G receiver is not sideband reparating; LSB folds onto USB (b2+b3, b1+b4).
According to Slack #smt_backend on 12 April 2023, b1 b2 Mark6 recorders had no IF signal.
A. Lowitz confirmed that the 345G "USB" IF was routed to the b3 b4 Mark6 recorders.
The setup was identical to EHT 2021 and the standard EHT tuning was used.
The b3 modules ought to contain a folded b2 & b3, and b4 modules a folded b1 & b4.
There are SMT b1 and b4 fringes (esp. 105-1223 Aa-Mg SNR~20) when using the b4 Mark6 data.
There ough to be b2 b3 fringes in the same scan when using b3 Mark6 data.

The GLT 345G observations were at very low elevation, with weak fringes in 105-0837 Gl-Mm SNR~10.

# Correlation Environment

Use DiFX-2.8.1 or DiFX-2.7.1. Apply a small local patch `./patches/difx-271-jobsplit-patch.svndiff`
or `./patches/difx-281-jobsplit-patch.svndiff`. The patch fixes a shortcoming in DiFX job
creation for sub-arrayed tracks (e23d15 e23c16 e23c18) where certain simultaneously observed
scans get split unnecessarily into 2-3 correlation jobs per scan. While fine for FITS-IDI,
Mk4 takes only the 1st data part of split scans. The patch avoids creating scan splits. See https://github.com/difx/difx/pull/67/

Use CALC 11 rather than the old default CALC 9.1 model by, e.g.,
```
$ calcifMixed --calc=difxcalc *.calc
$ startdifx --dont-calc *.input
```
ALMA migrated from CALC 9.1 (DiFX calcif2) to CALC 11 (DiFX difxcalc). They use the CALC
model to pre-correct for local atmosphere. These corrections are in a sense baked into
the ALMA phased-sum VDIF recordings. To avoid a double correction and not over/undercompensate
by inadvertently having the wrong default model version, use explicit `calcifMixed --calc=difxcalc`.

Ocean loading and pole tide coefficients for CALC 11 for EHT stations are already
part of DiFX-2.8.1 difxcalc. For DiFX-2.7.1 the respective coeff files need to be copied over from 2.8.1.

# Stations and tracks

```
Track   Freq  HOPS  Stations
e23d15  345G  3848   7-st Aa Ax Gl Mg Mm Nn Sw
e23c16  230G  3849  10-st Aa Ax Gl Kt Lm Mg Mm Nn Sw Sz
e23g17  230G  3850  10-st Aa Ax Gl Kt Lm Mg[Mm]Nn Sw Sz
e23c18  230G  3851  9-st Aa Ax Gl Kt Mg Mm Nn Sz Sw
e23e19  230G  3852  8-st Aa Ax Gl Kt Lm Mg Mm Nn
e23a22  230G  3853  9-st Aa Ax Gl Kt Mg Mm Nn Sw [Sz]

Notes
Kt : H-maser stability lost in c18 e19 a22
Lm : free-running crystal reference in all tracks
Mm : absent in g17 because of Mauna Kea power grid issues
Sz : observed c16 c18 but not a22
Aa, Sw : scheduled as single station in several scans, with data recording - removed for correlation
```

# Grievances

ALMA had different tunings from EHT 2021: ~21 MHz offset, yields finally an exact 1st LO tuning
with 0 Hz LO offset. The info was found in a semi hardware level trace in e23d15-script.log.gz
in a tarball nested within tarballs of the ALMA VLBI Metadata tarball.

SMA recordings in 260G e23d15 b4 are present but corrupt - all data are 0x00. Didn't observe that band.

# TODO

Derive better SPT coordinates, if residuals with a priori SPT coordinates turn out to be too large? Looks ok so far?

Cygnus A coordinates (track e23e19) are slightly off - need better ones
