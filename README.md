# Detronyx Arithmetic Lab Tile

TinyTapeout GF project that groups the public byte adder, combinational 8x8
multiplier, and reciprocal-ROM divider behind a tiny register-loaded test
wrapper with four A/B task slots.

- Reusable cores: `src/detronyx_add8_sparse_core.sv`,
  `src/detronyx_umul8_comb.sv`, and
  `src/detronyx_recip8_div8_core.sv`
- TT adapter: `src/project.v`
- `ui_in[7:0]`: data byte
- `uio_in[2:0]`: command inputs: write A, write B, set mode, select bank, set config
- `uio_out[7:3]`: bank, mode, and mode-specific status output
- `uo_out[7:0]`: selected result

The project is configured for GF180MCU 3.3 V `gf180mcu_as_sc_mcu7t3v3`
hardening with the local project SDC in `src/constraints.sdc`. KLayout DRC is
enabled with a generated standalone GF180 5LM runset in
`src/klayout_drc/gf180mcu_5lm_full.drc`. The checker is currently non-gating
because the official GF180 KLayout deck reports `CO.6a` hits inside the
standard cell `gf180mcu_as_sc_mcu7t3v3__aoi211_2`; Magic DRC remains clean.
The current local post-route timing point is 50 MHz with margin; 62.5 MHz is
also clean, while 64.1 MHz is a measured boundary point with very small setup
margin.

See [docs/info.md](docs/info.md) for command and mode details.
