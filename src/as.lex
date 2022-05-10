%{
    #include "as.tab.h"
    int pos_line = 1;
    int pos_char = 0;
%}

%option noinput
%option nounput
%x c_comment

%%
struct						        {pos_char += yyleng; return STRUCT;}
^.*[\n<<EOF>>]  				    {strcpy(yylval.line, yytext); REJECT;}     
void                                {pos_char += yyleng; return VOID;}
int|char                            {pos_char += yyleng; return TYPE;}
print                               {pos_char += yyleng; return PRINT;}
if                                  {pos_char += yyleng; return IF;}
&&                                  {pos_char += yyleng; return AND;}
\|\|                                {pos_char += yyleng; return OR;}
[=!]=                               {pos_char += yyleng; return EQ;}
else                                {pos_char += yyleng; return ELSE;}
while                               {pos_char += yyleng; return WHILE;}
return                              {pos_char += yyleng; return RETURN;}
readc                               {pos_char += yyleng; return READC;}
reade                               {pos_char += yyleng; return READE;}
[\<\>]=? 						    {pos_char += yyleng; return ORDER;}
\+|\-                               {pos_char += yyleng; return ADDSUB;}
\*|\/|\%                            {pos_char += yyleng; return DIVSTAR;}
[a-zA-Z][a-zA-Z_0-9]*               {pos_char += yyleng; return IDENT;}
\'([a-zA-Z0-9]|\\n|\\'|\\t)\'	    {pos_char += yyleng; return CHARACTER;}
[0-9]+                              {pos_char += yyleng; return NUM;}
[/][*]							    {BEGIN c_comment;}
<c_comment>[*][/] 				    {BEGIN INITIAL;}
<c_comment>.						{pos_char += yyleng;}                       
<c_comment>\n 				    	{pos_char = 1; pos_line += 1;}
\/\/.*\n 						    {pos_char = 1; pos_line += 1;}
\t 								    {pos_char += 4;}	
" "								    {pos_char += 1;}
[\=\+\-*\/%!&,;\(\)\{\}\[\]]	    {pos_char += 1; return yytext[0];}
\n 								    {pos_char = 1; pos_line += 1;}
.								    {return 0;}
%%



