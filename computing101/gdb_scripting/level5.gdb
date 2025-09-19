run
set disassembly-flavor intel
break *main+721
continue
commands
    silent
    set $buffer = *(unsigned long long *)($rbp-0x18)
    printf "Current value: %llx\n", $buffer
    continue
end
continue

