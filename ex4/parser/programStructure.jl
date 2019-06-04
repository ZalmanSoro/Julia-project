module Tokenizer
    include("xml-util.jl")
end  # module
using .Tokenizer
include("lexical.jl")

using EzXML
using PEG
#parser
    @rule class
    @rule classVarDec
    @rule type = "int" , "char" , "boolean", className
    @rule subrutineDec = ("constructor","function","method") & ("void",type) & subrutineName
    @rule parameterList = ((type & varName ) & ( "," & type & varName)[*])[:?]
    @rule subrutineBody = "{" & varDec[*] & statements & "}"
    @rule varDec = "var" & type & varNama & ("," & varName)[*] & ";"
    @rule className = identifier
    @rule subrutineName = identifier
    @rule varName = identifier
