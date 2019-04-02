#=
    zalman sorotzkin 200789345
    avraham ben-yakar 204729388
    team 150060.01.5779.50
=#

module Compiler
    include("compiler.jl")
end

path = match(r".*julia-project",@__DIR__).match
for (r,d,f) in walkdir(joinpath(path,"Tests"))
    for file in f
        if endswith(file,".vm")
            asmFile = replace(file,Pair(".vm",".asm"))
            asmFile = joinpath(r,asmFile)
            file = joinpath(r,file)
            io = open(asmFile,"w")
            foreach( line -> Compiler.compileLine( line, io ),readlines(file))
            close(io)
        end
    end
end
