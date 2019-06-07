import java.util {
    ArrayList,
    LinkedList
}
import ceylon.file {
    forEachLine
}

variable String result = "";
variable Integer currTok = 1;
variable String space = "";



shared String  parsering(String tokens) {

    result = "";
    space = "";
    value tmp_ =tokens.lines;
    value arrayOfTokens =  LinkedList<String>();

    for (token in tmp_ ){
        arrayOfTokens.add(token);
    }



    currTok=1;
    classFun(arrayOfTokens);

    return result;


}

void classFun (LinkedList<String> tokens){

    result += space + "<class>\n";
    space +=" ";

    result += space + tokens.get(currTok++) + "\n"; //The word 'class'
    result += space + tokens.get(currTok++) + "\n"; //Name of the Class
    result += space + tokens.get(currTok++) + "\n"; //{

    classVarDecFun(tokens);
    subrotineDecFun(tokens);

    result += space + tokens.get(currTok++) + "\n"; //}
    space =space.substring(1);
    result += space + "</class>\n";
}

void classVarDecFun (LinkedList<String> tokens) {


    while (tokens.get(currTok).contains("static") || tokens.get(currTok).contains("field")) {
        result += space + "<classVarDec>\n";
        space += " ";
        result += space + tokens.get(currTok++) + "\n"; //The word 'static' or 'field'
        result += space + tokens.get(currTok++) + "\n"; //Type - int|boolean|ClassName
        result += space + tokens.get(currTok++) + "\n"; //varName -identifier

        while (tokens.get(currTok).contains(",")) {
            result += space + tokens.get(currTok++) + "\n"; // token --> ,
            result += space + tokens.get(currTok++) + "\n"; //varName -identifier
        }
        result += space + tokens.get(currTok++) + "\n"; // ;
        space =space.substring(1);
        result += space + "</classVarDec>\n";
    }


}

void parameterListFunc(LinkedList<String> tokens){
    result += space + "<parameterList>\n";
    space += " ";
    if(! tokens.get(currTok).contains(")")){ //if it dose so the Parm list is empty
        result += space + tokens.get(currTok++) + "\n"; // Type -identifier
        result += space + tokens.get(currTok++) + "\n"; //varName -identifier
    }

    while (tokens.get(currTok).contains(",")) {
        result += space + tokens.get(currTok++) + "\n"; // token --> ,
        result += space + tokens.get(currTok++) + "\n"; // Type -identifier
        result += space + tokens.get(currTok++) + "\n"; //varName -identifier
    }
    space =space.substring(1);
    result += space + "</parameterList>\n";
}


void subrotineDecFun (LinkedList<String> tokens) {

    while(tokens.get(currTok).contains("constructor") ||
    tokens.get(currTok).contains("function") ||
    tokens.get(currTok).contains("method")) {

        result += space + "<subroutineDec>\n";
        space += " ";
        result += space + tokens.get(currTok++) + "\n"; // Token for word function or constractor or method
        result += space + tokens.get(currTok++) + "\n"; //Token for word void or type(identifier)
        result += space + tokens.get(currTok++) + "\n"; //Name of the Subrotine
        result += space + tokens.get(currTok++) + "\n"; //token--> (

        parameterListFunc(tokens); //The Parm list

        result += space + tokens.get(currTok++) + "\n"; //token --> )

        subrutinBodyFunc(tokens); //body of func
        space =space.substring(1);
        result += space + "</subroutineDec>\n";
    }

}

void subrutinBodyFunc(LinkedList<String> tokens){
    result += space + "<subroutineBody>\n";
    space += " ";
    result += space + tokens.get(currTok++) + "\n"; //token --> {

    varDecFunc(tokens);
    statementsFunc(tokens);

    result += space + tokens.get(currTok++) + "\n"; //token --> }
    space =space.substring(1);
    result += space + "</subroutineBody>\n";
}

void varDecFunc(LinkedList<String> tokens) {

    while (tokens.get(currTok).contains("var")) {
        result += space + "<varDec>\n";
        space += " ";
        result += space + tokens.get(currTok++) + "\n"; //The word 'var'
        result += space + tokens.get(currTok++) + "\n"; //Type - identifier
        result += space + tokens.get(currTok++) + "\n"; //varName -identifier

        while (tokens.get(currTok).contains(",")) {
            result += space + tokens.get(currTok++) + "\n"; // token --> ,
            result += space + tokens.get(currTok++) + "\n"; //varName -identifier
        }

        result += space + tokens.get(currTok++) + "\n"; // ;
        space =space.substring(1);
        result += space + "</varDec>\n";
    }
}

void statementsFunc(LinkedList<String> tokens) {

    result += space + "<statements>\n";
    space += " ";
    while(tokens.get(currTok).contains("let") ||
    tokens.get(currTok).contains("if") && !tokens.get(currTok).contains("<identifier>")||
    tokens.get(currTok).contains("while")||
    tokens.get(currTok).contains("do")||
    tokens.get(currTok).contains("return")){

        if(tokens.get(currTok).contains("let")){
            letStatementFunc(tokens);
        }else if(tokens.get(currTok).contains("if")){
            ifStatementFunc(tokens);
        }else if(tokens.get(currTok).contains("while")){
            whileStatementFunc(tokens);
        }else if(tokens.get(currTok).contains("do")){
            doStatementFunc(tokens);
        }else if(tokens.get(currTok).contains("return")){
            returnStatementFunc(tokens);
        }

    }
    space =space.substring(1);
    result += space + "</statements>\n";
}

void letStatementFunc(LinkedList<String> tokens) {
    result += space +"<letStatement>\n";
    space += " ";

    result += space + tokens.get(currTok++) + "\n"; // Word 'let'
    result += space + tokens.get(currTok++) + "\n"; //varName -identifier

    if(tokens.get(currTok).contains("[")){
        result += space + tokens.get(currTok++) + "\n"; // token--> [
        expressionFunc(tokens);
        result += space + tokens.get(currTok++) + "\n"; //token-->]
    }

    result += space + tokens.get(currTok++) + "\n"; // token--> =
    expressionFunc(tokens);
    result += space + tokens.get(currTok++) + "\n"; // token--> ;
    space =space.substring(1);
    result += space + "</letStatement>\n";
}

void ifStatementFunc(LinkedList<String> tokens) {
    result += space +"<ifStatement>\n";
    space += " ";
    result += space + tokens.get(currTok++) + "\n"; // Word 'if'
    result += space + tokens.get(currTok++) + "\n"; // token--> (
    expressionFunc(tokens);
    result += space + tokens.get(currTok++) + "\n"; // token--> )
    result += space + tokens.get(currTok++) + "\n"; // token--> {
    statementsFunc(tokens);
    result += space + tokens.get(currTok++) + "\n"; // token--> }

    if(tokens.get(currTok).contains("else")){
        result += space + tokens.get(currTok++) + "\n"; // Word 'else'
        result += space + tokens.get(currTok++) + "\n"; // token--> {
        statementsFunc(tokens);
        result += space + tokens.get(currTok++) + "\n"; // token--> }
    }
    space =space.substring(1);
    result += space + "</ifStatement>\n";
}

void whileStatementFunc(LinkedList<String> tokens) {
    result += space +"<whileStatement>\n";
    space += " ";
    result += space + tokens.get(currTok++) + "\n"; // Word 'While'
    result += space + tokens.get(currTok++) + "\n"; // token--> (
    expressionFunc(tokens);
    result += space + tokens.get(currTok++) + "\n"; // token--> )
    result += space + tokens.get(currTok++) + "\n"; // token--> {
    statementsFunc(tokens);
    result += space + tokens.get(currTok++) + "\n"; // token--> }
    space =space.substring(1);
    result += space + "</whileStatement>\n";
}

void doStatementFunc(LinkedList<String> tokens) {
    result += space +"<doStatement>\n";
    space += " ";
    result += space + tokens.get(currTok++) + "\n"; // Word 'do'
    subrotineCallFunc(tokens);
    result += space + tokens.get(currTok++) + "\n"; // token--> ;
    space =space.substring(1);
    result += space + "</doStatement>\n";

}

void returnStatementFunc(LinkedList<String> tokens) {
    result += space +"<returnStatement>\n";
    space += " ";
    result += space + tokens.get(currTok++) + "\n"; // Word 'return'

    if(!tokens.get(currTok).contains(";")){
        expressionFunc(tokens);
    }
    result += space + tokens.get(currTok++) + "\n"; // token--> ;
    space =space.substring(1);
    result += space + "</returnStatement>\n";
}

void expressionFunc(LinkedList<String> tokens) {
    result += space + "<expression>\n";
    space += " ";
    termFunc(tokens);
    while (tokens.get(currTok).contains("+") ||
    tokens.get(currTok).contains("-") ||
    tokens.get(currTok).contains("*") ||
    tokens.get(currTok).contains("> / <")||
    tokens.get(currTok).contains("&amp") ||
    tokens.get(currTok).contains("|") ||
    tokens.get(currTok).contains("&lt") ||
    tokens.get(currTok).contains("&gt")||
    tokens.get(currTok).contains("=")) {

        result += space + tokens.get(currTok++) + "\n"; // op token
        termFunc(tokens);
    }
    space =space.substring(1);
    result += space + "</expression>\n";
}

void subrotineCallFunc(LinkedList<String> tokens) {

    //result += space + "<subrotineCall>\n";

    if(tokens.get(currTok+1).contains("("))
    {
        result += space + tokens.get(currTok++) + "\n"; // Name of subroutin
        result += space + tokens.get(currTok++) + "\n"; // token--> (
        expressionListFunc(tokens);
        result += space + tokens.get(currTok++) + "\n"; // token--> )

    }
    else
    {
        result += space + tokens.get(currTok++) + "\n"; // Name of class or var
        result += space + tokens.get(currTok++) + "\n"; // token--> .
        result += space + tokens.get(currTok++) + "\n"; // token--> Name of subroutin
        result += space + tokens.get(currTok++) + "\n"; // token--> (
        expressionListFunc(tokens);
        result += space + tokens.get(currTok++) + "\n"; // token--> )
    }

    //result += space + "</subrotineCall>\n";

}

void termFunc(LinkedList<String> tokens) {
    result += space + "<term>\n";
    space += " ";

    if (tokens.get(currTok).contains("<stringConstant>") || tokens.get(currTok).contains("<integerConstant>") || tokens.get(currTok).contains("true")
    || tokens.get(currTok).contains("false") || tokens.get(currTok).contains("null") || tokens.get(currTok).contains("this")) {
        result += space + tokens.get(currTok++)+ "\n";
    }
    else if(tokens.get(currTok).contains("<identifier>")) {
        result += space +tokens.get(currTok++)+ "\n";
        if (tokens.get(currTok).contains("(")) {
            subrotineCallFunc(tokens);//(expertion)
        } else if (tokens.get(currTok).contains("[")) {//[expertion]
            result += space +tokens.get(currTok++)+ "\n";//[
            expressionFunc(tokens);
            result += space +tokens.get(currTok++)+ "\n";//]
        } else if (tokens.get(currTok).contains(".")) {
            result += space +tokens.get(currTok++)+ "\n";//.
            result += space +tokens.get(currTok++)+ "\n";//Name of subrutian
            result += space +tokens.get(currTok++)+ "\n";//(
            expressionListFunc(tokens);//call expretionFunc
            result += space +tokens.get(currTok++)+ "\n";//)
        }
    }
    else if(tokens.get(currTok).contains("(")) {
        result += space +tokens.get(currTok++)+ "\n";//(
        expressionFunc(tokens);//call expretionFunc
        result += space + tokens.get(currTok++)+ "\n";//)
    }
    else if(tokens.get(currTok).contains("-")) {
        result += space +tokens.get(currTok++)+ "\n";//-
        termFunc(tokens);
    }
    else if(tokens.get(currTok).contains("~")) {
        result += space +tokens.get(currTok++)+ "\n";//~
        termFunc(tokens);

    }
    space =space.substring(1);
    result += space + "</term>\n";
}


void expressionListFunc(LinkedList<String> tokens) {
    result += space + "<expressionList>\n";
    space += " ";
    if(!tokens.get(currTok).contains(")")){
        expressionFunc(tokens);

        while(tokens.get(currTok).contains(",")){
            result += space + tokens.get(currTok++) + "\n"; // token--> ,
            expressionFunc(tokens);
        }

    }
    space =space.substring(1);
    result += space + "</expressionList>\n";
}
