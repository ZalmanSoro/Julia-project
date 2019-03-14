module Arithmetic
    include("C:/workspace/julia-projects/julia-project/ex1/arithmeticStack.jl")
end
path = "C:/projects/ex1/StackArithmetic/SimpleAdd/"
cd(path)
file = "SimpleAdd.vm"
asmFile = replace(file,Pair(".vm",".asm"))

io = open(asmFile,"w")
foreach( line -> Arithmetic.compileLine( line, io ),readlines(file))
close(io)
