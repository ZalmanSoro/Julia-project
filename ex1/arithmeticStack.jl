function incSp( dstIo )
    println( dstIo,"@SP")
    println( dstIo,"M = M + 1")
end

function decSp( dstIo )
    println( dstIo,"@SP")
    println( dstIo,"M = M - 1")
end

function push( sline, dstIo )
    cells = split(sline," ")
    sagment = cells[2]
    if(sagment == "constant")
        println( dstIo,"@$(cells[3])")
        println( dstIo,"D = A")
        println( dstIo,"@SP")
        println( dstIo,"A = M")
        println( dstIo,"M = D")
        incSp( dstIo )
    end
end

function binaryOperator( operator, dstIo )
    decSp( dstIo )
    println( dstIo,"@SP")
    println( dstIo,"A = M")
    println( dstIo,"D = M")
    decSp( dstIo )
    println( dstIo,"A = M")
    println( dstIo,"M = M $operator D")
    incSp( dstIo )
end

function unaryOperator( operator, dstIo )
    println( dstIo,"@SP")
    println( dstIo,"A = M")
    println( dstIo,"M = $operator M")
end
