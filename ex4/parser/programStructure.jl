module Tokenizer
    include("xml-util.jl")
end  # module

using EzXML
using PEG
#lexical
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
    @rule space = (r"[\s]*")[*] |> w -> return "space"
#handlers
K = w -> return addChild("keyword"," $w ")
S = w -> return addChild("symbol"," $w ")
function INT(w)
if(parse(Int,w) > 32767)
    throw("integer overflow")
end
return addChild("integerConstant"," $w ")
end
STRING = w -> return addChild("stringConstant"," $(SubString(w, 2:length(w)-1)) ")
IDENTIFIER = w -> return addChild("identifier", " $w ")

#parser
#& space& symbol & space & (classVarDec & space)[*] & (subrutineDec & space )[*] & symbol
    @rule class = space &  keyword & space & className  |> w -> RECURSIVE(w,"class")
    @rule classVarDec = keyword & space & type & space & varName & space & ( symbol & space & varName & space )[*] & symbol |> w -> RECURSIVE(w,"classVarDec")
    @rule type = keyword |> w -> RECURSIVE(w,"type") , className |> w -> RECURSIVE(w,"type")
    @rule subrutineDec = keyword & space & (keyword,type) & space & subrutineName & space & symbol & space & parameterList & space & symbol & space & subrutineBody |> w -> RECURSIVE(w,"subrutineDec")
    @rule parameterList = ((type & space & varName ) & space & ( symbol & space & type & space & varName & space )[*])[:?] |> w -> RECURSIVE(w,"parameterList")
    @rule subrutineBody = symbol & space & (varDec & space)[*] & space & statements & space & symbol |> w -> RECURSIVE(w,"subrutineBody")
    @rule varDec = keyword & space & type & space & varName & space & (symbol & space & varName)[*] & space & symbol & space |> w -> RECURSIVE(w,"varDec")
    @rule className = identifier |> w -> RECURSIVE(w,"className")
    @rule subrutineName = identifier |> w -> RECURSIVE(w,"subrutineName")
    @rule varName = identifier |> w -> RECURSIVE(w,"varName")
#statements
    @rule statements = ( statement & space )[*] |> w -> RECURSIVE(w,"statements")
    @rule statement = letStatement |> w -> RECURSIVE(w,"statement"), ifStatement |> w -> RECURSIVE(w,"statement"), whileStatement |> w -> RECURSIVE(w,"statement"), doStatement |> w -> RECURSIVE(w,"statement"), returnStatement |> w -> RECURSIVE(w,"statement")
    @rule letStatement = keyword  & space & varName & space & (symbol & space & expression & space & symbol)[:?] & space & symbol & space & expression & space & symbol |> w -> RECURSIVE(w,"letStatement")
    @rule letStatement = keyword  & space & symbol & space & expression & space & symbol & space & symbol & space & statements & space & symbol & space & ( keyword & space & symbol & space & statements & space & symbol)[:?] |> w -> RECURSIVE(w,"ifStatement")
    @rule whileStatement = keyword  & space & symbol & space & expression & space & symbol & space & symbol & space & statements & space & symbol |> w -> RECURSIVE(w,"whileStatement")
    @rule doStatement = keyword  & space & subrutineCall & space & symbol |> w -> RECURSIVE(w,"doStatement")
    @rule returnStatement = keyword  & space & expression[:?] & space & symbol |> w -> RECURSIVE(w,"returnStatement")
#expressions
    @rule expression = term & space & ( op & space & term & space)[*] |> w -> RECURSIVE(w,"expression")
    @rule term = integerConstant |> w -> RECURSIVE(w,"term") , stringConstant |> w -> RECURSIVE(w,"term") , keywordConstant |> w -> RECURSIVE(w,"term"), varName |> w -> RECURSIVE(w,"term")
    @rule subrutineCall = ( subrutineName & space & symbol & space & expressionList & space & symbol & space ) |> w -> RECURSIVE(w,"subrutineCall"), ( className , varName ) & symbol & subrutineName & space & symbol & space & expressionList & space & symbol & space|> w -> RECURSIVE(w,"subrutineCall")
    @rule experssionList = (expression & space & ( symbol & space & expression & space )[*])[:?]  |> w -> RECURSIVE(w,"expressionList")
    @rule op = ("+","-","*","/","&","|","<",">","=") |> w -> RECURSIVE(parse_next(symbol,w),"op")
    @rule unaryOp = ("~","-") |> w -> RECURSIVE(parse_next(symbol,w),"unaryOp")
    @rule keywordConstant = keyword |> w -> RECURSIVE(w,"keywordConstant")

function RECURSIVE(w,ruleName)
    println(`w is: $w`)
    parentNode = addChild(ruleName,"")
    if(!(w isa String ) && !(w isa Array))
        linkToParent(parentNode,w)
    elseif(w isa Array)
        recursiveHandler(parentNode,w)
    end
    return parentNode
end
function recursiveHandler(parentNode,w)
    for i in w
        println(`i is: $i`)
        if(!(i isa String ) && !(i isa Array))
            linkToParent(parentNode,i)
        elseif(i isa Array)
            recursiveHandler(parentNode,i)
        end
    end
end
Tokenizer.init("test")
PEG.setdebug!()
d = parse_next(class,"
class Main {
    static boolean test;
    function void main() {
      var SquareGame game;
      let game = SquareGame.new();
      do game.run();
      do game.dispose();
      return;
    }

    function void test() {
        var int i, j;
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
")
print(d)
Tokenizer.saveNewDoc("test",d)
