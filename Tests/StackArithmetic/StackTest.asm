@17
D = A
@SP
A = M
M = D
@SP
M = M + 1
@17
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
@SP
A = M
D = M
@SP
M = M - 1
A = M
D = D - M
@IF_140
D;JEQ
D = 0
@SP
A = M
M = D
@ELSE_176
0;JMP
(IF_140)
D = -1
@SP
A = M
M = D
(ELSE_176)
@SP
M = M + 1
@892
D = A
@SP
A = M
M = D
@SP
M = M + 1
@891
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
@SP
A = M
D = M
@SP
M = M - 1
A = M
D = D - M
@IF_391
D;JGE
D = 0
@SP
A = M
M = D
@ELSE_427
0;JMP
(IF_391)
D = -1
@SP
A = M
M = D
(ELSE_427)
@SP
M = M + 1
@32767
D = A
@SP
A = M
M = D
@SP
M = M + 1
@32766
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
@SP
A = M
D = M
@SP
M = M - 1
A = M
D = D - M
@IF_646
D;JLE
D = 0
@SP
A = M
M = D
@ELSE_682
0;JMP
(IF_646)
D = -1
@SP
A = M
M = D
(ELSE_682)
@SP
M = M + 1
@56
D = A
@SP
A = M
M = D
@SP
M = M + 1
@31
D = A
@SP
A = M
M = D
@SP
M = M + 1
@53
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
@SP
A = M
D = M
@SP
M = M - 1
A = M
M = M + D
@SP
M = M + 1
@112
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
@SP
A = M
D = M
@SP
M = M - 1
A = M
M = M - D
@SP
M = M + 1
@SP
M = M - 1
@SP
A = M
M = - M
@SP
M = M + 1
@SP
M = M - 1
@SP
A = M
D = M
@SP
M = M - 1
A = M
M = M & D
@SP
M = M + 1
@82
D = A
@SP
A = M
M = D
@SP
M = M + 1
@SP
M = M - 1
@SP
A = M
D = M
@SP
M = M - 1
A = M
M = M | D
@SP
M = M + 1
