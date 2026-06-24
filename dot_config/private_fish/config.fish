function fastfetch
    if status is-interactive
        kitty +kitten icat --align left --place 50x10@0x0 /home/diefals/.config/fish/current_photo.jpg
        sleep 0.1
        command fastfetch --logo none --structure OS:Kernel:Shell:Terminal:CPU:GPU:Memory:WM:Disk | sed 's/^/                          /'
        echo
    else
        command fastfetch $argv
    end
end
