package arbolast;
import java_cup.runtime.*;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;

%%

// Opciones y declaraciones
%public
%class AnalisisLexico
%cupsym Simbolo
%cup
%unicode
%line
%column

digito  =   [0-9]
entero  =   {digito}+
letra   =   [a-zA-Z]
id      =   ({letra} | "_") ({letra} | "_" | {digito})*
espacio =   (" " | \r | \n | \t | \f)+

%{
//variables, metodos y funciones que necesite (codigo java)

  ComplexSymbolFactory symbolFactory;
  
  public void setSymbolFactory(ComplexSymbolFactory sf){
      symbolFactory = sf;
  }

  private Symbol symbol(String name, int sym) {
      return symbolFactory.newSymbol(name, sym, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+yylength(),yychar+yylength()));
  }

  private Symbol symbol(String name, int sym, Object val) {
      Location left = new Location(yyline+1,yycolumn+1,yychar);
      Location right= new Location(yyline+1,yycolumn+yylength(), yychar+yylength());
      return symbolFactory.newSymbol(name, sym, left, right,val);
  }
  private Symbol symbol(String name, int sym, Object val,int buflength) {
      Location left = new Location(yyline+1,yycolumn+yylength()-buflength,yychar+yylength()-buflength);
      Location right= new Location(yyline+1,yycolumn+yylength(), yychar+yylength());
      return symbolFactory.newSymbol(name, sym, left, right,val);
  }
  private void error(String message) {
    System.out.println("Error en linea "+(yyline+1)+", columna "+(yycolumn+1)+" caracter: "+message);
  }
%}

%eofval{
     return symbolFactory.newSymbol("EOF", Simbolo.EOF, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+1,yychar+1));
%eofval}

%%

<YYINITIAL>{
    "("     {   return symbol("PARENTESIS_ABIERTO",Simbolo.PARENTESIS_ABIERTO);    }

    ")"     {   return symbol("PARENTESIS_CERRADO",Simbolo.PARENTESIS_CERRADO);    }

    ","     {   return symbol("COMA",Simbolo.COMA);                  }
    
    "if"    {   return symbol("IF",Simbolo.IF);                    }

    "else"  {   return symbol("ELSE",Simbolo.ELSE);                  }

    "Si"       { return symbol("IF", Simbolo.IF); }

    "No"       { return symbol("ELSE", Simbolo.ELSE); }

    "imprimir" { return symbol("IMPRIMIR", Simbolo.IMPRIMIR); }

    "FinSi"    { return symbol("END", Simbolo.END); }

    "end"   {   return symbol("END",Simbolo.END);                   }

    "Seleccionar" { return symbol("SWITCH", Simbolo.SWITCH); }

    "Caso"       { return symbol("CASE", Simbolo.CASE); }

    "FinCaso"    { return symbol("END", Simbolo.END); }

    "Contrario"  { return symbol("DEFAULT", Simbolo.DEFAULT); }

    "while" {   return symbol("WHILE",Simbolo.WHILE);                 }

    "Mientras"    { return symbol("WHILE", Simbolo.WHILE); }

    "FinMientras" { return symbol("END", Simbolo.END); }

    "concat"    {   return symbol("CONCAT",Simbolo.CONCAT);                }

    "for"   {   return symbol("FOR",Simbolo.FOR);                   }

    "Para"      { return symbol("FOR", Simbolo.FOR); }

    "Hasta"     { return symbol("MENOR", Simbolo.MENOR); }

    "siguiente" { return symbol("SIGUIENTE", Simbolo.SIGUIENTE); }

    "FinPara"   { return symbol("END", Simbolo.END); }

    "or"    {   return symbol("OR",Simbolo.OR);                    }

    "and"   {   return symbol("AND",Simbolo.AND);                   }

    "not"   {   return symbol("NOT",Simbolo.NOT);                  }

    "=="    {   return symbol("IGUAL_IGUAL",Simbolo.IGUAL_IGUAL);           }

    "<"     {   return symbol("MENOR",Simbolo.MENOR);                 }

    ">"     {   return symbol("MAYOR",Simbolo.MAYOR);                 }

    "="     {   return symbol("IGUAL",Simbolo.IGUAL);                 }

    "+"     {   return symbol("MAS",Simbolo.MAS);                   }

    "*"     {   return symbol("ASTERISCO",Simbolo.ASTERISCO);             }

    ";"     {   return symbol("PUNTO_COMA",Simbolo.PUNTO_COMA);           }

    "{"     {   return symbol("LLAVE_ABIERTA",Simbolo.LLAVE_ABIERTA);     }

    "}"     {   return symbol("LLAVE_CERRADA",Simbolo.LLAVE_CERRADA);     }

    ":"     {   return symbol("DOS_PUNTOS",Simbolo.DOS_PUNTOS);           }

    "switch" {  return symbol("SWITCH",Simbolo.SWITCH);                 }

    "case"  {   return symbol("CASE",Simbolo.CASE);                    }

    "default" { return symbol("DEFAULT",Simbolo.DEFAULT);               }

    "do"     { return symbol("DO", Simbolo.DO); }

    {entero}    {   return symbol("ENTERO",Simbolo.ENTERO, yytext());      }

    [\"] ~[\"]  {
                String t = yytext();
                return symbol("CADENA",Simbolo.CADENA, t.substring(1, t.length() - 1));
                }

    {id}    {   return symbol("ID",Simbolo.ID, yytext());          }

    {espacio}   { }

    "/*" ~"*/"  { }

    .   {   error(yytext());      }
}