module Grammar
    include("grammar.jl")
end  # module Grammar



path = match(r".*julia-project",@__DIR__).match
for (r,d,f) in walkdir(joinpath(path,"Tests"))
    for file in f
        if endswith(file,".jack")
            _file = joinpath(r,file)
            code = read(_file,String)
            Grammar.tokenize(file,code)
        end
    end
end
