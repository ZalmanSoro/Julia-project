
function incSp()
    println( dstIo,"@SP")
    println( dstIo,"M = M + 1")
end

function decSp()
    println( dstIo,"@SP")
    println( dstIo,"M = M - 1")
end

function push(sline)
    cells = split(sline," ")
    sagment = cells[2]
    if(sagment == "constant")
        println( dstIo,"@$(cells[3])")
        println( dstIo,"D = A")
        println( dstIo,"@SP")
        println( dstIo,"A = M")
        println( dstIo,"M = D")
        incSp()
    end
end

function add()
    println( dstIo,"@SP")
    println( dstIo,"A = M")
    println( dstIo,"D = M")
    decSp()
    decSp()
    println( dstIo,"A = M")
    println( dstIo,"M = M + D")
    incSp()
end

function compileLine(sline)
    if(startswith(sline,"push"))
        push(sline)
    elseif(startswith(sline,"add"))
        add()
    end
end

path = "C:/projects/ex1/StackArithmetic/SimpleAdd/"
cd(path)
file = "SimpleAdd.vm"
asmFile = replace(file,Pair(".vm",".asm"))

dstIo = open(asmFile,"w")
foreach(compileLine,readlines(file))
close(dstIo)
