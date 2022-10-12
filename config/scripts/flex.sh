#!/bin/bash
i3-msg "workspace 4; exec kitty -e bash -c 'pipes.sh && bash'"
i3-msg "workspace 4; exec kitty -e bash -c 'fastfetch && bash'"
i3-msg "workspace 4; exec kitty -e bash -c 'btop && bash'"
i3-msg "workspace 4; exec kitty -e bash -c 'cmatrix && bash'"