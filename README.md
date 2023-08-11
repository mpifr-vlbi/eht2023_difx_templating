# eht2023_difx_templating

EHT 2023 VLBI DiFX correlation setups

Most tracks were observed at 230 GHz, the single track e23d15 at 345 GHz.

# TODO

Sort the band 1 and band 2 zoom/outputband definitions in increasing frequency order. For some reason difx2fits retains the exact order, and in the past EHT correlations, b1 b2 had FITS IFs in 
decreasing frequency order (matching v2d of that time), while b3 b4 had FITS IFs in increasing frequency order. The inconsistency is inconvenient for downstream (L1, L2) processing.
