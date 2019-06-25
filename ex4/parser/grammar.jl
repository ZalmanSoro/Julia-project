module Tokenizer
    include("xml-util.jl")
end  # module
using .Tokenizer
using EzXML
using PEG
#lexical elements
    @rule grammar = terms[*]
    @rule terms = comment,keyword,symbol,integerConstant,string,identifier,space
    @rule comment = r"(\/\/)+(.*)\n",r"\/[*]([\S\s]*)[*]\/"
    @rule  keyword = "class"|> K , "constructor" |> K , "function" |> K , "method" |> K , "field" |> K , "static" |> K ,
        "var" |> K , "int" |> K , "char" |> K , "boolean" |> K , "void" |> K , "true" |> K , "false" |> K , "null" |> K , "this" |> K ,
        "let" |> K , "do" |> K , "if" |> K , "else" |> K , "while" |> K|> K , "return" |> K
    @rule symbol = "{" |> S , "}" |> S , "(" |> S , ")" |> S , "[" |> S , "]" |> S , "." |> S , "," |> S , ";" |> S , "+" |> S , "-" |> S , "*" |> S , "/" |> S , "&amp" |> S , "|" |> S , "&lt" |> S , "&gt" |> S , "=" |> S , "~"|> S
    @rule integerConstant = r"\d+" |> INT
    @rule string = r"\"(\\.|[^\"])*\"" |> STRING
    @rule identifier = r"[a-zA-Z_]+[a-zA-Z_0-9]*" |> IDENTIFIER
    @rule space = " " ,"\n","\r"
#handlers
K = w -> Tokenizer.addToken("keyword"," $w ",file)
S = w -> Tokenizer.addToken("symbol"," $w ",file)
function INT(w)
    if(parse(Int,w) > 32767)
        throw("integer overflow")
    end
    Tokenizer.addToken("integerConstant"," $w ",file)
end
STRING = w -> Tokenizer.addToken("stringConstant"," $(SubString(w, 2:length(w)-1)) ",file)
IDENTIFIER = w -> Tokenizer.addToken("identifier"," $w ",file)


function tokenize(f,code)
    global file = f
    Tokenizer.init(file)
    PEG.parse_next(grammar,code)
end
