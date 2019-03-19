#=
    zalman sorotzkin 200789345
    avraham ben-yakar 204729388
    team 150060.01.5779.50
=#

function isFileVm(f)
    return endswith(f, ".vm")
end

function writeNumber(f)
    open(f[2],"a") do file
        println(file, f[1])
    end
end

function hello(f)
    asmFile = replace(f,Pair(".vm",".asm"))
    sourceIo = open(f,"r")
    dstIo = open(asmFile,"w")
    write(dstIo,read(sourceIo))
    close(sourceIo)
    close(dstIo)
    foreach(youAre,readlines(f))
end

function youAre(line)
    if(startswith(line,"you") | startswith(line,"are"))
        println(line)
    end
end

#=
function isFileVm(f)
    return match(r"\.[A-Za-z0-9]+$",f).match == ".vm"
end
=#

function handler(f)
    if(f[2] == "hello.vm")
        hello(f[2])
    end
    writeNumber(f)
end

path = "C:\\Users\\AVI\\.atom\\julia-projects\\exercises\\exercise_0"
cd(path)
files = readdir(path)
files = filter(isFileVm,files)
findall(ifile -> ifile == files[1],files)
#filesMap = map(file -> [file,first(findall(ifile -> ifile == file,files))],files)
foreach(handler, enumerate(files))
