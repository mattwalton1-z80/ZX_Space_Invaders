
#!/bin/bash

base=$(basename "$1" .asm)

pasmo -v "$1" "$base.bin"
bin2tap -b -cb 7 -cp 7 -ci 0 "$base.bin"
