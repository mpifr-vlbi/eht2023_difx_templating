# eht2023_difx_templating

EHT 2023 VLBI DiFX correlation setups

Most tracks were observed at 230 GHz, the single track e23d15 at 345 GHz.

Channel definitions are now sorted in numerically increasing order in the DiFX v2d file.
This addresses feedback from EHT 2021 by the L1/CE group, 2021 b1 b2 had decreasing freq
order (and b3 b4 increasing order), and this lead to problems in postprocessing.

The VLBI Monitor database contains incorrect (truncated) reference pad name entries for NOEMA.
M. Bremer provided the pad info separately by email; tracks g17 e19 a22 pad N007, c16 c18 pad E003).

Coordinates for Sgr A* by V. Fish using position and proper motion from 2022ApJ...940...15X for J2000 epoch 2023.29 are 17 45 40.032073   -29 00 28.26098.

Tracks e23g17 and e23a22 have a few scans that were scheduled for ALMA only with no other stations.
Although the scans were recorded on ALMA Mark6, they have no baselines, leading to issues under CASA.
Thus the problematic ALMA-only scans are commented out in the DiFX correlation setup.

# TODO

Use v2d deltaClockAccel for LMT to improve on the non-linear residual fringe rates due to their drifting non-disciplined 10 MHz standard.

Derive better SPT coordinates after correlation, if residuals with a priori SPT coordinates turn out to be too large.

ALMA LO offset 345G likely zero? Or like 2021 after all?
