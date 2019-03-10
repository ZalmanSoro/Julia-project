function handler(f)
    if( match(r"\.[A-Za-z0-9]+$",f[1]).match == ".vm")
        open(f[1],"a") do file
            println(file, f[2])
        end
    end
    if(f[1] == "hello.vm")
        asm(f[1])
    end
end

function asm(f)
    asmFile = replace(f,Pair(".vm",".asm"))
    srcIo = open(f,"r")
    dstIo = open(asmFile,"w")
    write(dstIo,read(srcIo))
    close(srcIo)
    close(dstIo)

end

path = "C:/workspace/julia-projects/ex0/"
files = cd(readdir,path)
filesMap = map(file -> [file,first(findall(ifile -> ifile == file,files))],files)
foreach(handler, filesMap)
