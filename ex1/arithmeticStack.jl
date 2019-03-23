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
        println( dstIo,"@SP")#A=0
        println( dstIo,"A = M")#A=head(256....)
        println( dstIo,"M = D")#RAM[256....] = D
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
    decSp( dstIo )
    println( dstIo,"@SP")
    println( dstIo,"A = M")
    println( dstIo,"M = $operator M")
    incSp( dstIo )
end

function binaryLogicOperator( operator, dstIo )
    decSp( dstIo )
    println( dstIo,"@SP")
    println( dstIo,"A = M")
    println( dstIo,"D = M")# D has head
    decSp( dstIo )
    println( dstIo,"A = M")
    println( dstIo,"D = D - M")# d is 0 if equal
    pos = position(dstIo) #position number, to keep label identity
    ifLable = "IF_$pos"
    println( dstIo, "@$ifLable" )
    println( dstIo, "D;$operator" )
    println( dstIo, "D = 0") #the else statment
    println( dstIo,"@SP")
    println( dstIo,"A = M")
    println( dstIo,"M = D")# end of else statment
    pos = position(dstIo) #position number, to keep label identity
    elseLable = "ELSE_$pos"
    println( dstIo, "@$elseLable" )
    println( dstIo, "0;JMP" )
    println( dstIo, "($ifLable)" )
    println( dstIo, "D = -1") #the if statment
    println( dstIo,"@SP")
    println( dstIo,"A = M")
    println( dstIo,"M = D")# end of if statment
    println( dstIo, "($elseLable)" )
    incSp( dstIo )
end
