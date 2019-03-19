module Arithmetic
    include("C:/workspace/julia-projects/julia-project/ex1/arithmeticStack.jl")
end

function compileLine( sline, dstIo )
    if(startswith(sline,"push"))
        Arithmetic.push(sline, dstIo)
#binary arithmetic operations
    elseif(startswith(sline,"add"))
        Arithmetic.binaryOperator("+", dstIo)
    elseif(startswith(sline,"sub"))
        Arithmetic.binaryOperator("-", dstIo)
#binary bit-wise operations
    elseif(startswith(sline,"and"))
        Arithmetic.unaryOperator("&", dstIo)
    elseif(startswith(sline,"or"))
        Arithmetic.unaryOperator("|", dstIo)
#unary arithmetic operations
    elseif(startswith(sline,"neg"))
        Arithmetic.unaryOperator("-", dstIo)
#unary logic operations                
    elseif(startswith(sline,"not"))
        Arithmetic.unaryOperator("!", dstIo)
    end
end
