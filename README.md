# eht2023_difx_templating

EHT 2023 VLBI DiFX correlation setups

Most tracks were observed at 230 GHz, the single track e23d15 at 345 GHz.

Channel definitions are now sorted in numerically increasing order in the DiFX v2d file.
This addresses feedback from EHT 2021 by the L1/CE group, 2021 b1 b2 had decreasing freq
order (and b3 b4 increasing order), and this lead to problems in postprocessing.

The VLBI Monitor database contains incorrect (truncated) reference pad name entries for NOEMA.
M. Bremer provided the pad info separately by email; tracks g17 e19 a22 pad N007, c16 c18 pad E003).

# TODO

Request an a priori clock model for LMT from their staff. Initial inspection of GMVA Spring 2023 recordings of track C231B indicated a very high
drift of 4.5556e-9 sec/sec (r2dbevdifExtract1PPSOffset.py), but this produced no fringes. Update 2024: perhaps lack of 86 GHz fringes
is due to a BDC that LMT realized a bit before DR2024 as being dead. TODO check EHT 2023 tracks for any LMT fringes...

Derive better Sgr A* coordinates.

Derive better SPT coordinates after correlation, if residuals with a priori SPT coordinates turn out to be too large.

ALMA LO offset 345G likely zero

