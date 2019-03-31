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
    if sagment == "constant"
        println( dstIo,"@$(cells[3])")
        println( dstIo,"D = A")
        println( dstIo,"@SP")#A=0
        println( dstIo,"A = M")#A=head(256....)
        println( dstIo,"M = D")#RAM[256....] = D
        incSp( dstIo
    elseif sagment == "local" # push local x
        println( destIo,"@$(cells[3])")
        println( destIo,"D=A")
        println( destIo,"@LCL")
        println( destIo,"A=M+D")#A = RAM[local] + x
        println( destIo,"D=M")#D = RAM[RAM[local] + x]
        println( destIo,"@SP")#A = SP
        println( destIo,"A=M")#A = RAM[SP]
        println( destIo,"M=D")#RAM[SP] = D
        incSp( destIo )
    elseif sagment == "argument" # push argument x
        println( destIo,"@$(cells[3])")
        println( destIo,"D=A")
        println( destIo,"@ARG")
        println( destIo,"A=M+D")#A = RAM[arguments] + x
        println( destIo,"D=M")#D = RAM[RAM[arguments] + x]
        println( destIo,"@SP")#A = SP
        println( destIo,"A=M")#A = RAM[SP]
        println( destIo,"M=D")#RAM[SP] = D
        incSp
    elseif sagment =="this" # push this x
        println( destIo,"@$(cells[3])")
        println( destIo,"D=A")
        println( destIo,"@THIS")
        println( destIo,"A=M+D")#A = RAM[this] + x
        println( destIo,"D=M")#D = RAM[RAM[this] + x]
        println( destIo,"@SP")#A = SP
        println( destIo,"A=M")#A = RAM[SP]
        println( destIo,"M=D")#RAM[SP] = D
        incSp( destIo )
    elseif sagment =="that" # push that x
        println( destIo,"@$(cells[3])")
        println( destIo,"D=A")
        println( destIo,"@THAT")
        println( destIo,"A=M+D")#A = RAM[that] + x
        println( destIo,"D=M")#D = RAM[RAM[that] + x]
        println( destIo,"@SP")#A = SP
        println( destIo,"A=M")#A = RAM[SP]
        println( destIo,"M=D")#RAM[SP] = D
        incSp( destIo )
    elseif sagment == "temp"
        #=
        if cells[3]>7 || cells[3]<0
            throw("invalid argument")
        =#
        println(destIo,"@$(cells[3]+5)")#A=5+x
        println(destIo,"D=M")#D=RAM[5+x]
        println(destIo,"@SP")#A=SP
        println(destIo ,"A=M")#A=RAM[SP]
        println(destIo,"M=D")#RAM[RAM[SP]]=D
        incSp(destIo)
    elseif sagment == "pointer" # push pointer x
        #=
        if !(cells[3] in [0,1])
            throw("this value must be 1 or 0")
        =#
        if cells[3] == 0
            println(destIo,"@THIS") #A= this
        else
            println(destIo,"@THAT")#A=that
        end
        println(destIo,"D=M")#D=RAM[this\that]
        println(destIo,"@SP")#A=SP
        println(destIo,"A=M")#A=RAM[SP]
        println(destIo,"M=D")#RAM[RAM[SP]]=D
        incSp(destIo)
    elseif sagment == "static" #push static x
        println(destIo,"@$(destIo.name[length("<file "):end-length(".asm>")]).$x")#"@fileName.x"
        println(des ,"D=M")
        println(destIo,"@SP")#A=SP
        println(destIo,"A=M")#A=RAM[SP]
        println(destIo,"M=D")#RAM[RAM[SP]]=D
        incSp(destIo)
    end
end

function pop( sline, dstIo)
    cells= split(sline," ")
    sagment = cells[2]
    if sagment == "local"
        decSp( destIo)
        println( destIo,"@SP")
        println( destIo,"A=M")
        println( destIo,"D=M")#D=RAM[SP]
        println( destIo,"@LCL")#A= local
        println( destIo,"A=M")#A = RAM[local]
        for i = 1:cells[3] # D contain the value, so the offset calculated withe loop
        println( destIo,"A=A+1")
        end
        println( destIo,"M=D")#RAM[ RAM[local] + x ] = D
    elseif sagment == "argument"
        decSp( destIo )
        println( destIo,"@SP")
        println( destIo,"A=M")
        println( destIo,"D=M")#D=RAM[SP]
        println( destIo,"@ARG")#A= arguments
        println( destIo,"A=M")#A = RAM[arguments]
        for i = 1:cells[3] # D contain the value, so the offset calculated withe loop
        println( destIo,"A=A+1")
        end
        println( destIo,"M=D")#RAM[ RAM[arguments] + x ] = D
    elseif sagment == "this"
        decSp( destIo )
        println( destIo,"@SP")
        println( destIo,"A=M")
        println( destIo,"D=M")#D=RAM[SP]
        println( destIo,"@THIS")#A= this
        println( destIo,"A=M")#A = RAM[this]
        for i = 1:cells[3] # D contain the value, so the offset calculated withe loop
            println( destIo,"A=A+1")
        end
        println( destIo,"M=D")#RAM[ RAM[this] + x ] = D
    elseif sagment == "that"
        decSp( destIo )
        println( destIo,"@SP")
        println( destIo,"A=M")
        println( destIo,"D=M")#D=RAM[SP]
        println( destIo,"@THAT")#A= that
        println( destIo,"A=M")#A = RAM[that]
        for i = 1:cells[3] # D contain the value, so the offset calculated withe loop
            println( destIo,"A=A+1")
        end
        println( destIo,"M=D")#RAM[ RAM[that] + x ] = D
    elseif sagment == "temp"
        #=
        if cells[3]>7 || cells[3]<0
            throw("invalid argument")
        =#
        decSp( destIo )
        println( destIo,"@SP")#A=SP
        println( destIo,"A=M")#A=RAM[SP]
        println( destIo,"D=M")#D=RAM[RAM[SP]]
        println( destIo,"@$(5+cells[3])")#temp is in address 5-12, A=5+x
        println( destIo,"M=D")#RAM[ 5 + x ] = D
    elseif sagment == "pointer" #pop pointer x
        #=
        if !(cells[3] in [0,1])
            throw("this value must be 1 or 0")
        =#
        decSp(destIo)
        println(destIo,"@SP")#A=SP
        println(destIo,"D=M")#A=RAM[SP]
        println(destIo,"D=M")#D=RAM[RAM[SP]]
        if cells[3] == 0
            println(destIo,"@THIS")
        else
            println(destIo,"@THAT")
        end
        print(destIo,"M=D")#RAM[this\that]=D
    elseif sagment == "static"# pop statsic x
        decSp(destIo)
        println(destIo,"@SP")
        println(destIo,"A=M")
        println(destIo,"D=M")
        println(destIo,"@$(destIo.name[length("<file "):end-length(".asm>")]).$x")#"@fileName.x"
        println(des ,"M=D")
    end

end
