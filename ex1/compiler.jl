module Arithmetic
    include("C:/workspace/julia-projects/julia-project/ex1/arithmeticStack.jl")
end

function compileLine( sline, dstIo )
    if(startswith(sline,"push"))
        Arithmetic.push(sline, dstIo)
    elseif(startswith(sline,"add"))
        Arithmetic.binaryOperator("+", dstIo)
    elseif(startswith(sline,"sub"))
        Arithmetic.binaryOperator("-", dstIo)
    elseif(startswith(sline,"neg"))
        Arithmetic.unaryOperator("-", dstIo)
    end
end
