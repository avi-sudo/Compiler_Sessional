%option noyywrap


%{
#include<stdio.h>

#include<stdlib.h>

#include<bits/stdc++.h>

#include <iostream>

#include <cstdlib>

#include <cstdio>

#include <fstream>

using namespace std;

class SymbolInfo

{
private:
   
 string symbolname,symboltype;

public:
   
 SymbolInfo *next;
   
 SymbolInfo(string name,string type)
  
  {
        symbolname=name;
        symboltype=type;
        next=NULL;

    }
  
  SymbolInfo()
    {
        symbolname = "";
        symboltype = "";
        next=NULL;


    }
    
void set_name(string name)
    {
        symbolname=name;
    }
    
void set_type(string type)
    {
        symboltype=type;
    }

//    void set_next(SymbolInfo* nxt)
//    {
//        next=nxt;
//    }

    
string get_name()
    {
        return symbolname;
    }
    
string get_type()
    {
        return symboltype;
    }

//    SymbolInfo* get_next()
//    {
//        return next;
//    }

  
  int pos;
   
 SymbolInfo operator = (const SymbolInfo &sym)
   
 {
        this->symbolname = sym.symbolname;
        this->symboltype = sym.symboltype;
        return *this;
    }


};

//int current_id=0;


class ScopeTable

{
private:
  
  ScopeTable* parentScope;
  
  SymbolInfo** hashTable;
  
  int n,id;
	
FILE *logout;


public:
  
  ScopeTable(int n,FILE *a)
   
 {
        logout=a;
   
     id=0;
       
 this->n=n;
     
   hashTable = new SymbolInfo*[n];
       
 for(int k=1; k<=n; k++)
       
 {
            hashTable[k-1]=0;
        }
 
}
  
 void set_uniqueid(int id)
    {
        this->id=id;
    }
  
  void set_parentScope(ScopeTable* parentScope)
    {
        this->parentScope=parentScope;
    }
  
  int get_uniqueid()
    {
        return id;
    }
   
 ScopeTable* get_parentScope()
    {
        return parentScope;
    }
   
 ScopeTable()
    
{
        n=0;
   
     //current_id++;
   
     id=0;
      
  parentScope=0;
   
 }
   
 int hashFunction(string name)
  
  {
        long long pos = 0;
   
     unsigned long  p = 1;
     
   for(int j = 0; j < name.length(); j++)
        {
       
     pos += (name[j]) * p;
         
   p *= 37;
         
   // pos = (pos+x)%TABLE_SIZE;
      
  }
       
 //printf("%d ", (pos + i) % TABLE_SIZE);
      
  return (pos % this->n);
   
 }
   
 SymbolInfo* look_up(string symbol)
   
 {

        int position=0;
     
   int idx=hashFunction(symbol);
   
     SymbolInfo* temp = new SymbolInfo();
      
  temp=hashTable[idx];
     
   //temp->set_name(hashTable[idx]->get_name());
     
   //temp->set_type(hashTable[idx]->get_type());

      
  while(temp!=NULL)
        {

       
     if(temp->get_name()==symbol)
       
     {
                //cout<<"Found in ScopeTable# "<<this->id<<" at position "<<idx<<", "<<position<<endl;
          
      return temp;
      
      }
         
   temp=temp->next;
          
  position++;

      
  }

     
   //temp->pos=position;
   
     //cout<<symbol<<"Not Found"<<endl;

      
  return NULL;

   
 }
   
 bool insertion(string symbol,string type)
   
 {
       
 SymbolInfo *s=look_up(symbol);
   
     if(s!=0)
     
   {
           
 //cout<<"<"<<symbol<<","<<type<<"> already exists in current ScopeTable"<<endl;
          
  return false;
     
   }

     
   //SymbolInfo *node=new SymbolInfo(symbol,type);
   
     int idx=hashFunction(symbol);
      
  SymbolInfo* temp;
        
temp=hashTable[idx];
       
 SymbolInfo* prev;
      
  if(temp==NULL)
        {
   
         hashTable[idx]= new SymbolInfo(symbol,type);
            
//cout<<"Inserted in ScopeTable# "<<this->id<<" at position "<<idx<<", 0"<<endl;
      
      return true;
     
   }
       
 else
        {
          
  int position=0;
            
while(temp!=NULL)
            {
        
        prev=temp;
       
         temp=temp->next;
            
    position++;
        
    }
        
    //cout<<temp->get_name()<<endl;
   
         prev->next=new SymbolInfo(symbol,type);
         
   //temp->next->prev=temp;
          
  //cout<<temp->next->get_name()<<endl;
       
     //temp->set_next(node);
         
   //temp->get_next()->set_prev(temp);
         
  // cout<<"Inserted in ScopeTable# "<<this->id<<" at position "<<idx<<", "<<position<<endl;
         
   return true;
       
 }
   
 }
    
bool deletion(string symbol)
   
 {
     
   SymbolInfo *s=look_up(symbol);
    
    if(s==NULL)
        {
     
       //cout<<symbol<<"not found"<<endl;
           
 return false;
        }
    
    int idx=hashFunction(symbol);
     
   SymbolInfo* temp;
     
   temp=hashTable[idx];
      
  SymbolInfo* nxt;
     
   SymbolInfo* prev;
    
    if(temp->get_name()==symbol)
        {
       
     hashTable[idx]=temp->next;
         
   //cout<<" Deleted entry at "<<idx<<", 0 from current ScopeTable"<<endl;
     
       return true;
        }
     
   nxt=temp;
      
  int position=0;
      
  while(nxt->get_name()!=symbol)
        {
     
       prev=nxt;
    
        nxt=nxt->next;
    
        position++;
        }
      
  prev->next=nxt->next;
  
    //  prev->set_next(nxt->get_next());

//        else
//        {

//        if(s->get_prev()!=NULL)
//        {
//            s->get_prev()->set_next(s->get_next());
//
//        }
//        if(s->get_next()!=NULL)
//        {

//            s->get_next()->set_prev(s->get_prev());
//        }
    
    //cout<<" Deleted entry at "<<idx<<","<<position<<" from current ScopeTable"<<endl;

  
  }
    
void print()
   
 {
	//FILE *logout;
	
fprintf(logout," ScopeTable #%d\n",id);
      
 // cout<<" ScopeTable #"<<id<<endl;
      
  SymbolInfo *s;

  
      for (int i =1; i <=n; i++)
        {

	     //cout <<" "<< i-1 << " --> ";

    
        s = hashTable[i-1];

          
  if(s==NULL)
            {
     
           //cout<<endl;
		
continue;
            }
		


            else
            {

		
fprintf(logout," %d-->",i-1);
          
      while (s!=NULL)
                {
        
            fprintf(logout,"< %s : %s >",s->get_name().c_str(),s->get_type().c_str());
        
            //cout << "<" << s->get_name() << " : " << s->get_type()<< ">  ";

                 
   s = s->next;
                }

       
         //cout<<endl;
		
fprintf(logout,"\n");
          
  }
            

 
       }
       
 //cout<<endl;
	
fprintf(logout,"\n");
  
  }
  
  ~ScopeTable()
   
 {
       
 for(int i=0;i<n;i++)
        {
   
         SymbolInfo* temp;
         
   temp=hashTable[i];
        
    while(temp!=NULL)
            {
     
           SymbolInfo* t=temp->next;
    
            delete(temp);
             
   temp=t;

            }
    
    }
       
 delete[] hashTable;
   
 }

};


class SymbolTable

{
public:
   
 FILE *logout;
  
  ScopeTable* current_scope;
  
  int n,current_id;
 
   SymbolTable(int n,FILE *a)
    {
   
     this->n=n;
      
  current_id=0;
     
   current_scope =NULL;
	
logout=a;
   
 }
   
 void Enter_Scope()
    {
      
  ScopeTable *s=new ScopeTable(n,logout);
    
    s->set_parentScope(current_scope);
        
current_scope=s;
      
  current_id++;
       
 s->set_uniqueid(current_id);
       
 //cout<<" New ScopeTable with id "<<current_id<<" created"<<endl;


  
  }
   
 void Exit_Scope()
    {
   
     if(current_id==0)
        {
          
  //cout<<"No Scope Table is found."<<endl;
        }

 
       ScopeTable *temp=current_scope;
       
 current_scope=current_scope->get_parentScope();
     
   //cout<<"ScopeTable with id "<<this->current_id<<" removed"<<endl;
       
 delete temp;
      
  //current_id--;
    
}
    
bool table_insertion(string symbol,string type)
    {
      
  if(current_scope==NULL)
        {
       
     Enter_Scope();
         
   return current_scope->insertion(symbol,type);
      
  }
        
else
        {
           
 return current_scope->insertion(symbol,type);
        }
  
  }
   
 bool table_remove(string symbol)
    {
      
  if(current_scope==NULL)
        {
     
       //cout<<"No Scope Table is Found"<<endl;
       
     return false;
       
 }
      
  else
        {
         
   return current_scope->deletion(symbol);
        }
   
 }
    
SymbolInfo* table_Lookup(string name)
    {
     
   ScopeTable *temp;

      
  temp=current_scope;

   
     while(temp)
        {
          
  SymbolInfo* s=temp->look_up(name);
      
      if(s!=NULL)
            {
      
          return s;
            }
   
         temp=temp->get_parentScope();
      
  }
        return NULL;
   
 }
   
 void print_current_scopeTable()
    {
     
   current_scope->print();
    
}

 void print_all_scopeTable()
    {
  
      ScopeTable *temp;
   
     temp=current_scope;
     
   while(temp)
        {
           
 temp->print();
          
  temp=temp->get_parentScope();

      
  }

 }
   ~SymbolTable()
    {
   
     ScopeTable *prev = NULL;
   
     while(current_scope!= NULL)
        {
       
     prev = current_scope;
         
   current_scope = current_scope->get_parentScope();
     
       delete prev;
        }
  
  }

};


//#include "1605006_symboltable.h"

using namespace std;


int error_count=0;

int line_count=1;


FILE * logout= fopen("1605006_log.txt","w");

FILE *tokenout= fopen("1605006_token.txt","w");



SymbolTable s(11,logout);



string tab(string x){

string st;
	
int j=0;
	
for(int i=0;i<x.length();i++){
	
	if(x[i]=='\\' and x[i+1]=='t') st[j++]='\t';
	
	else if(x[i]=='\\' and x[i+1]=='\n') continue;

	else if(x[i]=='\n' and x[i-1]=='\\') continue;
	else if(x[i]=='t' and x[i-1]=='\\') continue; 
	
	else if(x[i]=='\\' and x[i+1]=='n') st[j++]='\n';
	
	else if(x[i]=='n' and x[i-1]=='\\') continue;

	else if(i==0 || i==x.length()-1)  continue;
	
	else if(x[i]=='\\' and x[i+1]=='v') st[j++]='\v';
	
	else if(x[i]=='v'  and x[i-1]=='\\') continue;
	else if( x[i]=='\"' and x[i-1]=='\\') continue;
	else if(x[i]=='\'' and x[i-1]=='\\')  continue;
	
	else if(x[i]=='\\' and x[i+1]=='\"') st[j++]='\"';
	
	else if(x[i]=='\\' and x[i+1]=='a') st[j++]='\a';
	
	else if(x[i]=='\\' and x[i+1]=='b') st[j++]='\b';
	
	else if(x[i]=='\\' and x[i+1]=='r') st[j++]='\r';
	
	else if(x[i]=='\\' and x[i+1]=='f') st[j++]='\f';
	
	else if(x[i]=='\\' and x[i+1]=='\\') st[j++]='\\';
	
	else if(x[i]=='\\' and x[i+1]=='\'') st[j++]='\'';
	
	else  st[j++]=x[i];
	
	}

	st[j]='\0';

	return st;

}

int countfunc(string x,int a){

	//int a=0;

	for(int i=0;i<x.length();i++){

		if(x[i]=='\n') a++;
		
		
	
	}

	return a;

}
 

char change(char *s){

	if(s[1]=='\\'){

		if(s[2]=='n') return '\n';

		else if(s[2]=='t') return '\t';

		else if(s[2]=='a') return '\a';

		else if(s[2]=='v') return '\v';

		else if(s[2]=='0') return '\0';

		else if(s[2]=='f') return '\f';

		else if(s[2]=='r') return '\r';

		else if(s[2]=='\\') return '\\';

		else if(s[2]=='\"') return '\"';

		else if(s[2]=='b') return '\b';

	}

	return s[1];

}



%}


WHITESPACE [ \t\f\r\v]+

DIGIT [0-9]

LETTER [a-zA-Z]

NEWLINE [\n]

ALPHANUM [a-zA-Z0-9\t ]

STRING \"[^\"\n]+\"

COMMENT "/*"([^*]|("*"[^/]))*"*/"

SINGLE_LINE_COMMENT "//"[^\n]*


CHAR [a-zA-Z\\n]

%%

{WHITESPACE}	{}


{NEWLINE}	{ line_count++;
                }


"if"		{ fprintf(tokenout,"<IF>");

		  fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);
		}


"else"		{ fprintf(tokenout,"<ELSE>");

		  fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);
		}


"break"		{ fprintf(tokenout,"<BREAK>");
	
	  fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);
		}


"while"		{ fprintf(tokenout,"<WHILE>");

		  fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);
		}


"for"		{ fprintf(tokenout,"<FOR>");

		  fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);
		}


"do"		{ fprintf(tokenout,"<DO>");

		  fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);
		}


"case"		{ fprintf(tokenout,"<CASE>");

		  fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);
		}


"switch"		{ fprintf(tokenout,"<SWITCH>");

		  fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
		}


"default"		{ fprintf(tokenout,"<DEFAULT>");

		  fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
		}


"continue"		{ fprintf(tokenout,"<CONTINUE>");

		  fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s 	found\n",line_count,yytext);
		}


"int"		{ fprintf(tokenout,"<INT>");

		  fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
		}


"float"		{ fprintf(tokenout,"<FLOAT>");

		  fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);
		}


"void"		{ fprintf(tokenout,"<VOID>");

		  fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);
		}


"return"		{ fprintf(tokenout,"<RETURN>");

		  fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);
		}


"char"		{ fprintf(tokenout,"<CHAR>");

		  fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);
		}


"double"		{ fprintf(tokenout,"<DOULE>");

		  fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);
		}


{DIGIT}+		{ fprintf(tokenout,"<CONST_INT,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n", 	line_count,yytext);

			s.table_insertion(yytext,"CONST_INT");

			s.print_current_scopeTable();
			
		}


\'({LETTER}{1}|\\[\abfnrtv])\'		{ 
  fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n", line_count,yytext);

			fprintf(tokenout,"<CONST_CHAR,%c>",change(yytext));

			
			s.table_insertion(yytext,"CONST_CHAR");
	
		s.print_current_scopeTable();
		}


{SINGLE_LINE_COMMENT}		{ 
	fprintf( logout,"Line no. %d: TOKEN <COMMENT> lexeme %s found\n", line_count,yytext);

				//line_count=countfunc(yytext,line_count);
	
			}


{COMMENT}			{ 

fprintf( logout,"Line no. %d: TOKEN <COMMENT> lexeme %s found\n", line_count,yytext);

				line_count=countfunc(yytext,line_count);
				}


"+"|"-"		{ fprintf(tokenout,"<ADDOP,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"ADDOP");
		}


"*"|"/"|"%"	{ fprintf(tokenout,"<MULOP,%s>",yytext);
	
	  fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"MULOP");
		}


"++"|"--"		{ fprintf(tokenout,"<INCOP,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"INCOP");
		}


"<"|"<="|">"|">="|"=="|"!="      { fprintf(tokenout,"<RELOP,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"RELOP");
		}


"="   		{ fprintf(tokenout,"<ASSIGNOP,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"ASSIGNOP");
		}


"&&"|"||"	{ fprintf(tokenout,"<LOGICOP,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"LOGICOP");
		}


"&"|"|"|"^"|"<<"|">>"	{ fprintf(tokenout,"<BITOP,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <BITOP> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"BITOP");
		}


"!"			{ fprintf(tokenout,"<NOT,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <NOT> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"NOT");
		}


"("		{ fprintf(tokenout,"<LPAREN,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"LPAREN");
		}


")"		{ fprintf(tokenout,"<RPAREN,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"RPAREN");
		}


"{"		{ fprintf(tokenout,"<LCURL,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"LCURL");
		}


"}"		{ fprintf(tokenout,"<RCURL,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <RCURL> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"RCURL");
		}


"["		{ fprintf(tokenout,"<LTHIRD,%s>",yytext);
	
	  fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"LTHIRD");
		}


"]"		{ fprintf(tokenout,"<RTHIRD,%s>",yytext);
	
	  fprintf(logout,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"RTHIRD");
		}


","		{ fprintf(tokenout,"<COMMA,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"COMMA");
		}


";"		{ fprintf(tokenout,"<SEMICOLON,%s>",yytext);

		 fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n", line_count,yytext);
	
			s.table_insertion(yytext,"SEMICOLON");
		}


({LETTER}|_)({LETTER}|{DIGIT}|_)*	{ fprintf(tokenout,"<ID,%s>",yytext);

		  fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);

			s.table_insertion(yytext,"ID");

			s.print_current_scopeTable();
		}


{DIGIT}({LETTER}|{DIGIT}|_)*	{ fprintf(logout,"Error at Line no. %d:  Invalid  Identifier %s \n",line_count,yytext);

			error_count++;
				}


{DIGIT}*\.{DIGIT}+(E[-+]?{DIGIT}+)? |
{DIGIT}+E[-+]?{DIGIT}+                 { fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
	
	        fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n", line_count,yytext);

			s.table_insertion(yytext,"CONST_FLOAT");

			s.print_current_scopeTable();
		}


{DIGIT}*([\.]+{DIGIT}*)+(E[\.]*[-+]?[\.]*{DIGIT}*)?[\.]*{DIGIT}*		{ fprintf(logout,"Error at Line No. %d: Too many decimal point %s \n",line_count,yytext);

			error_count++;
		}


\'{ALPHANUM}{2,}\'	{ fprintf(logout,"Error at Line no. %d: Multi Character constant error %s\n",line_count,yytext);

			error_count++;
			}


(\'{ALPHANUM})|(\'\\\')		{ fprintf(logout,"Error at Line no. %d: Unfinished Character %s\n", line_count,yytext);

			error_count++;
			}


\'\'			{ fprintf(logout,"Error at Line no. %d: Empty Character %s\n", line_count,yytext);

			error_count++;
			}


.			{ fprintf(logout,"Error at Line no. %d: Unrecognized Character %s\n",line_count,yytext);

			error_count++;
			}


"/*"([^*]|("*"[^/]))*[^"*/"]	{ fprintf(logout,"Error at Line no. %d: Unfinished Comment %s\n", line_count,yytext);

				line_count=countfunc(yytext,line_count);

			error_count++;
			}


{DIGIT}*[E][-+]?{DIGIT}+\.{DIGIT}*	{ fprintf(logout,"Error at Line no. %d: Ill formed number %s \n",line_count,yytext);

					error_count++;
					}







\"([^\"\n]*(\\\")*(\\\n)?)*\"   			{
fprintf(tokenout,"<STRING,%s>",tab(yytext).c_str());
	
			fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s\n", line_count,yytext);

				line_count=countfunc(yytext,line_count);
				}


\"([^\"\n]*([\\][\n])*)*		{
 	
fprintf(logout,"Error at Line no. %d: Unfinished string %s\n", line_count,yytext);

				line_count=countfunc(yytext,line_count);

			error_count++;
			}




%%

int main(int argc,char *argv[]){

	if(argc!=2){

		printf("Please provide input file name and try again\n");

		return 0;
	}

	
	FILE *fin=fopen(argv[1],"r");

	if(fin==NULL){

		printf("Cannot open specified file\n");

		return 0;
	}

	
	//logout= fopen("1605006_log.txt","w");

	//tokenout= fopen("1605006_token.txt","w");


	yyin= fin;
	yylex();

	fprintf(logout,"\nTotal Lines : %d\nTotal Errors : %d\n",line_count,error_count);

	fclose(yyin);

	fclose(tokenout);

	fclose(logout);

	return 0;

}
			
