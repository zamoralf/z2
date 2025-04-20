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

digito      = [0-9]
entero      = {digito}+
decimal     = {entero}\.{entero}
letra       = [a-zA-Z]
id          = ({letra} | "_") ({letra} | "_" | {digito})*
espacio     = (" " | \r | \n | \t | \f)+
caracter    = \'[^\'\\]\'
cadena      = \"[^\"\\]*\"
comentario  = "#"[^\r\n]*
multicomentario = "/*" [^*] ~"*/" | "/*" "*"+ "/"

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
    // Palabras reservadas para declaración de variables
    "Dim"               { return symbol("DIM", Simbolo.DIM); }
    "Como"              { return symbol("COMO", Simbolo.COMO); }
    
    // Tipos de datos
    "int"               { return symbol("INT", Simbolo.INT); }
    "char"              { return symbol("CHAR", Simbolo.CHAR); }
    "boolean"           { return symbol("BOOLEAN", Simbolo.BOOLEAN); }
    "string"            { return symbol("STRING", Simbolo.STRING); }
    "double"            { return symbol("DOUBLE", Simbolo.DOUBLE); }
    
    // Valores booleanos
    "true"              { return symbol("TRUE", Simbolo.TRUE, true); }
    "false"             { return symbol("FALSE", Simbolo.FALSE, false); }
    
    // Sentencia Imprimir
    "Imprimir"          { return symbol("IMPRIMIR", Simbolo.IMPRIMIR); }
    
    // Sentencia If/Else
    "Si"                { return symbol("SI", Simbolo.SI); }
    "Entonces"          { return symbol("ENTONCES", Simbolo.ENTONCES); }
    "No"                { return symbol("NO", Simbolo.NO); }
    "FinSi"             { return symbol("FINSI", Simbolo.FINSI); }
    
    // Sentencia Switch
    "Seleccionar"       { return symbol("SELECCIONAR", Simbolo.SELECCIONAR); }
    "Caso"              { return symbol("CASO", Simbolo.CASO); }
    "Contrario"         { return symbol("CONTRARIO", Simbolo.CONTRARIO); }
    "FinCaso"           { return symbol("FINCASO", Simbolo.FINCASO); }
    "FinSeleccionar"    { return symbol("FINSELECCIONAR", Simbolo.FINSELECCIONAR); }
    
    // Sentencia While
    "Mientras"          { return symbol("MIENTRAS", Simbolo.MIENTRAS); }
    "FinMientras"       { return symbol("FINMIENTRAS", Simbolo.FINMIENTRAS); }
    
    // Sentencia Do-While
    "Hacer"             { return symbol("HACER", Simbolo.HACER); }
    "RepetirMientras"   { return symbol("REPETIRMIENTRAS", Simbolo.REPETIRMIENTRAS); }
    
    // Sentencia For
    "Para"              { return symbol("PARA", Simbolo.PARA); }
    "Hasta"             { return symbol("HASTA", Simbolo.HASTA); }
    "Paso"              { return symbol("PASO", Simbolo.PASO); }
    "Siguiente"         { return symbol("SIGUIENTE", Simbolo.SIGUIENTE); }
    
    // Operadores aritméticos
    "+"                 { return symbol("MAS", Simbolo.MAS); }
    "-"                 { return symbol("MENOS", Simbolo.MENOS); }
    "*"                 { return symbol("ASTERISCO", Simbolo.ASTERISCO); }
    "/"                 { return symbol("DIVISION", Simbolo.DIVISION); }
    "^"                 { return symbol("POTENCIA", Simbolo.POTENCIA); }
    "%"                 { return symbol("MODULO", Simbolo.MODULO); }
    
    // Operadores lógicos
    ">"                 { return symbol("MAYOR", Simbolo.MAYOR); }
    "<"                 { return symbol("MENOR", Simbolo.MENOR); }
    ">="                { return symbol("MAYOR_IGUAL", Simbolo.MAYOR_IGUAL); }
    "<="                { return symbol("MENOR_IGUAL", Simbolo.MENOR_IGUAL); }
    "=="                { return symbol("IGUAL_IGUAL", Simbolo.IGUAL_IGUAL); }
    "!="                { return symbol("DIFERENTE", Simbolo.DIFERENTE); }
    
    // Operadores de asignación y otros símbolos
    "="                 { return symbol("IGUAL", Simbolo.IGUAL); }
    ";"                 { return symbol("PUNTO_COMA", Simbolo.PUNTO_COMA); }
    ":"                 { return symbol("DOS_PUNTOS", Simbolo.DOS_PUNTOS); }
    ","                 { return symbol("COMA", Simbolo.COMA); }
    "&"                 { return symbol("CONCAT", Simbolo.CONCAT); }
    "("                 { return symbol("PARENTESIS_ABIERTO", Simbolo.PARENTESIS_ABIERTO); }
    ")"                 { return symbol("PARENTESIS_CERRADO", Simbolo.PARENTESIS_CERRADO); }
    
    // Literales
    {entero}            { return symbol("ENTERO", Simbolo.ENTERO, Integer.parseInt(yytext())); }
    {decimal}           { return symbol("DECIMAL", Simbolo.DECIMAL, Double.parseDouble(yytext())); }
    {caracter}          { return symbol("CARACTER", Simbolo.CARACTER, yytext().charAt(1)); }
    
    // Cadenas
    {cadena}            { 
                          String t = yytext();
                          return symbol("CADENA", Simbolo.CADENA, t.substring(1, t.length() - 1)); 
                        }
    
    // Identificadores
    {id}                { return symbol("ID", Simbolo.ID, yytext()); }
    
    // Espacios en blanco y comentarios
    {espacio}           { /* ignorar espacios en blanco */ }
    {comentario}        { /* ignorar comentarios de una línea */ }
    {multicomentario}   { /* ignorar comentarios multilínea */ }
    
    // Manejo de errores
    .                   { error(yytext()); }
}