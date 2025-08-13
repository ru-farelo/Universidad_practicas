cmake_minimum_required(VERSION 3.16)
project(Paralelismo)
set(CMAKE_C_STANDARD)

find_package(MPI REQUIRED)
include_directories(paralelismo-cp)




add_executable(cuentaletras
        cuentaletras.c)