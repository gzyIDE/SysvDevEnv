#!/bin/tcsh

set top = `git rev-parse --show-toplevel`

cd ${top}
find -name .vim-verilog | xargs -I {} rm -rf {}
