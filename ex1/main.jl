#=
    zalman sorotzkin 200789345
    avraham ben-yakar 204729388
    team 150060.01.5779.50
=#

module Compiler
    include("compiler.jl")
end

path = match(r".*Julia-project",@__DIR__).match
for (r,d,f) in walkdir(joinpath(path,"Tests"))
    len= length(filter(i -> endswith(i,".vm"),f))
    if len>1
        asmFile="$(r[findlast(x->x=='\\'||x=='/',r)+1:end]).asm"
        asmFile = joinpath(r,asmFile)
        io = open(asmFile,"w")
        println(io,"@256")
        println(io,"D=A")
        println(io,"@SP")
        println(io,"M=D")
        Compiler.compileLine("call Sys.init 0",io)
        for file in f
            if endswith(file,".vm")
                #asmFile = replace(file,Pair(".vm",".asm"))
                file = joinpath(r,file)
                foreach( line -> Compiler.compileLine( line, io ),readlines(file))
            end
        end
        close(io)
    elseif len == 1
        for file in f
            if endswith(file,".vm")
                #asmFile = replace(file,Pair(".vm",".asm"))
                asmFile="$(r[findlast(x->x=='\\'||x=='/',r)+1:end]).asm"
                asmFile = joinpath(r,asmFile)
                file = joinpath(r,file)
                io = open(asmFile,"w")
                foreach( line -> Compiler.compileLine( line, io ),readlines(file))
                close(io)
            end
        end
    end
end
