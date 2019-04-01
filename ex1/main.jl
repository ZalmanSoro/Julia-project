module Compiler
    include("compiler.jl")
end
#=
path = "C:\\Users\\AVI\\.atom\\julia-projects\\Julia-project\\ex1\\StackTest"
cd("StackArithmetic\\")
file = "StackTest.vm"
asmFile = replace(file,Pair(".vm",".asm"))

io = open(asmFile,"w")
foreach( line -> Compiler.compileLine( line, io ),readlines(file))
close(io)
=#
for (r,d,f) in walkdir(pwd())
    for file in f
        if endswith(file,".vm")
            asmFile = replace(file,Pair(".vm",".asm"))
            asmFile = joinpath(r,asmFile)
            file = joinpath(r,file)
            io = open(asmFile,"w")
            foreach( line -> Compiler.compileLine( line, io ),readlines(file))
            close(io)
        end
    end
end
