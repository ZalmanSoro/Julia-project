module Compiler
    include("C:/workspace/julia-projects/julia-project/ex1/compiler.jl")
end
path = "C:/projects/ex1/StackArithmetic/StackTest/"
cd(path)
file = "StackTest.vm"
asmFile = replace(file,Pair(".vm",".asm"))

io = open(asmFile,"w")
foreach( line -> Compiler.compileLine( line, io ),readlines(file))
close(io)
