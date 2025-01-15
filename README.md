# eht2023_difx_templating

EHT 2023 VLBI DiFX correlation setups

All tracks were observed at 230 GHz except for the 345 GHz track e23d15.

Channel definitions are now sorted in numerically increasing order in the DiFX v2d file.
This addresses feedback from EHT 2021 by the L1/CE group, 2021 b1 b2 had decreasing freq
order (and b3 b4 increasing order), and this lead to problems in postprocessing.

The VLBI Monitor database contains incorrect (truncated) reference pad name entries for NOEMA.
M. Bremer provided the pad info separately by email; tracks g17 e19 a22 pad N007, c16 c18 pad E003).

Coordinates for Sgr A* by V. Fish using position and proper motion from 2022ApJ...940...15X for J2000 epoch 2023.29 are 17 45 40.032073   -29 00 28.26098.

Tracks e23g17 and e23a22 have a few scans that were scheduled for ALMA only with no other stations.
Although the scans were recorded on ALMA Mark6, they have no baselines, leading to issues under CASA.
Thus the problematic ALMA-only scans are commented out in the DiFX correlation setup.

The SMT 345G receiver is not sideband reparating; LSB folds onto USB.
According to Slack #smt_backend on 12 April 2023, b1 b2 Mark6 recorders had no IF signal.
A. Lowitz confirmed that the 345G "USB" IF was routed to b3 b4 Mark6 recorders.
The setup was identical to EHT 2021 and the standard EHT tuning was used.
The b3 modules ought to contain a folded b2 & b3, and b4 modules a folded b1 & b4.
Yet so far there are no SMT 345G fringes in b1 nor b4.

# TODO

Derive better SPT coordinates after correlation, if residuals with a priori SPT coordinates turn out to be too large.

ALMA LO offset 345G likely zero? Or like 2021 after all?

Reason for no SMT 345G fringes?

# Stations and tracks

```
e23d15 345G  7-st Aa Ax Gl Mg Mm Nn Sw
e23c16 230G 10-st Aa Ax Gl Kt Lm Mg Mm Nn Sw Sz
e23g17 230G 10-st Aa Ax Gl Kt Lm Mg Mm Nn Sw Sz
e23c18 230G  9-st Aa Ax Gl Kt Mg Mm Nn Sz Sw
e23e19 230G  8-st Aa Ax Gl Kt Lm Mg Mm Nn
e23a22 230G  9-st Aa Ax Gl Kt Mg Mm Nn Sw Sz
Lm : free-running crystal reference in all tracks
Kt : H-maser stability lost in c18 e19 a22
```
