module Arithmetic
    include("arithmeticStack.jl")
end

module memoryAccess
    include("memoryAccess.jl")
end

module Control
    include("controlFlow.jl")
end

module func
    include("function.jl")

end

function compileLine( sline, dstIo )
#memory access operations
    if(startswith(sline,"push"))
        memoryAccess.push(sline, dstIo)
    elseif(startswith(sline,"pop"))
        memoryAccess.pop(sline, dstIo)
#binary arithmetic operations
    elseif(startswith(sline,"add"))
        Arithmetic.binaryOperator("+", dstIo)
    elseif(startswith(sline,"sub"))
        Arithmetic.binaryOperator("-", dstIo)
#binary bit-wise operations
    elseif(startswith(sline,"and"))
        Arithmetic.binaryOperator("&", dstIo)
    elseif(startswith(sline,"or"))
        Arithmetic.binaryOperator("|", dstIo)
#unary arithmetic operations
    elseif(startswith(sline,"neg"))
        Arithmetic.unaryOperator("-", dstIo)
#unary logic operations
    elseif(startswith(sline,"not"))
        Arithmetic.unaryOperator("!", dstIo)
#binary logic operations
    elseif(startswith(sline,"eq"))
        Arithmetic.binaryLogicOperator("JEQ", dstIo)
#it looks upside down but it is right, beacuse the order of variables in stack
    elseif(startswith(sline,"gt"))
        Arithmetic.binaryLogicOperator("JLE", dstIo)
    elseif(startswith(sline,"lt"))
        Arithmetic.binaryLogicOperator("JGE", dstIo)
#control flow
    elseif(startswith(sline,"label"))
        cells = split(sline, " ")
        Control.label(cells[2], dstIo)
    elseif(startswith(sline,"if-goto"))
        cells = split(sline, " ")
        Control.ifGoTo(cells[2], dstIo)
    elseif(startswith(sline,"goto"))
        cells = split(sline, " ")
        Control.goTo(cells[2], dstIo)
#function
    elseif(startswith(sline,"call"))
        func.call(sline,dstIo)
    elseif(startswith(sline,"function"))
        func.compileFunction(sline,dstIo)
    elseif(startswith(sline,"return"))
        func.compileReturn(sline,dstIo)
    end
end
