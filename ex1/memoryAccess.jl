function incSp( dstIo )
    println( dstIo,"@SP")
    println( dstIo,"M = M + 1")
end

function decSp( dstIo )
    println( dstIo,"@SP")
    println( dstIo,"M = M - 1")
end


#       constant

function pushConstant(cells,destIo)
    println( destIo,"@$(cells[3])")
    println( destIo,"D = A")
    println( destIo,"@SP")#A=0
    println( destIo,"A = M")#A=head(256....)
    println( destIo,"M = D")#RAM[256....] = D
    incSp( destIo)
end

function pushFromLable(source,destIo)
    println( destIo,"@$source")
    println( destIo,"D = M")
    println( destIo,"@SP")#A=0
    println( destIo,"A = M")#A=head(256....)
    println( destIo,"M = D")#RAM[256....] = D
    incSp( destIo)

end

#       local

function pushLocal(cells,destIo)
    println( destIo,"@$(cells[3])")
    println( destIo,"D=A")
    println( destIo,"@LCL")
    println( destIo,"A=M+D")#A = RAM[local] + x
    println( destIo,"D=M")#D = RAM[RAM[local] + x]
    println( destIo,"@SP")#A = SP
    println( destIo,"A=M")#A = RAM[SP]
    println( destIo,"M=D")#RAM[SP] = D
    incSp( destIo )
end

function popLocal(cells,destIo)
    decSp( destIo)
    println( destIo,"@SP")
    println( destIo,"A=M")
    println( destIo,"D=M")#D=RAM[SP]
    println( destIo,"@LCL")#A= local
    println( destIo,"A=M")#A = RAM[local]
    for i = 1:parse(Int32,cells[3]) # D contain the value, so the offset calculated withe loop
    println( destIo,"A=A+1")
    end
    println( destIo,"M=D")#RAM[ RAM[local] + x ] = D
end



#       argument

function pushArgument(cells,destIo)
    println( destIo,"@$(cells[3])")
    println( destIo,"D=A")
    println( destIo,"@ARG")
    println( destIo,"A=M+D")#A = RAM[arguments] + x
    println( destIo,"D=M")#D = RAM[RAM[arguments] + x]
    println( destIo,"@SP")#A = SP
    println( destIo,"A=M")#A = RAM[SP]
    println( destIo,"M=D")#RAM[SP] = D
    incSp(destIo)
end

function popArgument(cells,destIo)
    decSp( destIo )
    println( destIo,"@SP")
    println( destIo,"A=M")
    println( destIo,"D=M")#D=RAM[SP]
    println( destIo,"@ARG")#A= arguments
    println( destIo,"A=M")#A = RAM[arguments]
    for i = 1:parse(Int32,cells[3]) # D contain the value, so the offset calculated withe loop
    println( destIo,"A=A+1")
    end
    println( destIo,"M=D")#RAM[ RAM[arguments] + x ] = D
end



#       this

function pushThis(cells,destIo)
    println( destIo,"@$(cells[3])")
    println( destIo,"D=A")
    println( destIo,"@THIS")
    println( destIo,"A=M+D")#A = RAM[this] + x
    println( destIo,"D=M")#D = RAM[RAM[this] + x]
    println( destIo,"@SP")#A = SP
    println( destIo,"A=M")#A = RAM[SP]
    println( destIo,"M=D")#RAM[SP] = D
    incSp( destIo )
end

function popThis(cells,destIo)
    decSp( destIo )
    println( destIo,"@SP")
    println( destIo,"A=M")
    println( destIo,"D=M")#D=RAM[SP]
    println( destIo,"@THIS")#A= this
    println( destIo,"A=M")#A = RAM[this]
    for i = 1:parse(Int32,cells[3]) # D contain the value, so the offset calculated withe loop
        println( destIo,"A=A+1")
    end
    println( destIo,"M=D")#RAM[ RAM[this] + x ] = D
end



#       that

function pushThat(cells,destIo)
    println( destIo,"@$(cells[3])")
    println( destIo,"D=A")
    println( destIo,"@THAT")
    println( destIo,"A=M+D")#A = RAM[that] + x
    println( destIo,"D=M")#D = RAM[RAM[that] + x]
    println( destIo,"@SP")#A = SP
    println( destIo,"A=M")#A = RAM[SP]
    println( destIo,"M=D")#RAM[SP] = D
    incSp( destIo )
end

function popThat(cells,destIo)
    decSp( destIo )
    println( destIo,"@SP")
    println( destIo,"A=M")
    println( destIo,"D=M")#D=RAM[SP]
    println( destIo,"@THAT")#A= that
    println( destIo,"A=M")#A = RAM[that]
    for i = 1:parse(Int32,cells[3]) # D contain the value, so the offset calculated withe loop
        println( destIo,"A=A+1")
    end
    println( destIo,"M=D")#RAM[ RAM[that] + x ] = D
end



#       temp

function pushTemp(cells,destIo)
    #=
    if cells[3]>7 || cells[3]<0
        throw("invalid argument")
    =#
    println(destIo,"@$(parse(Int32,cells[3])+5)")#A=5+x
    println(destIo,"D=M")#D=RAM[5+x]
    println(destIo,"@SP")#A=SP
    println(destIo ,"A=M")#A=RAM[SP]
    println(destIo,"M=D")#RAM[RAM[SP]]=D
    incSp(destIo)
end

function popTemp(cells,destIo)
    #=
    if cells[3]>7 || cells[3]<0
        throw("invalid argument")
    =#
    decSp( destIo )
    println( destIo,"@SP")#A=SP
    println( destIo,"A=M")#A=RAM[SP]
    println( destIo,"D=M")#D=RAM[RAM[SP]]
    println( destIo,"@$(5 + parse(Int32,cells[3]))")#temp is in address 5-12, A=5+x
    println( destIo,"M=D")#RAM[ 5 + x ] = D
end



#       pointer

function pushPointer(cells,destIo)
    #=
    if !(cells[3] in [0,1])
        throw("this value must be 1 or 0")
    =#
    if cells[3] == "0"
        println(destIo,"@THIS") #A= this
    else
        println(destIo,"@THAT")#A=that
    end
    println(destIo,"D=M")#D=RAM[this\that]
    println(destIo,"@SP")#A=SP
    println(destIo,"A=M")#A=RAM[SP]
    println(destIo,"M=D")#RAM[RAM[SP]]=D
    incSp(destIo)
end

function popPointer(cells,destIo)
    #=
    if !(cells[3] in [0,1])
        throw("this value must be 1 or 0")
    =#
    decSp(destIo)
    println(destIo,"@SP")#A=SP
    println(destIo,"A=M")#A=RAM[SP]
    println(destIo,"D=M")#D=RAM[RAM[SP]]
    if cells[3] == "0"
        println(destIo,"@THIS")
    else
        println(destIo,"@THAT")
    end
    println(destIo,"M=D")#RAM[this\that]=D
end



#       static

function pushStatic(cells,destIo)
    # the name of the stream is the full path,
    #so the program take the the sub string from the last '\' +1 (its return the index of the last '\' and we dont whont him)
    #and remove from the end of the string ".asm" then add the number of the local static (a.k.a cells[3])
    println(destIo,"@$(destIo.name[findlast(x->x=='\\'||x=='/',destIo.name)+1:end-length(".asm>")]).$(cells[3])")#"@fileName.x" -in windows its "C:\\user\\..." in unix its "C/user/..."
    println(destIo ,"D=M")
    println(destIo,"@SP")#A=SP
    println(destIo,"A=M")#A=RAM[SP]
    println(destIo,"M=D")#RAM[RAM[SP]]=D
    incSp(destIo)
end

function popStatic(cells,destIo)
    decSp(destIo)
    println(destIo,"@SP")
    println(destIo,"A=M")
    println(destIo,"D=M")
    # the name of the stream is the full path,
    #so the program take the the sub string from the last '\' +1 (its return the index of the last '\' and we dont whont him)
    #and remove from the end of the string ".asm" then add the number of the local static (a.k.a cells[3])
    println(destIo,"@$(destIo.name[findlast(x->x=='\\'||x=='/',destIo.name)+1:end-length(".asm>")]).$(cells[3])")#"@fileName.x" -in windows its "C:\\user\\..." in unix its "C/user/..."
    println(destIo ,"M=D")
end



function push( sline, destIo )
    cells = split(sline," ")
    sagment = cells[2]
    if sagment == "constant"
        pushConstant(cells,destIo)
    elseif sagment == "local" # push local x
        pushLocal(cells,destIo)
    elseif sagment == "argument" # push argument x
        pushArgument(cells,destIo)
    elseif sagment =="this" # push this x
        pushThis(cells,destIo)
    elseif sagment =="that" # push that x
        pushThat(cells,destIo)
    elseif sagment == "temp"
        pushTemp(cells,destIo)
    elseif sagment == "pointer" # push pointer x
        pushPointer(cells,destIo)
    elseif sagment == "static" #push static x
        pushStatic(cells,destIo)
    end
end

function pop( sline, destIo)
    cells= split(sline," ")
    sagment = cells[2]
    if sagment == "local"
        popLocal(cells,destIo)
    elseif sagment == "argument"
        popArgument(cells,destIo)
    elseif sagment == "this"
        popThis(cells,destIo)
    elseif sagment == "that"
        popThat(cells,destIo)
    elseif sagment == "temp"
        popTemp(cells,destIo)
    elseif sagment == "pointer" #pop pointer x
        popPointer(cells,destIo)
    elseif sagment == "static"# pop statsic x
        popStatic(cells,destIo)
    end

end
