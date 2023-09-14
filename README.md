# eht2023_difx_templating

EHT 2023 VLBI DiFX correlation setups

Most tracks were observed at 230 GHz, the single track e23d15 at 345 GHz.

# TODO

Sort the band 1 and band 2 zoom/outputband definitions in increasing frequency order. For some reason difx2fits retains the exact order, and in the past EHT correlations, b1 b2 had FITS IFs in 
decreasing frequency order (matching v2d of that time), while b3 b4 had FITS IFs in increasing frequency order. The inconsistency is inconvenient for downstream (L1, L2) processing.

Make sure LMT axis_offset in VEX is 3.30 meters.

Request an a priori clock model for LMT from their staff. Initial inspection of GMVA Spring 2023 recordings of track C231B indicated a very high
drift of 4.5556e-9 sec/sec (r2dbevdifExtract1PPSOffset.py) but this produced no fringes.

Derive better Sgr A* coordinates.

Derive better SPT coordinates after correlation, if residuals with a priori SPT coordinates turn out to be too large.

