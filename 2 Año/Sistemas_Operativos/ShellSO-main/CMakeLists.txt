cmake_minimum_required(VERSION 3.20)
project(ShellSO C)

set(CMAKE_C_STANDARD 99)

add_executable(ShellSO main.c list.h list.c)