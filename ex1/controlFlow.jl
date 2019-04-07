module Arithmetic
    include("arithmeticStack.jl")
end  # module Arithmetic


function label(labelName, dstIo)
    println(dstIo, "($labelName)")
end

function ifGoTo(labelName, dstIo)
    Arithmetic.decSp(dstIo)
    println( dstIo,"@SP")
    println( dstIo,"A = M")
    println( dstIo,"D = M")
    println( dstIo,"@$labelName")
    println( dstIo,"D;JGT")
end
