%error-verbose;
%{
#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<bits/stdc++.h>
#include <fstream>
using namespace std;
class SymbolInfo
{
private:
    string symbolname,symboltype,declaredtype;
public:
    SymbolInfo *next;
	vector<string>para_name;
	vector<string>para_type;
	string return_type;
	
	bool defined;
    SymbolInfo(string name,string type,string dectype="")
    {
        symbolname=name;
        symboltype=type;
		declaredtype=dectype;
        next=NULL;
       
		para_name.clear();
		para_type.clear();
		return_type="";
		defined=false;
    }
    SymbolInfo()
    {
        symbolname = "";
        symboltype = "";
		declaredtype="";
        next=NULL;
		
		para_name.clear();
		para_type.clear();
		return_type="";
		defined=false;
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
using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
FILE *fp;
FILE *error=fopen("1605006_error.txt","w");
FILE *logout= fopen("1605006_log.txt","w");
vector<SymbolInfo*>declared_list;
int line_count=1;
int error_count=0;

SymbolTable s(30);





string ret_Type="void";
int array_size=0;
void yyerror(const char *s)
{
	fprintf(error,"Error at Line no %d : %s\n",line_count-1,s);
}
vector<SymbolInfo*>argument_list;

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
		
	}
	;

program : program unit { 
			fprintf(logout,"Line at %d : program : program unit\n\n",line_count);
			fprintf(logout,"%s%s",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name());
			}

	| unit { 
			fprintf(logout,"Line at %d : program : unit\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	;
	
unit : var_declaration {
			fprintf(logout,"Line at %d : unit : var_declaration\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"\n");
			}
     | func_declaration {
			fprintf(logout,"Line at %d : unit : func_declaration\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"\n");
			}
     | func_definition {
			fprintf(logout,"Line at %d : unit : func_definition\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"\n");
			}
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
			fprintf(logout,"Line at %d : func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n",line_count);
			fprintf(logout,"%s %s(%s);\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str(),$<symbolinfo>4->get_name().c_str()); 
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
					fprintf(error,"Error at Line No. %d : Invalid number of parameters.\n",line_count);
				}
				if(si->return_type!=$<symbolinfo>1->get_name())
				{
					error_count++;
					fprintf(error,"Error at Line No. %d : Return type Mismatch.\n",line_count);
				}
				if(n==parameter_list.size())
				{
					int i=0;
					while(i<parameter_list.size())
					{
						if(si->para_type[i]!=parameter_list[i]->get_declaredtype())
						{
							error_count++;
							fprintf(error,"Error at Line No. %d : Parameter type Mismatch.\n",line_count);	
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
			fprintf(logout,"Line at %d : func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n\n",line_count);
			fprintf(logout,"%s %s();\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str()); 
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
					fprintf(error,"Error at Line No. %d : Return type Mismatch.\n",line_count);
				}
				if(si->para_name.size()!=0)
				{
					error_count++;
					fprintf(error,"Error at Line No. %d : Invalid number of parameters.\n",line_count);
				}
			}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"();");
			}
		| type_specifier ID LPAREN RPAREN error {
			error_count++;
			//printf(error,"Error at Line no. %d : Syntax error\n\n",line_count);
		}
		| type_specifier ID LPAREN parameter_list RPAREN error	{
			error_count++;
			//fprintf(error,"Error at Line no. %d : Syntax error\n\n",line_count);
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN{
			SymbolInfo *si=s.table_Lookup($<symbolinfo>2->get_name());
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
					si->add_parameters(parameter_list[i]->get_name(),parameter_list[i]->get_declaredtype());
					
					i++;
				}
				for(k=0;k<parameter_list.size();k++)
					{
						if(si->para_name[k]=="" || parameter_list[k]->get_name()=="")
						{
							error_count++;
							fprintf(error,"Error at Line No. %d : Missing of parameter's name\n\n",line_count);
							break;
						}
					}
				//parameter_list.clear();
			}
			else if(si->defined==true)
			{
				error_count++;
				fprintf(error,"Error at Line No.%d :  Multiple defination of function %s\n\n",line_count,$<symbolinfo>2->get_name().c_str());
			}
			else if(si->defined==false)
			{
				
				if(si->return_type!=$<symbolinfo>1->get_name())
				{
					error_count++;
					fprintf(error,"Error at Line No.%d :  Return Type Mismatch. \n\n",line_count);
				}
				if(si->para_name.size()!=parameter_list.size())
				{
					
					error_count++;
					fprintf(error,"Error at Line No.%d :  Invalid number of parameters. \n\n",line_count);
				}
				if(si->para_name.size()==parameter_list.size())
				{
					int j,k;
					for(j=0;j<parameter_list.size();j++)
					{
						if(si->para_type[j]!=parameter_list[j]->get_declaredtype())
						{
							error_count++;
							fprintf(error,"Error at Line No. %d : Parameter Type Mismatch\n\n",line_count);
							break;
						}
					}
					for(k=0;k<parameter_list.size();k++)
					{
						if(si->para_name[k]=="" || parameter_list[k]->get_name()=="")
						{
							error_count++;
							fprintf(error,"Error at Line No. %d : Missing of parameter's name\n\n",line_count);
							break;
						}
					}
				}
				//parameter_list.clear();
				si->defined=true;
			}


			//$<symbolinfo>1->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"("+$<symbolinfo>4->get_name()+")");
} compound_statement {
			if(ret_Type!=$<symbolinfo>1->get_name())
			{
				
				error_count++;
				fprintf(error,"Error at Line No. %d : Return Type Mismatch\n",line_count);
				
			}
			ret_Type="void";
			fprintf(logout,"Line at %d : func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n",line_count);
			fprintf(logout,"%s %s(%s)%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str(),$<symbolinfo>4->get_name().c_str(),$<symbolinfo>7->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"("+$<symbolinfo>4->get_name()+")"+$<symbolinfo>7->get_name());
			}
		| type_specifier ID LPAREN RPAREN{
		  	SymbolInfo *si=s.table_Lookup($<symbolinfo>2->get_name());
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
					fprintf(error,"Error at Line No.%d :  Return Type Mismatch. \n\n",line_count);
				}
				if(si->para_name.size()!=0)
				{
					error_count++;
					fprintf(error,"Error at Line No.%d :  Invalid number of parameters. \n\n",line_count);
				}
				si->defined=true;
			}
			else if(si->defined==true)
			{
				error_count++;
				fprintf(error,"Error at Line No.%d :  Multiple defination of function %s\n\n",line_count,$<symbolinfo>2->get_name().c_str());
			}


		 // $<symbolinfo>1->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"()");
		} compound_statement {
			if(ret_Type!=$<symbolinfo>1->get_name())
			{
				
				error_count++;
				fprintf(error,"Error at Line No. %d : Return Type Mismatch\n",line_count);
				
			}
			ret_Type="void";
			fprintf(logout,"Line at %d : func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n",line_count);
			fprintf(logout,"%s %s()%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str(),$<symbolinfo>6->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();

			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+"()"+$<symbolinfo>6->get_name());
			}
		/*| 	type_specifier ID LPAREN RPAREN error {
			
		}
		|	type_specifier ID LPAREN parameter_list RPAREN error	{

		}*/
 		;				


parameter_list  : parameter_list COMMA type_specifier ID {
			fprintf(logout,"Line at %d : parameter_list : parameter_list COMMA type_specifier ID\n\n",line_count);
			fprintf(logout,"%s,%s %s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>3->get_name().c_str(),$<symbolinfo>4->get_name().c_str()); 
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
				fprintf(error,"Error at Line No. %d : Redeclaration of parameter\n\n",line_count);
				}
			}
			
			parameter_list.push_back(p);
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+","+$<symbolinfo>3->get_name()+" "+$<symbolinfo>4->get_name());
			}
		| parameter_list COMMA type_specifier {
			fprintf(logout,"Line at %d : parameter_list : parameter_list COMMA type_specifier\n\n",line_count);
			fprintf(logout,"%s,%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>3->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name("");
			p->set_type("ID");
			p->set_declaredtype($<symbolinfo>3->get_name());
			parameter_list.push_back(p);
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+","+$<symbolinfo>3->get_name());
			}
 		| type_specifier ID {
			fprintf(logout,"Line at %d : parameter_list : type_specifier ID\n\n",line_count);
			fprintf(logout,"%s %s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>2->get_name());
			p->set_type("ID");
			p->set_declaredtype($<symbolinfo>1->get_name());
			parameter_list.push_back(p);
			
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name());
			}
		| type_specifier { 
			fprintf(logout,"Line at %d : parameter_list : ID\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
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
				i++;
			}
			parameter_list.clear();

} statements RCURL {
			
			fprintf(logout,"Line at %d : compound_statement : LCURL statements RCURL\n\n",line_count);
			fprintf(logout,"{\n%s\n}\n",$<symbolinfo>3->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name("{\n"+$<symbolinfo>3->get_name()+"\n}");
			s.print_all_scopeTable(logout);
			s.Exit_Scope(logout);
			}
 		    | LCURL RCURL {
			s.Enter_Scope(logout);
			int i=0;
			while(i<parameter_list.size())
			{
				s.table_insertion(parameter_list[i]->get_name(),"ID",parameter_list[i]->get_declaredtype());
				i++;
			}
			
			parameter_list.clear();
			fprintf(logout,"Line at %d : compound_statement : LCURL RCURL\n\n",line_count);
			fprintf(logout,"{}\n\n"); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name("{}");
			s.print_all_scopeTable(logout);
			s.Exit_Scope(logout);
			}
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {
			fprintf(logout,"Line at %d : var_declaration : type_specifier declaration_list SEMICOLON\n\n",line_count);
			fprintf(logout,"%s %s;\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str()); 
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
					fprintf(error,"Error at Line No. %d : Redeclaration of variable : %s\n\n",line_count,declared_list[i]->get_name().c_str());
					 
				} 
               else
			   {
				if(declared_list[i]->get_type()=="IDAR")
				{
					declared_list[i]->set_type("ID");
					s.table_insertion(declared_list[i]->get_name(),declared_list[i]->get_type(),$<symbolinfo>1->get_name()+"array");
				}
				else if(declared_list[i]->get_type()=="ID")
				{
					s.table_insertion(declared_list[i]->get_name(),declared_list[i]->get_type(),$<symbolinfo>1->get_name());
				}}
				i++;
			}
			
			}
			else if($<symbolinfo>1->get_name()=="void")
			{
				error_count++;
				fprintf(error,"Error at Line No.%d : Type specifier of variable can not be void\n\n",line_count);
			}
			declared_list.clear();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+" "+$<symbolinfo>2->get_name()+";");
			}
		|	type_specifier declaration_list error	{
				error_count++;
		}
 		 ;
 		 
type_specifier	: INT {
			fprintf(logout,"Line at %d : type_specifier : INT\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
 		| FLOAT {
			fprintf(logout,"Line at %d : type_specifier : FLOAT\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
 		| VOID {
			fprintf(logout,"Line at %d : type_specifier : VOID\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
 		;
 		
declaration_list : declaration_list COMMA ID { 
			fprintf(logout,"Line at %d : declaration_list : declaration_list COMMA ID\n\n",line_count);
			fprintf(logout,"%s,%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>3->get_name().c_str());
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
			fprintf(logout,"Line at %d : declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n",line_count);
			fprintf(logout,"%s,%s[%s]\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>3->get_name().c_str(),$<symbolinfo>5->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>3->get_name());
			p->set_type("IDAR");
			p->set_declaredtype("");
			declared_list.push_back(p);
			//declared_list.push_back(new SymbolInfo($<symbolinfo>3->get_name(),"IDAR"));
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+","+$<symbolinfo>3->get_name()+"["+$<symbolinfo>5->get_name()+"]");
			}
 		  | ID {
			fprintf(logout,"Line at %d : declaration_list : ID\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str());
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
			fprintf(logout,"Line at %d : declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n",line_count);
			fprintf(logout,"%s[%s]\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>3->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			stringstream geek($<symbolinfo>3->get_name());
			int x=0;
			geek >> x; 
			array_size=x;
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>1->get_name());
			p->set_type("IDAR");
			p->set_declaredtype("");
			declared_list.push_back(p);
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"["+$<symbolinfo>3->get_name()+"]");
			}
 		  ;
 		  
statements : statement { 
			fprintf(logout,"Line at %d : statements : statement\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	   | statements statement { 
			fprintf(logout,"Line at %d : statements : statements statement\n\n",line_count);
			fprintf(logout,"%s\n%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"\n"+$<symbolinfo>2->get_name());
			}
	   ;
	   
statement : var_declaration {
			fprintf(logout,"Line at %d : statement : var_declaration\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	  | expression_statement {
			fprintf(logout,"Line at %d : statement : expression_statement\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	  | compound_statement {
			fprintf(logout,"Line at %d : statement : compound_statement\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement  { 
			fprintf(logout,"Line at %d : statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n",line_count);
			fprintf(logout,"for(%s%s%s)\n%s\n\n",$<symbolinfo>3->get_name().c_str(),$<symbolinfo>4->get_name().c_str(),$<symbolinfo>5->get_name().c_str(),$<symbolinfo>7->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(error,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			$<symbolinfo>$->set_name("for("+$<symbolinfo>3->get_name()+$<symbolinfo>4->get_name()+$<symbolinfo>5->get_name()+")\n"+$<symbolinfo>7->get_name());
			}	
	  | IF LPAREN expression RPAREN statement %prec THAN { 
			fprintf(logout,"Line at %d : statement : IF LPAREN expression RPAREN statement\n\n",line_count);
			fprintf(logout,"if(%s)\n%s\n\n",$<symbolinfo>3->get_name().c_str(),$<symbolinfo>5->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo(); 
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(error,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			$<symbolinfo>$->set_name("if("+$<symbolinfo>3->get_name()+")\n"+$<symbolinfo>5->get_name());
			}	
	  | IF LPAREN expression RPAREN statement ELSE statement {
			fprintf(logout,"Line at %d : statement : IF LPAREN expression RPAREN statement ELSE statement\n\n",line_count);
			fprintf(logout,"if(%s)\n%s\n else\n%s\n\n",$<symbolinfo>3->get_name().c_str(),$<symbolinfo>5->get_name().c_str(),$<symbolinfo>7->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(error,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			$<symbolinfo>$->set_name("if("+$<symbolinfo>3->get_name()+")\n"+$<symbolinfo>5->get_name()+"\n else\n"+$<symbolinfo>7->get_name());
			}	
	  | WHILE LPAREN expression RPAREN statement  { 
			fprintf(logout,"Line at %d : statement : WHILE LPAREN expression RPAREN statement\n\n",line_count);
			fprintf(logout,"while(%s)\n%s\n\n",$<symbolinfo>3->get_name().c_str(),$<symbolinfo>5->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(error,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			$<symbolinfo>$->set_name("while("+$<symbolinfo>3->get_name()+")\n"+$<symbolinfo>5->get_name());
			}	
	  | PRINTLN LPAREN ID RPAREN SEMICOLON {
			fprintf(logout,"Line at %d : statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n",line_count);
			fprintf(logout,"\n(%s);\n\n",$<symbolinfo>3->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name("\n("+$<symbolinfo>3->get_name()+");");
			}
	  | RETURN expression SEMICOLON {
			fprintf(logout,"Line at %d : statement : RETURN expression SEMICOLON\n\n",line_count);
			fprintf(logout,"return %s;\n\n",$<symbolinfo>2->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>2->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(error,"Error at Line No. %d : Type Mismatch\n",line_count);
			}
			ret_Type=$<symbolinfo>2->get_declaredtype();
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
			fprintf(logout,"Line at %d : expression_statement : SEMICOLON\n\n",line_count);
			fprintf(logout,";\n\n"); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name(";");
			}		
			| expression SEMICOLON {
			fprintf(logout,"Line at %d : expression_statement : expression SEMICOLON\n\n",line_count);
			$<symbolinfo>$=new SymbolInfo();
			fprintf(logout,"%s;\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+";");
			
			}
			| error	{
				error_count++;
			}
			| expression error	{
				error_count++;
			}
			;
	  
variable : ID 	{ 
			fprintf(logout,"Line at %d : variable : ID\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo* si=s.table_Lookup($<symbolinfo>1->get_name());
			if(si==NULL)
			{
				error_count++;
				fprintf(error,"Error at Line No. %d : Undeclared variable %s\n",line_count,$<symbolinfo>1->get_name().c_str());
			}
			else if(si)
			{
				$<symbolinfo>$->set_declaredtype(si->get_declaredtype());
				if(si->get_declaredtype()=="intarray" || si->get_declaredtype()=="floatarray")
				{
				error_count++;
				fprintf(error,"Error at Line No.%d : %s was declared as an array \n\n",line_count,$<symbolinfo>1->get_name().c_str());
				}
			}
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}	
	 | ID LTHIRD expression RTHIRD { 
			fprintf(logout,"Line at %d : variable : ID LTHIRD expression RTHIRD\n\n",line_count);
			fprintf(logout,"%s[%s]\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>3->get_name().c_str());
		    $<symbolinfo>$=new SymbolInfo();

			SymbolInfo* si=s.table_Lookup($<symbolinfo>1->get_name());
			if(si==NULL)
			{
				error_count++;
				fprintf(error,"Error at Line No. %d : Undeclared variable %s\n",line_count,$<symbolinfo>1->get_name().c_str());
			}
			else if(si)
			{
				
				if($<symbolinfo>3->get_declaredtype()!="int")
				{
					error_count++;
					fprintf(error,"Error at Line No.%d :  Non-integer Array Index  \n",line_count);
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
					fprintf(error,"Error at Line No.%d : %s is not an Array  \n\n",line_count,si->get_name().c_str());
				}
				$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
				
			}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"["+$<symbolinfo>3->get_name()+"]");
			}
	 ;
	 
expression : logic_expression	{ 
			fprintf(logout,"Line at %d : expression : logic_expression\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	   | variable ASSIGNOP logic_expression { 
			fprintf(logout,"Line at %d : expression : variable ASSIGNOP logic_expression\n\n",line_count);
			fprintf(logout,"%s=%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>3->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo(); 
			
			
			if($<symbolinfo>3->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(error,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
			    $<symbolinfo>$->set_declaredtype("int");
			}
			
			else if($<symbolinfo>1->get_declaredtype()!="")
				{
					
					

					if($<symbolinfo>1->get_declaredtype()!=$<symbolinfo>3->get_declaredtype())
					{
						error_count++;
						fprintf(error,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
						
					}
				}
			


			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"="+$<symbolinfo>3->get_name());
			}	
	   ;
			
logic_expression : rel_expression { 
			fprintf(logout,"Line at %d : logic_expression : rel_expression\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}	
		 | rel_expression LOGICOP rel_expression { 
			fprintf(logout,"Line at %d :logic_expression : rel_expression LOGICOP rel_expression\n\n",line_count);
			fprintf(logout,"%s%s%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str(),$<symbolinfo>3->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>1->get_declaredtype()=="void" || $<symbolinfo>3->get_declaredtype()=="void")
			{
					error_count++;
					fprintf(error,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
					$<symbolinfo>$->set_declaredtype("int");
				}
			$<symbolinfo>$->set_declaredtype("int");
		/*	else if($<symbolinfo>1->get_declaredtype()=="float" || $<symbolinfo>3->get_declaredtype()=="float")
			{
				$<symbolinfo>$->set_declaredtype("float");
			}
			else if($<symbolinfo>1->get_declaredtype()=="int" && $<symbolinfo>3->get_declaredtype()=="int"){
					$<symbolinfo>$->set_declaredtype("int");
				}*/
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name()+$<symbolinfo>3->get_name());
			}	
		 ;
			
rel_expression	: simple_expression {
			fprintf(logout,"Line at %d : rel_expression : simple_expression\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
		| simple_expression RELOP simple_expression { 
			fprintf(logout,"Line at %d : rel_expression : simple_expressiont RELOP simple_expression\n\n",line_count);
			fprintf(logout,"%s%s%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str(),$<symbolinfo>3->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>1->get_declaredtype()=="void" || $<symbolinfo>3->get_declaredtype()=="void"){
					error_count++;
					fprintf(error,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
					$<symbolinfo>$->set_declaredtype("int");
				}
			$<symbolinfo>$->set_declaredtype("int");
			
		/*	else if($<symbolinfo>1->get_declaredtype()=="float" || $<symbolinfo>3->get_declaredtype()=="float")
			{
				$<symbolinfo>$->set_declaredtype("float");
			}
			else if($<symbolinfo>1->get_declaredtype()=="int" && $<symbolinfo>3->get_declaredtype()=="int"){
					$<symbolinfo>$->set_declaredtype("int");
				}*/
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name()+$<symbolinfo>3->get_name());
			}	
		;
				
simple_expression : term { 
			fprintf(logout,"Line at %d : simple_expression : term\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
		  | simple_expression ADDOP term { 
			fprintf(logout,"Line at %d : simple_expression : simple_expression ADDOP term\n\n",line_count);
			fprintf(logout,"%s%s%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str(),$<symbolinfo>3->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			if($<symbolinfo>1->get_declaredtype()=="float" || $<symbolinfo>3->get_declaredtype()=="float")
			{
				$<symbolinfo>$->set_declaredtype("float");
			}
			else if($<symbolinfo>1->get_declaredtype()=="int" && $<symbolinfo>3->get_declaredtype()=="int"){
					$<symbolinfo>$->set_declaredtype("int");
				}
			else if($<symbolinfo>1->get_declaredtype()=="void" || $<symbolinfo>3->get_declaredtype()=="void"){
					error_count++;
					fprintf(error,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
					$<symbolinfo>$->set_declaredtype("int");
				}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name()+$<symbolinfo>3->get_name());
			}
		  ;
					
term :	unary_expression {
			fprintf(logout,"Line at %d : term : unary_expression\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
     |  term MULOP unary_expression { 
			fprintf(logout,"Line at %d : term : term MULOP unary_expression\n\n",line_count);
			fprintf(logout,"%s%s%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str(),$<symbolinfo>3->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo();
			
			if($<symbolinfo>2->get_name()=="*"){
				if($<symbolinfo>1->get_declaredtype()=="float"||$<symbolinfo>3->get_declaredtype()=="float"){
					$<symbolinfo>$->set_declaredtype("float");
				}
				else if($<symbolinfo>1->get_declaredtype()=="int" && $<symbolinfo>3->get_declaredtype()=="int"){
					$<symbolinfo>$->set_declaredtype("int");
				}
			}
			
			else if($<symbolinfo>2->get_name()=="/"){
 				if($<symbolinfo>1->get_declaredtype()=="float"||$<symbolinfo>3->get_declaredtype()=="float"){
					$<symbolinfo>$->set_declaredtype("float"); 
				}
				else if($<symbolinfo>1->get_declaredtype()=="int" && $<symbolinfo>3->get_declaredtype()=="int"){
					$<symbolinfo>$->set_declaredtype("int");
				}
			}
			else if($<symbolinfo>2->get_name()=="%"){
				 if($<symbolinfo>1->get_declaredtype()!="int" ||$<symbolinfo>3->get_declaredtype()!="int"){
					 error_count++;
					fprintf(error,"Error at Line No.%d :  Integer operand on modulus operator  \n\n",line_count);
				 }  
			$<symbolinfo>$->set_declaredtype("int");
			}
			else if($<symbolinfo>1->get_declaredtype()=="void" || $<symbolinfo>3->get_declaredtype()=="void"){
					error_count++;
					fprintf(error,"Error at Line No.%d :  Type Mismatch  \n\n",line_count);
					$<symbolinfo>$->set_declaredtype("int");
				}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name()+$<symbolinfo>3->get_name());
			}
     ;

unary_expression : ADDOP unary_expression  {
			fprintf(logout,"Line at %d : unary_expression : ADDOP unary_expression\n\n",line_count);
			fprintf(logout,"%s%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>2->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo(); 
			if($<symbolinfo>2->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(error,"Error at line no.%d : Type Mismatch\n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int");
			}else
			{
				$<symbolinfo>$->set_declaredtype($<symbolinfo>2->get_declaredtype());
			}
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+$<symbolinfo>2->get_name());
			}
		 | NOT unary_expression {
			fprintf(logout,"Line at %d : unary_expression : NOT unary_expression\n\n",line_count);
			fprintf(logout,"!%s\n\n",$<symbolinfo>2->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo(); 
			if($<symbolinfo>2->get_declaredtype()=="void")
			{
				error_count++;
				fprintf(error,"Error at line no.%d : Type Mismatch\n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int");
			}else
			{
				$<symbolinfo>$->set_declaredtype("int");
			}
			$<symbolinfo>$->set_name($<symbolinfo>2->get_name());
			}
		 | factor { 
			fprintf(logout,"Line at %d : unary_expression : factor\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype()); 
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
		 ;
	
factor	: variable {
			fprintf(logout,"Line at %d : factor : variable\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	| ID LPAREN argument_list RPAREN  { 
			fprintf(logout,"Line at %d : factor : ID LPAREN argument_list RPAREN\n\n",line_count);
			fprintf(logout,"%s(%s)\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>3->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo(); 
			SymbolInfo* si=s.table_Lookup($<symbolinfo>1->get_name());
			if(si==NULL)
			{
				error_count++;
				fprintf(error,"Error at Line No.%d :  Undefined Function \n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int"); 
			}
			else if(si->para_name.size()==0 && si->return_type=="" && si->para_type.size()==0)
			{
				error_count++;
				fprintf(error,"Error at Line No.%d :  Not A Function \n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int");
			}
			else 
			{
				if(si->defined==false)
				{
				error_count++;
				fprintf(error,"Error at Line No.%d :  Undefined Function \n\n",line_count);
				$<symbolinfo>$->set_declaredtype("int");
				}
				
			    int n=si->para_name.size();
				$<symbolinfo>$->set_declaredtype(si->return_type);
				
				if(n==argument_list.size())
				{
					int i=0;
					while(i<argument_list.size())
					{
						if(si->para_type[i]!=argument_list[i]->get_declaredtype())
						{
							error_count++;
							fprintf(error,"Error at Line No.%d :  Parameter Type Mismatch. \n\n",line_count);
							break;
						}
						i++;
					}
				}else
				{
					error_count++;
					fprintf(error,"Error at Line No.%d :  Invalid number of Arguments. \n\n",line_count);
					
				}
			
			}
			argument_list.clear();
			
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"("+$<symbolinfo>3->get_name()+")");
			}
	| LPAREN expression RPAREN {
			fprintf(logout,"Line at %d : factor : LPAREN expression RPAREN\n\n",line_count);
			fprintf(logout,"(%s)\n\n",$<symbolinfo>2->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>2->get_declaredtype());
			$<symbolinfo>$->set_name("("+$<symbolinfo>2->get_name()+")");
			}
	| CONST_INT  {
			fprintf(logout,"Line at %d : factor : CONST_INT\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str());
			$<symbolinfo>$=new SymbolInfo();  
			$<symbolinfo>$->set_declaredtype("int");
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
		/*	stringstream geek($<symbolinfo>1->get_name());
			int x=0;
			geek >> x; 
			if((array_size-1)< x)
			{
				error_count++;
				fprintf(error,"Error at Line No. %d : Indexing out of array size\n\n",line_count);
			}*/
			}
	| CONST_FLOAT  { 
			fprintf(logout,"Line at %d : factor : CONST_FLOAT\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype("float");
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	| variable INCOP {
			fprintf(logout,"Line at %d : factor : variable INCOP\n\n",line_count);
			fprintf(logout,"%s++\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo(); 
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"++");
			}
	| variable DECOP {
			fprintf(logout,"Line at %d : factor : variable DECOP\n\n",line_count);
			fprintf(logout,"%s--\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_declaredtype($<symbolinfo>1->get_declaredtype());
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+"--");
			}
	;
	
argument_list : arguments  { 
			fprintf(logout,"Line at %d :argument_list : arguments\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
		|%empty	{ 
			fprintf(logout,"Line at %d : argument_list : \n\n",line_count);
			$<symbolinfo>$=new SymbolInfo();
			$<symbolinfo>$->set_name("");
			}
		;
	
arguments : arguments COMMA logic_expression { 
			fprintf(logout,"Line at %d : arguments : arguments COMMA logic_expression\n\n",line_count);
			fprintf(logout,"%s,%s\n\n",$<symbolinfo>1->get_name().c_str(),$<symbolinfo>3->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			argument_list.push_back($<symbolinfo>3);
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name()+","+$<symbolinfo>3->get_name());
			}
	      | logic_expression{
			fprintf(logout,"Line at %d : arguments : logic_expression\n\n",line_count);
			fprintf(logout,"%s\n\n",$<symbolinfo>1->get_name().c_str()); 
			$<symbolinfo>$=new SymbolInfo();
			SymbolInfo *p=new SymbolInfo();
			p->set_name($<symbolinfo>1->get_name());
			p->set_type($<symbolinfo>1->get_type());
			p->set_declaredtype($<symbolinfo>1->get_declaredtype());
			argument_list.push_back(p);
		
			$<symbolinfo>$->set_name($<symbolinfo>1->get_name());
			}
	      ;
 

%%
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
	
	fprintf(logout," Symbol Table : \n\n");
	s.print_all_scopeTable(logout);
	fprintf(logout,"Total Lines : %d \n\n",line_count);
	fprintf(logout,"Total Errors : %d \n\n",error_count);
	fprintf(error,"Total Errors : %d \n\n",error_count);

	fclose(fp);
	fclose(logout);
	fclose(error);

	return 0;
}


