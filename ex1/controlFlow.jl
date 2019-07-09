module Arithmetic
    include("arithmeticStack.jl")
end  # module Arithmetic


function label(labelName, dstIo,file)
    println(dstIo, "($labelName)")#"(fileName.x)" -in windows its "C:\\user\\..." in unix its "C/user/..."
end

function goTo(labelName,dstIo)
    println(dstIo,"@$labelName")#"@fileName.x" -in windows its "C:\\user\\..." in unix its "C/user/..."
    println(dstIo,"0;JMP")
end

#=
function goTo(labelName,dstIo,file)
    println(dstIo,"@$labelName")#"@fileName.x" -in windows its "C:\\user\\..." in unix its "C/user/..."
    println(dstIo,"0;JMP")
end
=#
function ifGoTo(labelName, dstIo)
    Arithmetic.decSp(dstIo)
    println( dstIo,"@SP")
    println( dstIo,"A = M")
    println( dstIo,"D = M")
    println( dstIo,"@$labelName")#"@fileName.x" -in windows its "C:\\user\\..." in unix its "C/user/..."
    println( dstIo,"D;JNE")
end
