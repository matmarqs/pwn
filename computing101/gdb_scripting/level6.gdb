set disassembly-flavor intel
run < infile
break *main+686
commands
    silent
    set $rdx = $rax
    continue
end
continue
