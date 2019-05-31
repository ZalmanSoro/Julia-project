module flow
    include("controlFlow.jl")
end  # module controlFlow

module memory
    include("memoryAccess.jl")
end  # module memory

funcDic=Dict{String,Integer}() #dictionary for function name and the number of the call - to generate uniqe label to every call

function compileFunction(sline,dstIo)
    cells= split(sline," ")
    println(dstIo,"($(cells[2]))")
    num=parse(Int,cells[3])
    for i in 1:num
        memory.pushConstant([0,0,0],dstIo)
    end
end

function call(sline,dstIo)
    cells= split(sline," ")
    fname="$(cells[2])" #the full name of the function - FileName.FunctaionName
    try
        funcDic[fname]+=1 #if fincDic[fname] exist - add  1 to its value
    catch
        funcDic[fname]=1 #else make him with the value 1
    end
    returnAddressLabel="$fname.return-address.$(funcDic[fname])"
    memory.pushConstantString(returnAddressLabel,dstIo)
    memory.pushFromLable("LCL",dstIo)
    memory.pushFromLable("ARG",dstIo)
    memory.pushFromLable("THIS",dstIo)
    memory.pushFromLable("THAT",dstIo)
    #ARG=SP-n-5
    n=parse(Int64,cells[3])
    println(dstIo,"@SP")
    println(dstIo,"D=M")
    println(dstIo,"@$(n+5)")
    println(dstIo,"D=D-A")
    println(dstIo,"@ARG")
    println(dstIo,"M=D")
    #LCL=SP
    println(dstIo,"@SP")
    println(dstIo,"D=M")
    println(dstIo,"@LCL")
    println(dstIo,"M=D")
    flow.goTo(fname,dstIo)
    println(dstIo,"($(cells[2]).return-address.$(funcDic[fname]))")#functionName.return-address.numberOfCall
end

function restore(arg,dstIo)
    println(dstIo,"@LCL")
    println(dstIo,"M=M-1")
    println(dstIo,"A=M")
    println(dstIo,"D=M")
    println(dstIo,"@$arg")
    println(dstIo,"M=D")
end

function compileReturn(sline,dstIo)
    #save RAM[LCL]-5 in RAM[13]
    println(dstIo,"@LCL")
    println(dstIo,"D=M")
    println(dstIo,"@5")
    println(dstIo,"A=D-A")
    println(dstIo,"D=M")
    println(dstIo,"@13")
    println(dstIo,"M=D")
    #ARG=pop (the return value) - its the first memory cell of the function
    println(dstIo,"@SP")
    println(dstIo,"M=M-1")
    println(dstIo,"A=M")
    println(dstIo,"D=M")
    println(dstIo,"@ARG")
    println(dstIo,"A=M")
    println(dstIo,"M=D")
    #SP=ARG+1 - ARG is the return value and all the other need to delete, then move SP to the first unnecessary memory cell
    println(dstIo,"D=A")
    println(dstIo,"@SP")
    println(dstIo,"M=D+1")
    #restore THAT, THIS, ARG, LCL
    restore("THAT",dstIo)
    restore("THIS",dstIo)
    restore("ARG",dstIo)
    restore("LCL",dstIo)
    #go to return address (was in RAM[LCL]-5 and saved at RAM[13] )
    println(dstIo,"@13")
    println(dstIo,"A=M")
    println(dstIo,"0;JMP")
end
