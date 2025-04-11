package arbolast;
import java_cup.runtime.Symbol;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;

%%

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
    System.out.println("Error en línea "+(yyline+1)+", columna "+(yycolumn+1)+" carácter: "+message);
  }

%}

%eofval{
     return symbolFactory.newSymbol("EOF", Simbolo.EOF, new Location(yyline+1,yycolumn+1,yychar), new Location(yyline+1,yycolumn+1,yychar+1));
%eofval}


%%

<YYINITIAL>{
    "("     {   return symbol("PARENTESIS_ABIERTO",Simbolo.PARENTESIS_ABIERTO);    }

    ")"     {   return symbol("PARENTESIS_CERRADO",Simbolo.PARENTESIS_CERRADO);    }

    "{"     { return symbol("LLAVE_ABIERTA", Simbolo.LLAVE_ABIERTA); }

    "}"     { return symbol("LLAVE_CERRADA", Simbolo.LLAVE_CERRADA); }

    ":"     { return symbol("DOS_PUNTOS", Simbolo.DOS_PUNTOS); }

    ","     {   return symbol("COMA",Simbolo.COMA);                  }

    "para"    { return symbol("PARA", Simbolo.PARA); }

    "hacer"  { return symbol("HACER", Simbolo.HACER); }

    "seleccionar" { return symbol("SELECCIONAR", Simbolo.SELECCIONAR); }

    "caso"   { return symbol("CASO", Simbolo.CASO); }

    "contrario" { return symbol("CONTRARIO", Simbolo.CONTRARIO); }
    
    "si"    {   return symbol("SI",Simbolo.SI);                    }

    "entonces"  {   return symbol("ENTONCES",Simbolo.ENTONCES);                  }

    "fin"   {   return symbol("FIN",Simbolo.FIN);                   }
    
    "finCaso"   {   return symbol("FIN",Simbolo.FIN);                   }

    "finMientras"   {   return symbol("FIN",Simbolo.FIN);                   }

    "finPara"   {   return symbol("FIN",Simbolo.FIN);                   }

    "finSi"   {   return symbol("FIN",Simbolo.FIN);                   }

    "mientras" {   return symbol("MIENTRAS",Simbolo.MIENTRAS);                 }

    "concatenar" {   return symbol("CONCATENAR",Simbolo.CONCATENAR); }

    "&" { return symbol("CONCAT", Simbolo.CONCAT); }

    "imprimir"  {   return symbol("IMPRIMIR",Simbolo.IMPRIMIR);                  }

    "o"    {   return symbol("O",Simbolo.O);                    }

    "y"   {   return symbol("Y",Simbolo.Y);                   }

    "no"   {   return symbol("NO",Simbolo.NO);                  }

    "=="    {   return symbol("IGUAL_IGUAL",Simbolo.IGUAL_IGUAL);           }

    "<"     {   return symbol("MENOR",Simbolo.MENOR);                 }

    ">"     {   return symbol("MAYOR",Simbolo.MAYOR);                 }

    "="     {   return symbol("IGUAL",Simbolo.IGUAL);                 }

    "+"     {   return symbol("MAS",Simbolo.MAS);                   }
    
    "-"     {   return symbol("MENOS",Simbolo.MENOS);                   }

    "/"     {   return symbol("DIVISION",Simbolo.DIVISION);                   }

    "*"     {   return symbol("ASTERISCO",Simbolo.ASTERISCO);             }

    {entero}    {   return symbol("ENTERO",Simbolo.ENTERO, yytext());      }

    [\"] ~[\"]  {
                String t = yytext();
                return symbol("CADENA",Simbolo.CADENA, t.substring(1, t.length() - 1));
                }

    {id}    {   return symbol("ID",Simbolo.ID, yytext());          }

    {espacio}   { }

    "#" [^\n]*   { }

    "/*" [^*]* "*"+([^/*][^*]*"*")* "/" { }

    .   {   error(yytext());      }

}
