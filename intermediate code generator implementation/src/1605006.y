%error-verbose;
%{
#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<bits/stdc++.h>
#include <fstream>
#include<sstream>
using namespace std;
class SymbolInfo
{
private:
    string symbolname,symboltype,declaredtype;
public:
	string code;
	string id_value;
    SymbolInfo *next;
	vector<string>para_name;
	vector<string>para_type;
	vector<string>func_variable_list;
	string return_type;
	string Array_size;
	bool defined;
    SymbolInfo(string name,string type,string dectype="")
    {
        symbolname=name;
        symboltype=type;
		declaredtype=dectype;
        next=NULL;
       func_variable_list.clear();
		para_name.clear();
		para_type.clear();
		return_type="";
		defined=false;
		code="";
		id_value="";
		Array_size="";
    }
    SymbolInfo()
    {
        symbolname = "";
        symboltype = "";
		declaredtype="";
        next=NULL;
		func_variable_list.clear();
		para_name.clear();
		para_type.clear();
		return_type="";
		defined=false;
		code="";
		id_value="";
		Array_size="";
    }
    void set_name(string name)
    {
        symbolname=name;
    }
    void set_type(string type)
    {
        symboltype=type;
    }
    void set_declaredtype(string type)
	{
	  declaredtype=type;
	}


    string get_name()
    {
        return symbolname;
    }
    string get_type()
    {
        return symboltype;
    }
    string get_declaredtype()
	{
		return declaredtype;
	}
    int pos;
    SymbolInfo operator = (const SymbolInfo &sym)
    {
        this->symbolname = sym.symbolname;
        this->symboltype = sym.symboltype;
	this->declaredtype=sym.declaredtype;
        return *this;
    }
	void add_parameters(string name,string type)
	{
		para_name.push_back(name);
		para_type.push_back(type);
	}
	void add_variable(string name)
	{
		func_variable_list.push_back(name);
	}
	void para_clear(){
		para_name.clear();
		para_type.clear();
	}
};
//int current_id=0;

class ScopeTable
{
private:
    ScopeTable* parentScope;
    SymbolInfo** hashTable;
    int n,id;

public:
    ScopeTable(int n)
    {
        //current_id++;
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
            
        }
       
        return (pos % this->n);
    }
    SymbolInfo* look_up(string symbol)
    {

        int position=0;
        int idx=hashFunction(symbol);
        SymbolInfo* temp = new SymbolInfo();
        temp=hashTable[idx];
       
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
    bool insertion(string symbol,string type,string dectype)
    {
        SymbolInfo *s=look_up(symbol);
        if(s!=0)
        {
           // cout<<"<"<<symbol<<","<<type<<"> already exists in current ScopeTable"<<endl;
            return false;
        }

       
        int idx=hashFunction(symbol);
        SymbolInfo* temp;
        temp=hashTable[idx];
        SymbolInfo* prev;
        if(temp==NULL)
        {
			SymbolInfo *c=new SymbolInfo();
			c->set_name(symbol);
			c->set_type(type);
			c->set_declaredtype(dectype);
            hashTable[idx]= c;//new SymbolInfo(symbol,type,dectype);
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
            SymbolInfo *c=new SymbolInfo();
			c->set_name(symbol);
			c->set_type(type);
			c->set_declaredtype(dectype);
            prev->next=c;//new SymbolInfo(symbol,type,dectype);
            
           // cout<<"Inserted in ScopeTable# "<<this->id<<" at position "<<idx<<", "<<position<<endl;
            return true;
        }
    }
    bool deletion(string symbol)
    {
        SymbolInfo *s=look_up(symbol);
        if(s==NULL)
        {
           // cout<<symbol<<"not found"<<endl;
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
           // cout<<" Deleted entry at "<<idx<<", 0 from current ScopeTable"<<endl;
            return true;
        }
        nxt=temp;
        int position=0;
        while(nxt->get_name()!=symbol)
        {
            prev=nxt;
            nxt=nxt->next;
            //nxt=nxt->get_next();
            position++;
        }
        prev->next=nxt->next;
      
        //cout<<" Deleted entry at "<<idx<<","<<position<<" from current ScopeTable"<<endl;

    }
    void print(FILE *logout)
    {
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
            //delete s;

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
    ScopeTable* current_scope;
    int n,current_id;
    SymbolTable(int n)
    {
        this->n=n;
        current_id=0;
        current_scope =NULL;
    }
    void Enter_Scope(FILE *logout)
    {
        ScopeTable *s=new ScopeTable(n);
        s->set_parentScope(current_scope);
        current_scope=s;
        current_id++;
        s->set_uniqueid(current_id);
	fprintf(logout,"ScopeTable with id %d created\n",this->current_id);
      // cout<<" New ScopeTable with id "<<current_id<<" created"<<endl;


    }
    void Exit_Scope(FILE *logout)
    {
        if(current_id==0)
        {
            //cout<<"No Scope Table is found."<<endl;
        }

        ScopeTable *temp=current_scope;
        current_scope=current_scope->get_parentScope();
	fprintf(logout,"ScopeTable with id %d removed\n",this->current_id);
        //cout<<"ScopeTable with id "<<this->current_id<<" removed"<<endl;
        delete temp;
        //current_id--;
    }
    bool table_insertion(string symbol,string type,string dectype)
    {
	 return current_scope->insertion(symbol,type,dectype);
       /* if(current_scope==NULL)
        {
            Enter_Scope();
            return current_scope->insertion(symbol,type,dectype);
        }
        else
        {
            return current_scope->insertion(symbol,type,dectype);
        }*/
    }
    bool table_remove(string symbol)
    {
        if(current_scope==NULL)
        {
            cout<<"No Scope Table is Found"<<endl;
            return false;
        }
        else
        {
            return current_scope->deletion(symbol);
        }
    }
	SymbolInfo* current_Lookup(string name)
	{
		if(current_scope)
		{
			return current_scope->look_up(name);
		}
		return 0;
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
	int id_Lookup(string name)
	{
		ScopeTable *temp;

        temp=current_scope;

        while(temp)
        {
            SymbolInfo* s=temp->look_up(name);
            if(s!=NULL)
            {
                return temp->get_uniqueid();
            }
            temp=temp->get_parentScope();
        }
        return -1;

	}
    void print_current_scopeTable(FILE *logout)
    {
        current_scope->print(logout);
    }
    void print_all_scopeTable(FILE *logout)
    {
        ScopeTable *temp;
        temp=current_scope;
        while(temp)
        {
            temp->print(logout);
            temp=temp->get_parentScope();

        }
    }
	int get_current_id()
	{
		return current_scope->get_uniqueid();
	}
	int get_next_id()
	{
		return (current_id+1);
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

//#include "1605006_symboltable.cpp"
//#define YYSTYPE SymbolInfo*
#include<sstream>
#include<string.h>
using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
FILE *fp;
//FILE *error=fopen("1605006_error.txt","w");
FILE *logout= fopen("1605006_log.txt","w");
vector<SymbolInfo*>declared_list;
int line_count=1;
int error_count=0;

SymbolTable s(30);

vector<string>variable_declared_list;
vector<string>function_variable_declared_list;
vector<pair<string,string>>array_variable_declared_list;
vector<string>temp_list;
int labelCount=0;
int tempCount=0;


char *newLabel()
{
	char *lb= new char[4];
	strcpy(lb,"L");
	char b[3];
	sprintf(b,"%d", labelCount);
	labelCount++;
	strcat(lb,b);
	return lb;
}
string tostring(int i)
{
	ostringstream temp;
	temp<<i;
	return temp.str();
}

char *newTemp()
{
	char *t= new char[4];
	strcpy(t,"t");
	char b[3];
	sprintf(b,"%d", tempCount);
	tempCount++;
	strcat(t,b);
	return t;
}


string ret_Type="";
int array_size=0;
void yyerror(const char *s)
{
	fprintf(logout,"Error at Line no %d : %s\n",line_count-1,s);
}
vector<SymbolInfo*>argument_list;
void optimization(FILE *asmcode);
string current_function_name="";
vector<SymbolInfo*>parameter_list;
%}

%token IF ELSE FOR WHILE DO BREAK INT FLOAT CHAR DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE CONST_INT CONST_FLOAT CONST_CHAR ADDOP MULOP INCOP ASSIGNOP BITOP NOT DECOP LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON STRING ID PRINTLN

%left BITOP 
%left ADDOP 
%left MULOP
%right ASSIGNOP 
%right NOT
%nonassoc THAN
%nonassoc ELSE
%nonassoc RELOP 
%nonassoc LOGICOP
%union
{
	//class SymbolInfo;
        SymbolInfo* symbolinfo;
		//vector<string>*s;
}
//%type <s>start


%%
start : program
	{
		//fprintf(logout,"%s",$<symbolinfo>1->get_name().c_str()); 
			//$<symbolinfo>$=new SymbolInfo();
			//$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
		if(error_count==0){
			string asmcodes="";
			asmcodes+=".MODEL SMALL\n.STACK 100H\n.DATA\n";
			int j=0;
			while(j<variable_declared_list.size()){
				asmcodes+=variable_declared_list[j]+" dw ?\n";
				j++;
			}
			int k=0;
			while(k<array_variable_declared_list.size()){
				asmcodes+=array_variable_declared_list[k].first+" dw "+array_variable_declared_list[k].second+" dup(?)\n";
				k++;
			}
			$<symbolinfo>1->code=asmcodes+".CODE\n"+$<symbolinfo>1->code;
			$<symbolinfo>1->code=$<symbolinfo>1->code+"PRINT PROC \n\
	PUSH AX \n\
    PUSH BX \n\
    PUSH CX \n\
    PUSH DX  \n\
    CMP AX,0 \n\ 
    JGE END_IF1 \n\ 
    PUSH AX \n\
    MOV DL,'-' \n\ 
    MOV AH,2 \n\
    INT 21H \n\ 
    POP AX \n\ 
    NEG AX \n\ 
    END_IF1: \n\ 
    XOR CX,CX \n\ 
    MOV BX,10 \n\ 
    REPEAT: \n\
    XOR DX,DX \n\ 
    IDIV BX \n\
    PUSH DX \n\
    INC CX \n\
    OR AX,AX \n\ 
    JNE REPEAT \n\
    MOV AH,2 \n\ 
    PRINT_LOOP: \n\ 
    POP DX \n\ 
    ADD DL,30H \n\
    INT 21H \n\
    LOOP PRINT_LOOP \n\ 
    MOV AH,2\n\
    MOV DL,10\n\
    INT 21H\n\
    MOV DL,13\n\
    INT 21H\n\
    POP DX \n\ 
    POP CX \n\
    POP BX \n\ 
    POP AX \n\
    ret \n\
PRINT ENDP \n\
END MAIN\n";
		FILE* asmcode= fopen("1605006_code.asm","w");
	 
	 fprintf(asmcode,"%s",$<symbolinfo>1->code.c_str());
	 fclose(asmcode);
	 asmcode= fopen("1605006_code.asm","r");
	 optimization(asmcode);
		}
		
	}
	;

program : program unit { 
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code+$<symbolinfo>2->code;
			}

	| unit { 
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			}
	;
	
unit : var_declaration {
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"\n");
			function_variable_declared_list.clear();
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			}
     | func_declaration {
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"\n");
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			}
     | func_definition {
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"\n");
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			}
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
			 
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo* si=s.table_Lookup($<symbolinfo>2->get_name());
			if(si==NULL)
			{
				s.table_insertion($<symbolinfo>2->get_name(),"ID","function");
				si=s.table_Lookup($<symbolinfo>2->get_name());
				
				int i=0;
				while(i<parameter_list.size())
				{
					si->add_parameters(parameter_list[i]->get_name(),parameter_list[i]->get_declaredtype());
					i++;
				}
				parameter_list.clear();
				
				si->return_type=$<symbolinfo>1->get_name();
			}
			else
			{
				int n = si->para_name.size();
				if(n!=parameter_list.size())
				{
					error_count++;
					fprintf(logout,"Error at Line No. %d : Invalid number of parameters.\n",line_count);
				}
				if(si->return_type!=$<symbolinfo>1->get_name())
				{
					error_count++;
					fprintf(logout,"Error at Line No. %d : Return type Mismatch.\n",line_count);
				}
				if(n==parameter_list.size())
				{
					int i=0;
					while(i<parameter_list.size())
					{
						if(si->para_type[i]!=parameter_list[i]->get_declaredtype())
						{
							error_count++;
							fprintf(logout,"Error at Line No. %d : Parameter type Mismatch.\n",line_count);	
							break;
						}
						i++;
					}
					
				}
				parameter_list.clear();
			}

			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"("+$<symbolinfo>4->get_name()+");");
			}
		| type_specifier ID LPAREN RPAREN SEMICOLON { 
			
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo* si=s.table_Lookup($<symbolinfo>2->get_name());
			if(si==NULL)
			{
				s.table_insertion($<symbolinfo>2->get_name(),"ID","function");
				si=s.table_Lookup($<symbolinfo>2->get_name());
				si->return_type=$<symbolinfo>1->get_name();
			}
			else
			{
				if(si->return_type!=$<symbolinfo>1->get_name())
				{
					error_count++;
					fprintf(logout,"Error at Line No. %d : Return type Mismatch.\n",line_count);
				}
				if(si->para_name.size()!=0)
				{
					error_count++;
					fprintf(logout,"Error at Line No. %d : Invalid number of parameters.\n",line_count);
				}
			}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"();");
			}
		| type_specifier ID LPAREN RPAREN error {
			error_count++;
			//fprintf(logout,"Error at Line no. %d : Syntax error\n\n",line_count);
		}
		| type_specifier ID LPAREN parameter_list RPAREN error	{
			error_count++;
			//fprintf(logout,"Error at Line no. %d : Syntax error\n\n",line_count);
		}
		| type_specifier ID LPAREN parameter_list error SEMICOLON {
			error_count++;
		}
		| type_specifier ID LPAREN error SEMICOLON {
			error_count++;
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN{
			SymbolInfo *si=s.table_Lookup($<symbolinfo>2->get_name());
			ret_Type=$<symbolinfo>1->get_name();
			if(si==NULL)
			{
				s.table_insertion($<symbolinfo>2->get_name(),"ID","function");
				si=s.table_Lookup($<symbolinfo>2->get_name());
				si->return_type=$<symbolinfo>1->get_name();
				si->defined=true;
				int i=0;
				int k;
				while(i<parameter_list.size())
				{
					si->add_parameters(parameter_list[i]->get_name()+tostring(s.get_next_id()),parameter_list[i]->get_declaredtype());
					
					i++;
				}
				for(k=0;k<parameter_list.size();k++)
					{
						if(si->para_name[k]=="" || parameter_list[k]->get_name()=="")
						{
							error_count++;
							fprintf(logout,"Error at Line No. %d : Missing of parameter's name\n\n",line_count);
							break;
						}
					}
				//parameter_list.clear();
			}
			else if(si->defined==true)
			{
				error_count++;
				fprintf(logout,"Error at Line No.%d :  Multiple defination of function %s\n\n",line_count,$<symbolinfo>2->get_name().c_str());
			}
			else if(si->defined==false)
			{
				
				if(si->return_type!=$<symbolinfo>1->get_name())
				{
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Return Type Mismatch. \n\n",line_count);
				}
				if(si->para_name.size()!=parameter_list.size())
				{
					
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Invalid number of parameters. \n\n",line_count);
				}
				if(si->para_name.size()==parameter_list.size())
				{
					int j,k;
					for(j=0;j<parameter_list.size();j++)
					{
						if(si->para_type[j]!=parameter_list[j]->get_declaredtype())
						{
							error_count++;
							fprintf(logout,"Error at Line No. %d : Parameter Type Mismatch\n\n",line_count);
							break;
						}
					}
					for(k=0;k<parameter_list.size();k++)
					{
						if(si->para_name[k]=="" || parameter_list[k]->get_name()=="")
						{
							error_count++;
							fprintf(logout,"Error at Line No. %d : Missing of parameter's name\n\n",line_count);
							break;
						}
					}
				}
				//parameter_list.clear();
				si->defined=true;
				si->para_clear();
				int q=0;

				while(q<parameter_list.size())
				{
					si->add_parameters(parameter_list[q]->get_name()+tostring(s.get_next_id()),parameter_list[q]->get_declaredtype());
					
					q++;
				}
			}
			current_function_name=$<symbolinfo>2->get_name();
			variable_declared_list.push_back(current_function_name+"_return");

			//$<symbolinfo>1->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"("+$<symbolinfo>4->get_name()+")");
} compound_statement {
			
			
		
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"("+$<symbolinfo>4->get_name()+")"+$<symbolinfo>7->get_name());
			$<symbolinfo>$->code=$<symbolinfo>2->get_name()+" PROC\n";
			if($<symbolinfo>2->get_name()=="main"){
				$<symbolinfo>$->code=$<symbolinfo>$->code+"\tMOV AX,@DATA\n\tMOV DS,AX \n"+$<symbolinfo>7->code+"Return"+current_function_name+":\n\tMOV AH,4CH\n\tINT 21H\n";
			}
			else{
				SymbolInfo *si=s.table_Lookup($<symbolinfo>2->get_name()); 

				
										
				string asmcodes=$<symbolinfo>$->code+"\tPUSH AX\n\tPUSH BX \n\tPUSH CX \n\tPUSH DX\n";
				
				
				asmcodes+=$<symbolinfo>7->code+"Return"+current_function_name+":\n";
				
				
				asmcodes+="\tPOP DX\n\tPOP CX\n\tPOP BX\n\tPOP AX\n\tret\n";
				$<symbolinfo>$->code=asmcodes+$<symbolinfo>2->get_name()+" ENDP\n";
			}
			}
		| type_specifier ID LPAREN RPAREN{
		  	SymbolInfo *si=s.table_Lookup($<symbolinfo>2->get_name());
			ret_Type=$<symbolinfo>1->get_name();
			if(si==NULL)
			{
				s.table_insertion($<symbolinfo>2->get_name(),"ID","function");
				si=s.table_Lookup($<symbolinfo>2->get_name());
				si->return_type=$<symbolinfo>1->get_name();
				si->defined=true;
			}
			else if(si->defined==false)
			{
				if(si->return_type!=$<symbolinfo>1->get_name())
				{
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Return Type Mismatch. \n\n",line_count);
				}
				if(si->para_name.size()!=0)
				{
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Invalid number of parameters. \n\n",line_count);
				}
				si->defined=true;
			}
			else if(si->defined==true)
			{
				error_count++;
				fprintf(logout,"Error at Line No.%d :  Multiple defination of function %s\n\n",line_count,$<symbolinfo>2->get_name().c_str());
			}
			current_function_name=$<symbolinfo>2->get_name();
			variable_declared_list.push_back(current_function_name+"_return");
			

		 // $<symbolinfo>1->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"()");
		} compound_statement {
			
		
			 
			$<symbolinfo>$=new SymbolInfo();

			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"()"+$<symbolinfo>6->get_name());
			$<symbolinfo>$->code=$<symbolinfo>2->get_name()+" PROC\n";
			if($<symbolinfo>2->get_name()=="main"){
				$<symbolinfo>$->code=$<symbolinfo>$->code+"\tMOV AX,@DATA\n\tMOV DS,AX \n"+$<symbolinfo>6->code+"Return"+current_function_name+":\n\tMOV AH,4CH\n\tINT 21H\n";
			}
			else{
				SymbolInfo *si=s.table_Lookup($<symbolinfo>2->get_name()); 

				
									
				string asmcodes=$<symbolinfo>$->code+"\tPUSH AX\n\tPUSH BX \n\tPUSH CX \n\tPUSH DX\n";
				
				asmcodes+=$<symbolinfo>6->code+"Return"+current_function_name+":\n";
				

				asmcodes+="\tPOP DX\n\tPOP CX\n\tPOP BX\n\tPOP AX\n\tret\n";
				$<symbolinfo>$->code=asmcodes+$<symbolinfo>2->get_name()+" ENDP\n";
			}
			}
		/*| 	type_specifier ID LPAREN RPAREN error {
			
		}
		|	type_specifier ID LPAREN parameter_list RPAREN error	{

		}*/
 		;				


parameter_list  : parameter_list COMMA type_specifier ID {
			 
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>4->get_name());
			p->set_type("ID");
			p->set_declaredtype($<symbolinfo>3->get_name());
			for(int j=0;j<parameter_list.size();j++)
			{
				if($<symbolinfo>4->get_name()==parameter_list[j]->get_name())
				{
				error_count++;
				fprintf(logout,"Error at Line No. %d : Redeclaration of parameter\n\n",line_count);
				}
			}
			
			parameter_list.push_back(p);
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+","+$<symbolinfo>3->get_name()+" "+$<symbolinfo>4->get_name());
			}
		| parameter_list COMMA type_specifier {
			
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name("");
			p->set_type("ID");
			p->set_declaredtype($<symbolinfo>3->get_name());
			parameter_list.push_back(p);
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+","+$<symbolinfo>3->get_name());
			}
 		| type_specifier ID {
			 
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>2->get_name());
			p->set_type("ID");
			p->set_declaredtype($<symbolinfo>1->get_name());
			parameter_list.push_back(p);
			
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name());
			}
		| type_specifier { 
			
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name("");
			p->set_type("ID");
			p->set_declaredtype($<symbolinfo>1->get_name());
			parameter_list.push_back(p);
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
 		;

 		
compound_statement : LCURL{
			s.Enter_Scope(logout);
			int i=0;
			while(i<parameter_list.size())
			{
				s.table_insertion(parameter_list[i]->get_name(),"ID",parameter_list[i]->get_declaredtype());
				variable_declared_list.push_back(parameter_list[i]->get_name()+tostring(s.get_current_id()));
				i++;
			}
			
			parameter_list.clear();

} statements RCURL {
			
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name("{\n"+$<symbolinfo>3->get_name()+"\n}");
			$<symbolinfo>$->code=$<symbolinfo>3->code;
			//s.print_all_scopeTable(logout);
			s.Exit_Scope(logout);
			}
 		    | LCURL RCURL {
			s.Enter_Scope(logout);
			int i=0;
			while(i<parameter_list.size())
			{
				s.table_insertion(parameter_list[i]->get_name(),"ID",parameter_list[i]->get_declaredtype());
				variable_declared_list.push_back(parameter_list[i]->get_name()+tostring(s.get_current_id()));
				i++;
			}
			
			parameter_list.clear();
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name("{}");
			//s.print_all_scopeTable(logout);
			s.Exit_Scope(logout);
			}
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {
			 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>1->get_name()!="void")
			{
				int i=0;
				
			while(i<declared_list.size())
			{
				SymbolInfo *si=s.current_Lookup(declared_list[i]->get_name());
				if(si)
				{
					error_count++;
					fprintf(logout,"Error at Line No. %d : Redeclaration of variable : %s\n\n",line_count,declared_list[i]->get_name().c_str());

					 
				} 
               else
			   {
				if(declared_list[i]->get_type()=="IDAR")
				{
					declared_list[i]->set_type("ID");
					s.table_insertion(declared_list[i]->get_name(),declared_list[i]->get_type(),$<symbolinfo>1->get_name()+"array");
					array_variable_declared_list.push_back(make_pair(declared_list[i]->get_name()+tostring(s.get_current_id()),declared_list[i]->Array_size));
				}
				else if(declared_list[i]->get_type()=="ID")
				{
					s.table_insertion(declared_list[i]->get_name(),declared_list[i]->get_type(),$<symbolinfo>1->get_name());
					variable_declared_list.push_back(declared_list[i]->get_name()+tostring(s.get_current_id()));
					function_variable_declared_list.push_back(declared_list[i]->get_name()+tostring(s.get_current_id()));
				}}
				i++;
			}
			
			}
			else if($<symbolinfo>1->get_name()=="void")
			{
				error_count++;
				fprintf(logout,"Error at Line No.%d : Type specifier of variable can not be void\n\n",line_count);
			}
			declared_list.clear();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+";");
			}
		|	type_specifier declaration_list error	{
				error_count++;
		}
 		 ;
 		 
type_specifier	: INT {
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
 		| FLOAT {
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
 		| VOID {
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
 		;
 		
declaration_list : declaration_list COMMA ID { 
			
			$<symbolinfo>$=new SymbolInfo(); 
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>3->get_name());
			p->set_type("ID");
			p->set_declaredtype("");
			declared_list.push_back(p);
			//declared_list.push_back(new SymbolInfo($<symbolinfo>3->get_name(),"ID"));
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+","+$<symbolinfo>3->get_name());
			}
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD {
			 
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>3->get_name());
			p->set_type("IDAR");
			p->Array_size=$<symbolinfo>5->get_name();
			//p->set_type("ID"+$<symbolinfo>5->get_name());
			p->set_declaredtype("");
			declared_list.push_back(p);
			//declared_list.push_back(new SymbolInfo($<symbolinfo>3->get_name(),"IDAR"));
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+","+$<symbolinfo>3->get_name()+"["+$<symbolinfo>5->get_name()+"]");
			}
 		  | ID {
			
			$<symbolinfo>$=new SymbolInfo(); 
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>1->get_name());
			p->set_type("ID");
			p->set_declaredtype("");
			declared_list.push_back(p);
			//declared_list.push_back(new SymbolInfo($<symbolinfo>1->get_name(),"ID"));
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
 		  | ID LTHIRD CONST_INT RTHIRD {
			 
			$<symbolinfo>$=new SymbolInfo();
			stringstream geek($<symbolinfo>3->get_name());
			int x=0;
			geek >> x; 
			array_size=x;
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>1->get_name());
			p->set_type("IDAR");
			p->Array_size=$<symbolinfo>3->get_name();
			p->set_declaredtype("");
			declared_list.push_back(p);
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"["+$<symbolinfo>3->get_name()+"]");
			}
 		  ;
 		  
statements : statement { 
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			}
	   | statements statement { 
			 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"\n"+$<symbolinfo>2->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code+$<symbolinfo>2->code;
			}
	   ;
	   
statement : var_declaration {
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	  | expression_statement {
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			}
	  | compound_statement {
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			}
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement  { 
			 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(logout,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			else{
				string asmcodes=$<symbolinfo>3->code;
				char *label1=newLabel();
				char *label2=newLabel();
				asmcodes+=string(label1)+":\n";
				asmcodes+=$<symbolinfo>4->code;
				asmcodes+="\tMOV AX,"+$<symbolinfo>4->id_value+"\n";
				asmcodes+="\tCMP AX,0\n";
				asmcodes+="\tJE "+string(label2)+"\n";
				asmcodes+=$<symbolinfo>7->code;
				asmcodes+=$<symbolinfo>5->code;
				asmcodes+="\tJMP "+string(label1)+"\n";
				asmcodes+=string(label2)+": \n";
				$<symbolinfo>$->code=asmcodes;
			}
			$<symbolinfo>$->set_name("for("+$<symbolinfo>3->get_name()+$<symbolinfo>4->get_name()+$<symbolinfo>5->get_name()+")\n"+$<symbolinfo>7->get_name());
			}	
	  | IF LPAREN expression RPAREN statement %prec THAN { 
			
			$<symbolinfo>$=new SymbolInfo(); 
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(logout,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			else{
				string asmcodes=$<symbolinfo>3->code;
				char *label1=newLabel();
				asmcodes+="\tMOV AX,"+$<symbolinfo>3->id_value+"\n";
				asmcodes+="\tCMP AX,0\n";
				asmcodes+="\tJE "+string(label1)+"\n";
				asmcodes+=$<symbolinfo>5->code;
				asmcodes+=string(label1)+":\n";
				$<symbolinfo>$->code=asmcodes;
			}
			$<symbolinfo>$->set_name("if("+$<symbolinfo>3->get_name()+")\n"+$<symbolinfo>5->get_name());
			}	
	  | IF LPAREN expression RPAREN statement ELSE statement {
			 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(logout,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			else{
				string asmcodes=$<symbolinfo>3->code;
				char *label1=newLabel();
				char *label2=newLabel();
				asmcodes+="\tMOV AX,"+$<symbolinfo>3->id_value+"\n";
				asmcodes+="\tCMP AX,0\n";
				asmcodes+="\tJE "+string(label1)+"\n";
				asmcodes+=$<symbolinfo>5->code;
				asmcodes+="\tJMP "+string(label2)+"\n";
				asmcodes+=string(label1)+":\n";
				asmcodes+=$<symbolinfo>7->code;
				asmcodes+=string(label2)+":\n";
				$<symbolinfo>$->code=asmcodes;
			}
			$<symbolinfo>$->set_name("if("+$<symbolinfo>3->get_name()+")\n"+$<symbolinfo>5->get_name()+"\n else\n"+$<symbolinfo>7->get_name());
			}	
	  | WHILE LPAREN expression RPAREN statement  { 
			 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(logout,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			else{
				string asmcodes="";
				char *label1=newLabel();
				char *label2=newLabel();
				asmcodes+=string(label1)+":\n";
				asmcodes+=$<symbolinfo>3->code;
				asmcodes+="\tMOV AX,"+$<symbolinfo>3->id_value+"\n";
				asmcodes+="\tCMP AX,0\n";
				asmcodes+="\tJE "+string(label2)+"\n";
				asmcodes+=$<symbolinfo>5->code;
				asmcodes+="\tJMP "+string(label1)+"\n";
				asmcodes+=string(label2)+":\n";
				$<symbolinfo>$->code=asmcodes;
			}
			$<symbolinfo>$->set_name("while("+$<symbolinfo>3->get_name()+")\n"+$<symbolinfo>5->get_name());
			}	
	  | PRINTLN LPAREN ID RPAREN SEMICOLON {
			 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name("println("+$<symbolinfo>3->get_name()+");");
			string asmcodes="";
			if(s.id_Lookup($<symbolinfo>3->get_name())==-1){
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Undeclared variable : %s \n\n",line_count,$<symbolinfo>3->get_name().c_str());
					}
			else{
											
				asmcodes+="\tMOV AX,"+$<symbolinfo>3->get_name()+tostring(s.id_Lookup($<symbolinfo>3->get_name()));
				asmcodes+="\n\tCALL PRINT\n";
			}
			$<symbolinfo>$->code=asmcodes;
			}
	  | RETURN expression SEMICOLON {
			
			$<symbolinfo>$=new SymbolInfo();
			
			if($<symbolinfo>2->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(logout,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			else{
				string asmcodes=$<symbolinfo>2->code;
			    asmcodes+="\tMOV AX,"+$<symbolinfo>2->id_value+"\n";
				asmcodes+="\tMOV "+current_function_name+"_return,AX\n";
			    asmcodes+="\tJMP Return"+current_function_name+"\n";
				$<symbolinfo>$->code=asmcodes;
			}
			
			if(ret_Type!=$<symbolinfo>2->get_declaredtype())
			{
				
				error_count++;
				fprintf(logout,"Error at Line No. %d : Return Type Mismatch\n",line_count);
				
			}
			$<symbolinfo>$->set_name("return "+$<symbolinfo>2->get_name()+";");
			}
		| RETURN expression error	{
			error_count++;
		}
		| PRINTLN LPAREN ID RPAREN error	{
			error_count++;
		}
	  ;
	  
expression_statement 	: SEMICOLON	{
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name(";");
			}		
			| expression SEMICOLON {
			
			$<symbolinfo>$=new SymbolInfo();
			 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+";");
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			$<symbolinfo>$->id_value=$<symbolinfo>1->id_value;
			
			}
			| error	{
				error_count++;
			}
			| expression error	{
				error_count++;
			}
			;
	  
variable : ID 	{ 
			
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo* si=s.table_Lookup($<symbolinfo>1->get_name());
			if(si==NULL)
			{
				error_count++;
				fprintf(logout,"Error at Line No. %d : Undeclared variable %s\n",line_count,$<symbolinfo>1->get_name().c_str());
			}
			else if(si)
			{
				$<symbolinfo>$->set_declaredtype(si->get_declaredtype());
				int y=s.id_Lookup($<symbolinfo>1->get_name());
				string a=tostring(y);
				$<symbolinfo>$->id_value=$<symbolinfo>1->get_name()+a;
				//printf("%s\n",$<symbolinfo>$->id_value.c_str());
				if(si->get_declaredtype()=="intarray" || si->get_declaredtype()=="floatarray")
				{
				error_count++;
				fprintf(logout,"Error at Line No.%d : %s was declared as an array \n\n",line_count,$<symbolinfo>1->get_name().c_str());
				}
			}
			$<symbolinfo>$->set_type("notarray");
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			
			}	
	 | ID LTHIRD expression RTHIRD { 
			
		    $<symbolinfo>$=new SymbolInfo();

			SymbolInfo* si=s.table_Lookup($<symbolinfo>1->get_name());
			if(si==NULL)
			{
				error_count++;
				fprintf(logout,"Error at Line No. %d : Undeclared variable %s\n",line_count,$<symbolinfo>1->get_name().c_str());
			}
			else if(si)
			{
				
				if($<symbolinfo>3->get_declaredtype()!="int")
				{
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Non-integer Array Index  \n",line_count);
					int y=s.id_Lookup($<symbolinfo>1->get_name());
					string a=tostring(y);
					$<symbolinfo>$->id_value=$<symbolinfo>1->get_name()+a;
				}
				if(si->get_declaredtype()=="intarray")
				{
					$<symbolinfo>1->set_declaredtype("int");
				}
				else if(si->get_declaredtype()=="floatarray")
				{
					$<symbolinfo>1->set_declaredtype("float");
				}
               else if(si->get_declaredtype()!="intarray" && si->get_declaredtype()!="floatarray")
				{
					error_count++;
					fprintf(logout,"Error at Line No.%d : %s is not an Array  \n\n",line_count,si->get_name().c_str());
				}
				$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());

				string asmcodes="";
				asmcodes+=$<symbolinfo>3->code;
				asmcodes+="\tMOV BX, "+$<symbolinfo>3->id_value+"\n";
				asmcodes+="\tADD BX,BX\n";
				int y=s.id_Lookup($<symbolinfo>1->get_name());
				string a=tostring(y);
				$<symbolinfo>$->id_value=$<symbolinfo>1->get_name()+a;
				$<symbolinfo>$->code=asmcodes;
				
			}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"["+$<symbolinfo>3->get_name()+"]");
			$<symbolinfo>$->set_type("array");
			}
	 ;
	 
expression : logic_expression	{ 
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			$<symbolinfo>$->id_value=$<symbolinfo>1->id_value;
			}
	   | variable ASSIGNOP logic_expression { 
			
			$<symbolinfo>$=new SymbolInfo(); 
			
			
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(logout,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
			    $<symbolinfo>$->set_declaredtype("int");
			}
			
			else if($<symbolinfo>1->get_declaredtype()!="")
				{
					
					if($<symbolinfo>1->get_declaredtype()!=$<symbolinfo>3->get_declaredtype())
					{
						error_count++;
						fprintf(logout,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
						
					}
					else{
						string asmcodes=$<symbolinfo>1->code;
						char *temp = newTemp();
						if($<symbolinfo>1->get_type() != "notarray")
{
     asmcodes+="\tmov " + string(temp) + ",bx\n";
}
						asmcodes+=$<symbolinfo>3->code;
						asmcodes+="\tMOV AX,"+$<symbolinfo>3->id_value+"\n";
						if($<symbolinfo>1->get_type()=="notarray"){
													
													
							asmcodes+="\tMOV "+$<symbolinfo>1->id_value+",AX\n";
							}
						else{
							asmcodes+="\tmov bx," + string(temp) + "\n";
							asmcodes+="\tMOV "+$<symbolinfo>1->id_value+"[BX],AX\n";
							
							variable_declared_list.push_back(string(temp));
							temp_list.push_back(string(temp));
						}
							$<symbolinfo>$->code=asmcodes;

							$<symbolinfo>$->id_value=$<symbolinfo>1->id_value;
					}
				}
			
			

			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"="+$<symbolinfo>3->get_name());
			}	
	   ;
			
logic_expression : rel_expression { 
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			$<symbolinfo>$->id_value=$<symbolinfo>1->id_value;
			}	
		 | rel_expression LOGICOP rel_expression { 
			 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>1->get_declaredtype()=="void" || $<symbolinfo>3->get_declaredtype()=="void")
			{
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
					$<symbolinfo>$->set_declaredtype("int");
				}
			else{
				string asmcodes=$<symbolinfo>1->code;
				asmcodes+=$<symbolinfo>3->code;
				char *label1=newLabel();
				char *label2=newLabel();
				char *label3=newLabel();
				char *t=newTemp();
				if($<symbolinfo>2->get_name()=="&&"){
					asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
					asmcodes+="\tCMP AX,0\n";
					asmcodes+="\tJE "+string(label2)+"\n";
			        asmcodes+="\tMOV AX,"+$<symbolinfo>3->id_value+"\n";
			        asmcodes+="\tCMP AX,0\n";
		            asmcodes+="\tJE "+string(label2)+"\n";
					asmcodes+=string(label1)+":\n";
				    asmcodes+="\tMOV "+string(t)+",1\n";
	                asmcodes+="\tJMP "+string(label3)+"\n";
			        asmcodes+=string(label2)+":\n";
		            asmcodes+="\tMOV "+string(t)+",0\n";
		            asmcodes+=string(label3)+":\n";
				}
				else if($<symbolinfo>2->get_name()=="||"){
					asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
					asmcodes+="\tCMP AX,0\n";
					asmcodes+="\tJNE "+string(label2)+"\n";
					asmcodes+="\tMOV AX,"+$<symbolinfo>3->id_value+"\n";
					asmcodes+="\tCMP AX,0\n";
					asmcodes+="\tJNE "+string(label2)+"\n";
		            asmcodes+=string(label1)+":\n";
                    asmcodes+="\tMOV "+string(t)+",0\n";
					asmcodes+="\tJMP "+string(label3)+"\n";
		            asmcodes+=string(label2)+":\n";
			        asmcodes+="\tMOV "+string(t)+",1\n";
					asmcodes+=string(label3)+":\n";
				}
				$<symbolinfo>$->code=asmcodes;
				$<symbolinfo>$->id_value=string(t);
				variable_declared_list.push_back(string(t));
				temp_list.push_back(string(t));
			}
			$<symbolinfo>$->set_declaredtype("int");
		
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name()+$<symbolinfo>3->get_name());
			}	
		 ;
			
rel_expression	: simple_expression {
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			$<symbolinfo>$->id_value=$<symbolinfo>1->id_value;
			}
		| simple_expression RELOP simple_expression { 
			
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>1->get_declaredtype()=="void" || $<symbolinfo>3->get_declaredtype()=="void"){
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
					$<symbolinfo>$->set_declaredtype("int");
				}
			else{
				string asmcodes=$<symbolinfo>1->code;
				asmcodes+=$<symbolinfo>3->code;
				char *label1=newLabel();
				char *label2=newLabel();
				
				char *t=newTemp();
				asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
				asmcodes+="\tCMP AX,"+$<symbolinfo>3->id_value+"\n";
				if($<symbolinfo>2->get_name()=="<"){
					asmcodes+="\tJL "+string(label1)+"\n";

				}
				else if($<symbolinfo>2->get_name()==">"){
					asmcodes+="\tJG "+string(label1)+"\n";

				}
				else if($<symbolinfo>2->get_name()=="<="){
					asmcodes+="\tJLE "+string(label1)+"\n";

				}
				else if($<symbolinfo>2->get_name()==">="){
					asmcodes+="\tJGE "+string(label1)+"\n";

				}
				else if($<symbolinfo>2->get_name()=="=="){
					asmcodes+="\tJE "+string(label1)+"\n";

				}
				else if($<symbolinfo>2->get_name()=="!="){
					asmcodes+="\tJNE "+string(label1)+"\n";
				}
				asmcodes+="\tMOV "+string(t)+",0\n";
				asmcodes+="\tJMP "+string(label2)+"\n";
				asmcodes+=string(label1)+":\n";
				asmcodes+="\tMOV "+string(t)+",1\n";
				asmcodes+=string(label2)+":\n";
				$<symbolinfo>$->code=asmcodes;
				$<symbolinfo>$->id_value=string(t);
				variable_declared_list.push_back(string(t));
				temp_list.push_back(string(t));

			}
			$<symbolinfo>$->set_declaredtype("int");
			
		
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name()+$<symbolinfo>3->get_name());
			}	
		;
				
simple_expression : term { 
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			$<symbolinfo>$->id_value=$<symbolinfo>1->id_value;
			}
		  | simple_expression ADDOP term { 
			
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>1->get_declaredtype()=="float" || $<symbolinfo>3->get_declaredtype()=="float")
			{
				$<symbolinfo>$->set_declaredtype("float");
				string asmcodes=$<symbolinfo>1->code+$<symbolinfo>3->code;

				asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
				char *temp=newTemp();
				if($<symbolinfo>2->get_name()=="+"){
					asmcodes+="\tADD AX,"+$<symbolinfo>3->id_value+"\n";
				}
				else{
					asmcodes+="\tSUB AX,"+$<symbolinfo>3->id_value+"\n";

				}
				asmcodes+="\tMOV "+string(temp)+",AX\n";
				$<symbolinfo>$->code=asmcodes;
				$<symbolinfo>$->id_value=string(temp);
				variable_declared_list.push_back(string(temp));
				temp_list.push_back(string(temp));
			}
			else if($<symbolinfo>1->get_declaredtype()=="int" && $<symbolinfo>3->get_declaredtype()=="int"){
					$<symbolinfo>$->set_declaredtype("int");
					string asmcodes=$<symbolinfo>1->code+$<symbolinfo>3->code;

				asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
				char *temp=newTemp();
				if($<symbolinfo>2->get_name()=="+"){
					asmcodes+="\tADD AX,"+$<symbolinfo>3->id_value+"\n";
				}
				else{
					asmcodes+="\tSUB AX,"+$<symbolinfo>3->id_value+"\n";

				}
				asmcodes+="\tMOV "+string(temp)+",AX\n";
				$<symbolinfo>$->code=asmcodes;
				$<symbolinfo>$->id_value=string(temp);
				variable_declared_list.push_back(string(temp));
				temp_list.push_back(string(temp));
				}
			else if($<symbolinfo>1->get_declaredtype()=="void" || $<symbolinfo>3->get_declaredtype()=="void"){
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
					$<symbolinfo>$->set_declaredtype("int");
				}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name()+$<symbolinfo>3->get_name());
			}
		  ;
					
term :	unary_expression {
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			$<symbolinfo>$->id_value=$<symbolinfo>1->id_value;
			}
     |  term MULOP unary_expression { 
			
			$<symbolinfo>$=new SymbolInfo();
			
			if($<symbolinfo>2->get_name()=="*"){
				if($<symbolinfo>1->get_declaredtype()=="float"||$<symbolinfo>3->get_declaredtype()=="float"){
					$<symbolinfo>$->set_declaredtype("float");
				}
				else if($<symbolinfo>1->get_declaredtype()=="int" && $<symbolinfo>3->get_declaredtype()=="int"){
					$<symbolinfo>$->set_declaredtype("int");
				}
				string asmcodes=$<symbolinfo>1->code+$<symbolinfo>3->code;
				 char *temp=newTemp();
				 asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
				 asmcodes+="\tMOV BX,"+$<symbolinfo>3->id_value+"\n";
				 asmcodes+="\tIMUL BX\n";
				 asmcodes+="\tMOV "+string(temp)+",AX\n";
				 $<symbolinfo>$->code=asmcodes;
				$<symbolinfo>$->id_value=string(temp);
				variable_declared_list.push_back(string(temp));
				temp_list.push_back(string(temp));
			}
			
			else if($<symbolinfo>2->get_name()=="/"){
 				if($<symbolinfo>1->get_declaredtype()=="float"||$<symbolinfo>3->get_declaredtype()=="float"){
					$<symbolinfo>$->set_declaredtype("float"); 
				}
				else if($<symbolinfo>1->get_declaredtype()=="int" && $<symbolinfo>3->get_declaredtype()=="int"){
					$<symbolinfo>$->set_declaredtype("int");
				}
				string asmcodes=$<symbolinfo>1->code+$<symbolinfo>3->code;
				 char *temp=newTemp();
				 asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
				 asmcodes+="\tMOV BX,"+$<symbolinfo>3->id_value+"\n";
				 asmcodes+="\tXOR DX,DX\n";
				 asmcodes+="\tIDIV BX\n";
				 asmcodes+="\tMOV "+string(temp)+",AX\n";
				 $<symbolinfo>$->code=asmcodes;
				 $<symbolinfo>$->id_value=string(temp);
				 variable_declared_list.push_back(string(temp));
				temp_list.push_back(string(temp));
			}
			else if($<symbolinfo>2->get_name()=="%"){
				 if($<symbolinfo>1->get_declaredtype()!="int" ||$<symbolinfo>3->get_declaredtype()!="int"){
					 error_count++;
					fprintf(logout,"Error at Line No.%d :  Integer operand on modulus operator  \n\n",line_count);

				 }  
			$<symbolinfo>$->set_declaredtype("int");
			string asmcodes=$<symbolinfo>1->code+$<symbolinfo>3->code;
			char *temp=newTemp();
			asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
			asmcodes+="\tMOV BX,"+$<symbolinfo>3->id_value+"\n";
			asmcodes+="\tMOV DX,0\n";
			asmcodes+="\tIDIV BX\n";
			asmcodes+="\tMOV "+string(temp)+",DX\n";
			$<symbolinfo>$->code=asmcodes;
			$<symbolinfo>$->id_value=string(temp);
			variable_declared_list.push_back(string(temp));
			temp_list.push_back(string(temp));
			}
			else if($<symbolinfo>1->get_declaredtype()=="void" || $<symbolinfo>3->get_declaredtype()=="void"){
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
					$<symbolinfo>$->set_declaredtype("int");
				}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name()+$<symbolinfo>3->get_name());
			}
     ;

unary_expression : ADDOP unary_expression  {
			
			$<symbolinfo>$=new SymbolInfo(); 
			if($<symbolinfo>2->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(logout,"Error at line no.%d : Type Mismatch\n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int");
			}else
			{
				string asmcodes=$<symbolinfo>2->code;
				if($<symbolinfo>1->get_name()=="-"){
					asmcodes+="\tMOV AX,"+$<symbolinfo>2->id_value+"\n";
					asmcodes+="\tNEG AX\n";
					asmcodes+="\tMOV "+$<symbolinfo>2->id_value+",AX\n";

				}
			$<symbolinfo>$->code=asmcodes;
			$<symbolinfo>$->id_value=$<symbolinfo>2->id_value;
			$<symbolinfo>$->set_declaredtype($<symbolinfo>2->get_declaredtype());
			}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name());
			}
		 | NOT unary_expression {
			
			$<symbolinfo>$=new SymbolInfo(); 
			if($<symbolinfo>2->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(logout,"Error at line no.%d : Type Mismatch\n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int");
			}else
			{
				string asmcodes=$<symbolinfo>2->code;
				
				asmcodes+="\tMOV AX,"+$<symbolinfo>2->id_value+"\n";
				asmcodes+="\tNOT AX\n";
				asmcodes+="\tMOV "+$<symbolinfo>2->id_value+",AX\n";
				$<symbolinfo>$->code=asmcodes;
				$<symbolinfo>$->id_value=$<symbolinfo>2->id_value;
				$<symbolinfo>$->set_declaredtype("int");
			}
			$<symbolinfo>$->set_name($<symbolinfo>2->get_name());
			}
		 | factor { 
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype()); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			$<symbolinfo>$->id_value=$<symbolinfo>1->id_value;
			}
		 ;
	
factor	: variable {
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			string asmcodes=$<symbolinfo>1->code;
					if($<symbolinfo>1->get_type()=="array"){
						char *temp=newTemp();
						asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"[BX]\n";
						asmcodes+="\tMOV "+string(temp)+",AX\n";
						variable_declared_list.push_back(string(temp));
						temp_list.push_back(string(temp));
						$<symbolinfo>$->id_value=string(temp);

					}
					else if($<symbolinfo>1->get_type()=="notarray"){
						$<symbolinfo>$->id_value=$<symbolinfo>1->id_value;

					}

					$<symbolinfo>$->code=asmcodes;
			}
	| ID LPAREN argument_list RPAREN  { 
			
			$<symbolinfo>$=new SymbolInfo(); 
			SymbolInfo* si=s.table_Lookup($<symbolinfo>1->get_name());
			for(int i=0;i<function_variable_declared_list.size();i++){
					si->add_variable(function_variable_declared_list[i]);
				}
				function_variable_declared_list.clear();
			if(si==NULL)
			{
				error_count++;
				fprintf(logout,"Error at Line No.%d :  Undefined Function \n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int"); 
			}
			else if(si->para_name.size()==0 && si->return_type=="" && si->para_type.size()==0)
			{
				error_count++;
				fprintf(logout,"Error at Line No.%d :  Not A Function \n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int");
			}
			else 
			{
				if(si->defined==false)
				{
				error_count++;
				fprintf(logout,"Error at Line No.%d :  Undefined Function \n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int");
				}
				
			    int n=si->para_name.size();
				$<symbolinfo>$->set_declaredtype(si->return_type);
				
				if(n==argument_list.size())
				{
					string asmcodes=$<symbolinfo>3->code;
					int w=0;
				while(w<si->para_name.size()){
					asmcodes+="\tPUSH "+si->para_name[w]+"\n";
					w++;
				}

				int y=0;
				while(y<si->func_variable_list.size()){
					asmcodes+="\tPUSH "+si->func_variable_list[y]+"\n";
					y++;
				}	
				
				int w1=0;
				while(w1<temp_list.size()){
					
					asmcodes+="\tPUSH "+temp_list[w1]+"\n";
					w1++;
				}	
					int i=0;
					while(i<argument_list.size())
					{
						asmcodes+="\tMOV AX,"+argument_list[i]->id_value+"\n";
						asmcodes+="\tMOV "+si->para_name[i]+",AX\n";
						if(si->para_type[i]!=argument_list[i]->get_declaredtype())
						{
							error_count++;
							fprintf(logout,"Error at Line No.%d :  Parameter Type Mismatch. \n\n",line_count);
							break;
						}
						i++;
					}
					asmcodes+="\tCALL "+$<symbolinfo>1->get_name()+"\n";
					int k1=temp_list.size()-1;
				while(k1>=0){
					
					asmcodes+="\tPOP "+temp_list[k1]+"\n";

					k1--;
				}
				int l=si->func_variable_list.size()-1;
				while(l>=0){
					asmcodes+="\tPOP "+si->func_variable_list[l]+"\n";
					l--;
				}
					int k=si->para_name.size()-1;
				while(k>=0){
					asmcodes+="\tPOP "+si->para_name[k]+"\n";

					k--;
				}

								
					asmcodes+="\tMOV AX,"+$<symbolinfo>1->get_name()+"_return\n";
					char *temp=newTemp();
					asmcodes+="\tMOV "+string(temp)+",AX\n";
					$<symbolinfo>$->code=asmcodes;
					$<symbolinfo>$->id_value=string(temp);
					variable_declared_list.push_back(string(temp));
					temp_list.push_back(string(temp));
				}else
				{
					error_count++;
					fprintf(logout,"Error at Line No.%d :  Invalid number of Arguments. \n\n",line_count);
					
				}

			
			}
			argument_list.clear();
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"("+$<symbolinfo>3->get_name()+")");
			}
	| LPAREN expression RPAREN {
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>2->get_declaredtype());
			$<symbolinfo>$->set_name("("+$<symbolinfo>2->get_name()+")");
			$<symbolinfo>$->code=$<symbolinfo>2->code;
			$<symbolinfo>$->id_value=$<symbolinfo>2->id_value;
			}
	| CONST_INT  {
			
			$<symbolinfo>$=new SymbolInfo();  
			$<symbolinfo>$->set_declaredtype("int");
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			char *t=newTemp();
			string asmcodes="\tMOV "+string(t)+","+$<symbolinfo>1->get_name()+"\n";
			$<symbolinfo>$->code=asmcodes;
			$<symbolinfo>$->id_value=string(t);
			variable_declared_list.push_back(string(t));
			temp_list.push_back(string(t));
		/*	stringstream geek($<symbolinfo>1->get_name());
			int x=0;
			geek >> x; 
			if((array_size-1)< x)
			{
				error_count++;
				fprintf(logout,"Error at Line No. %d : Indexing out of array size\n\n",line_count);
			}*/
			}
	| CONST_FLOAT  { 
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype("float");
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			char *t=newTemp();
			string asmcodes="\tMOV "+string(t)+","+$<symbolinfo>1->get_name()+"\n";
			$<symbolinfo>$->code=asmcodes;
			$<symbolinfo>$->id_value=string(t);
			variable_declared_list.push_back(string(t));
			temp_list.push_back(string(t));
			}
	| variable INCOP {
			
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"++");
			string asmcodes="";
			char *t=newTemp();
			if($<symbolinfo>1->get_type()=="array"){
				asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"[BX]\n";
				asmcodes+="\tMOV "+string(t)+",AX\n";
				asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"[BX]\n";
				asmcodes+="\tINC AX\n";
				asmcodes+="\tMOV "+$<symbolinfo>1->id_value+"[BX],AX\n";
			}
			else{
				asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
				asmcodes+="\tMOV "+string(t)+",AX\n";
				asmcodes+="\tINC "+$<symbolinfo>1->id_value+"\n";
			}
			variable_declared_list.push_back(string(t));
			temp_list.push_back(string(t));
			$<symbolinfo>$->code=asmcodes;
			$<symbolinfo>$->id_value=string(t);
			}
	| variable DECOP {
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"--");
			string asmcodes="";
			char *t=newTemp();
			if($<symbolinfo>1->get_type()=="array"){
				asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"[BX]\n";
				asmcodes+="\tMOV "+string(t)+",AX\n";
				asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"[BX]\n";
				asmcodes+="\tDEC AX\n";
				asmcodes+="\tMOV "+$<symbolinfo>1->id_value+"[BX],AX\n";
			}
			else{
				asmcodes+="\tMOV AX,"+$<symbolinfo>1->id_value+"\n";
				asmcodes+="\tMOV "+string(t)+",AX\n";
				asmcodes+="\tDEC "+$<symbolinfo>1->id_value+"\n";
			}
			variable_declared_list.push_back(string(t));
			temp_list.push_back(string(t));
			$<symbolinfo>$->code=asmcodes;
			$<symbolinfo>$->id_value=string(t);
			}
	| LPAREN expression error { error_count++;
				}
	;
	
argument_list : arguments  { 
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			}
		|%empty	{ 
			
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name("");
			}
		;
	
arguments : arguments COMMA logic_expression { 
			 
			$<symbolinfo>$=new SymbolInfo();
			argument_list.push_back($<symbolinfo>3);
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+","+$<symbolinfo>3->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code+$<symbolinfo>3->code;
			}
	      | logic_expression{
			
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>1->get_name());
			p->set_type($<symbolinfo>1->get_type());
			p->set_declaredtype($<symbolinfo>1->get_declaredtype());
			//argument_list.push_back(p);
			argument_list.push_back($<symbolinfo>1);
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			$<symbolinfo>$->code=$<symbolinfo>1->code;
			}
	      ;
%%



void optimization(FILE *asmcode){
	bool b=false;
	FILE* optcode= fopen("1605006_optcode.asm","w");
	char*  line;
    size_t len = 0;
    ssize_t read;
	vector<string>v;
    while ((read = getline(&line, &len, asmcode)) != -1){
	//while(getline(asmcode,line)){
	
	if(string(line)!=""){
       
	
	   v.push_back(string(line));}
    }
	int sizes=v.size();
	int m[sizes];
	for(int i=0;i<sizes;i++) 
		m[i]=1;
	for(int i=0;i<sizes-1;i++){
		if(v[i].size()!=v[i+1].size()){
			b=false;
		}
	else{
	string source1="";
	string source2="";
	string destination1="";
	string destination2="";
	vector<string>tokens1;
	vector<string>tokens2;
	vector<string>tokens3;
	vector<string>tokens4;
	istringstream check1(v[i]);
	string in;
	while(getline(check1,in,' ')){
		tokens1.push_back(in);
	}
	istringstream check3(v[i+1]);
	while(getline(check3,in,' ')){
		tokens3.push_back(in);
	}
	if(tokens1[0]=="	MOV"&&tokens3[0]=="	MOV"){
	istringstream check2(tokens1[1]);
	while(getline(check2,in,',')){
		tokens2.push_back(in);
	}
	
	istringstream check4(tokens3[1]);
	while(getline(check4,in,',')){
		tokens4.push_back(in);
	}
	source1=tokens2[1];
	source2=tokens4[1];
	destination1=tokens2[0];
	destination2=tokens4[0];
	
	//cout<<source1<<destination2<<endl;
	//cout<<source2<<destination1<<endl;
	int n1=source1.length();
	int n2=source2.length();
	int n3=destination1.length();
	int n4=destination2.length();
	char arr1[n1+1];
	char arr2[n2+1];
	char arr3[n3+1];
	char arr4[n4+1];
	char arr5[n1+1];
	char arr6[n2+1];
	strcpy(arr1,source1.c_str());
	strcpy(arr2,source2.c_str());
	strcpy(arr3,destination1.c_str());
	strcpy(arr4,destination2.c_str());
	for(int k=0,j=0;k<=n1;k++){
		if(arr1[k]=='\n') continue;
		arr5[j++]=arr1[k];
	}
	for(int k=0,i=0;k<=n2;k++){
		if(arr2[k]=='\n') continue;
		arr6[i++]=arr2[k];
	}
	
	if(strcmp(arr5,arr4)==0 && strcmp(arr6,arr3)==0){
	//if(source1==destination2 && source2==destination1){ 
		b=true;
		//return true;
		
	}else {b=false; }
}
else{
	b=false;}
	}

		if(b==true){
			m[i+1]=0;
		}
	}
	for(int i=0;i<sizes;i++){
		if(m[i]==1)
		fprintf(optcode,"%s",v[i].c_str());
	}

	fclose(asmcode);
	fclose(optcode);
    if (line)
        free(line);

}



int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		return 0;
	}
	yyin=fp;
	s.Enter_Scope(logout);
	yyparse();
	
	//fprintf(logout," Symbol Table : \n\n");
	//s.print_all_scopeTable(logout);
	fprintf(logout,"Total Lines : %d \n\n",line_count);
	fprintf(logout,"Total Errors : %d \n\n",error_count);
	//fprintf(error,"Total Errors : %d \n\n",error_count);

	fclose(fp);
	fclose(logout);
	//fclose(error);

	return 0;
}


