

using PEG
#lexical elements
    @rule grammar = terms[*]
    @rule terms = keyword,symbol,integerConstant,string,identifier,space
    @rule  keyword = "class"|> K , "constructor" |> K , "function" |> K , "method" |> K , "field" |> K , "static" |> K ,
        "var" |> K , "int" |> K , "char" |> K , "boolean" |> K , "void" |> K , "true" |> K , "false" |> K , "null" |> K , "this" |> K ,
        "let" |> K , "do" |> K , "if" |> K , "else" |> K , "while" |> K|> K , "return" |> K
    @rule symbol = "{" |> S , "}" |> S , "(" |> S , ")" |> S , "[" |> S , "]" |> S , "." |> S , "," |> S , ";" |> S , "+" |> S , "-" |> S , "*" |> S , "/" |> S , "&amp" |> S , "|" |> S , "&lt" |> S , "&gt" |> S , "=" |> S , "~"|> S
    @rule integerConstant = r"\d+"w |> INT
    @rule string = r"\"(\\.|[^\"])*\"" |> STRING
    @rule identifier = r"[a-zA-Z_]+[a-zA-Z_0-9]*" |> IDENTIFIER
    @rule space = " " |>  x -> Nothing
#handlers
K = w -> "<keyword> $(w) <keyword>"
S = w -> "<symbol> $(w) <symbol>"
function INT(w)
    if(parse(Int,w) > 32767)
        throw("integer overflow")
    end
    return "<integerConstant> $(w) <integerConstant>"
end
STRING = w -> "<string> $(w) <string>"
IDENTIFIER = w -> "<identifier> $(w) <identifier>"

code = "class DC{let x=6;}"
tokens = split(code, ' ')
parse_whole(grammar, code)
#foreach(x->println(parse_whole(grammar ,x)),tokens)
