module Tokenizer
    include("xml-util.jl")
end  # module
using PEG
#lexical elements
    @rule grammar = terms[*]
    @rule terms = comment,keyword,symbol,integerConstant,string,identifier,space
    @rule comment = r"(\/\/)+(.*)\n", r"(\/[*])+(.)*(\s)*[*]\/"#|> x->Tokenizer.addToken("comment","comment","HelloT")
    @rule  keyword = "class"|> K , "constructor" |> K , "function" |> K , "method" |> K , "field" |> K , "static" |> K ,
        "var" |> K , "int" |> K , "char" |> K , "boolean" |> K , "void" |> K , "true" |> K , "false" |> K , "null" |> K , "this" |> K ,
        "let" |> K , "do" |> K , "if" |> K , "else" |> K , "while" |> K|> K , "return" |> K
    @rule symbol = "{" |> S , "}" |> S , "(" |> S , ")" |> S , "[" |> S , "]" |> S , "." |> S , "," |> S , ";" |> S , "+" |> S , "-" |> S , "*" |> S , "/" |> S , "&amp" |> S , "|" |> S , "&lt" |> S , "&gt" |> S , "=" |> S , "~"|> S
    @rule integerConstant = r"\d+" |> INT
    @rule string = r"\"(\\.|[^\"])*\"" |> STRING
    @rule identifier = r"[a-zA-Z_]+[a-zA-Z_0-9]*" |> IDENTIFIER
    @rule space = " " ,"\n","\r"

#handlers
K = w -> Tokenizer.addToken("keyword"," $w ","HelloT")
S = w -> Tokenizer.addToken("symbol"," $w ","HelloT")
function INT(w)
    if(parse(Int,w) > 32767)
        throw("integer overflow")
    end
    Tokenizer.addToken("integerConstant"," $w ","HelloT")
end
STRING = w -> Tokenizer.addToken("stringConstant"," $(SubString(w, 2:length(w)-1)) ","HelloT")
IDENTIFIER = w -> Tokenizer.addToken("identifier"," $w ","HelloT")


init("HelloT")
code =
"// This file is part of www.nand2tetris.org
// and the book \"The Elements of Computing Systems\"
// by Nisan and Schocken, MIT Press.
// File name: projects/10/Square/Main.jack

// (derived from projects/09/Square/Main.jack, with testing additions)

/** Initializes a new Square Dance game and starts running it. */
class Main {
    static boolean test;    // Added for testing -- there is no static keyword
                            // in the Square files.
    function void main() {
      var SquareGame game;
      let game = SquareGame.new();
      do game.run();
      do game.dispose();
      return;
    }

    function void test() {  // Added to test Jack syntax that is not use in
        var int i, j;       // the Square files.
        var String s;
        var Array a;
        if (false) {
            let s = \"string constant\";
            let s = null;
            let a[1] = a[2];
        }
        else {              // There is no else keyword in the Square files.
            let i = i * (-j);
            let j = j / (-2);   // note: unary negate constant 2
            let i = i | j;
        }
        return;
    }
}
"

PEG.parse_next(grammar,code)
