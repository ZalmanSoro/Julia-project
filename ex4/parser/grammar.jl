

using PEG
#lexical elements
    @rule grammar = keyword,symbol,integerConstant,string,identifier
    @rule  keyword = "class"|> K , "constructor" |> K , "function" |> K , "method" |> K , "field" |> K , "static" |> K ,
        "var" |> K , "int" |> K , "char" |> K , "boolean" |> K , "void" |> K , "true" |> K , "false" |> K , "null" |> K , "this" |> K ,
        "let" |> K , "do" |> K , "if" |> K , "else" |> K , "while" |> K|> K , "return" |> K
    @rule symbol = "{" |> S , "}" |> S , "(" |> S , ")" |> S , "[" |> S , "]" |> S , "." |> S , "," |> S , ";" |> S , "+" |> S , "-" |> S , "*" |> S , "/" |> S , "&amp" |> S , "|" |> S , "&lt" |> S , "&gt" |> S , "=" |> S , "~"|> S
    @rule integerConstant = r"\d+"w |> INT
    @rule string = r"\"(\\.|[^\"])*\"" |> STRING
    @rule identifier = r"\A[a-zA-Z_]+[a-zA-Z_0-9]*\Z" |> IDENTIFIER
    @rule space = r"[[:blank:]]" |>  x -> Nothing

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

code = "class DC { let x = 6 ; }"
tokens = split(code, ' ')
foreach(x->println(parse_whole(grammar ,x)),tokens)
