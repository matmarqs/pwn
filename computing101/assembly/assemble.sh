#!/bin/bash

as -o a.o "$1" && ld -o a.out a.o
