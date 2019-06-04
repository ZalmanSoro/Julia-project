module Tokenizer
    include("xml-util.jl")
end  # module
using .Tokenizer
using EzXML
using PEG
#parser
    @rule statement = ifStatement,whileStatement,letStatement
    @rule statements = statement[*]
    @rule ifStatement = "if" & space[*] & "("& space[*] & expression & space[*] & ")" & space[*] & "{" & space[*] & statements & space[*] & "}"
    @rule whileStatement = "while" & space[*] & "("& space[*] &  expression & space[*] & ")"& space[*] &  "{" & space[*] & statements& space[*] &  "}"
    @rule letStatement = "let" & space[*] & varName & space[*] & "=" & space[*] & expression & space[*] & ";"
    @rule express = term & space[*] & opterm[:?]  |> EXP
    @rule opterm = op & space[*] & term |> OPTERM
    @rule term = varName |> TERM , constant |> TERM
    @rule varName = idn |> VARNAME
    @rule constant = intConst |> CONST,strConst |> CONST
    @rule op = "+" |> OP, "-" |> OP, "=" |> OP, ">" |> OP, "<" |> OP
    @rule idn = r"[a-zA-Z_]+[a-zA-Z_0-9]*" |> IDN
    @rule intConst = r"\d+" |> INTCONST
    @rule strConst = r"\"(\\.|[^\"])*\"" |> STRCONST
    @rule space = " ", "\r", "\n" |> w-> "space"

IDN = w -> return addChild("identifier", " $w ")
function TERM(w)
    par = addChild("term","")
    return linkToParent(par,w)
end
function VARNAME(w)
    par = addChild("varName","")
    return linkToParent(par,w)
end
INTCONST = w -> return addChild("integerConstant"," $w ")
STRCONST = w -> return addChild("stringConstant"," $w ")
function CONST(w)
    par = addChild("constant","")
    return linkToParent(par,w)
end
OP = w -> return addChild("operator"," $w ")
function EXP(w)
    repr(w)
    par = addChild("expression","")
    return linkToParent(par,right)
end
c= parse_next(express,"x=4")
