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
                cout<<"Found in ScopeTable# "<<this->id<<" at position "<<idx<<", "<<position<<endl;
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
            cout<<"<"<<symbol<<","<<type<<"> already exists in current ScopeTable"<<endl;
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
            cout<<"Inserted in ScopeTable# "<<this->id<<" at position "<<idx<<", 0"<<endl;
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
            cout<<"Inserted in ScopeTable# "<<this->id<<" at position "<<idx<<", "<<position<<endl;
            return true;
        }
    }
    bool deletion(string symbol)
    {
        SymbolInfo *s=look_up(symbol);
        if(s==NULL)
        {
            cout<<symbol<<"not found"<<endl;
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
            cout<<" Deleted entry at "<<idx<<", 0 from current ScopeTable"<<endl;
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
        cout<<" Deleted entry at "<<idx<<","<<position<<" from current ScopeTable"<<endl;

    }
    void print()
    {
        cout<<" ScopeTable #"<<id<<endl;
        SymbolInfo *s;

        for (int i =1; i <=n; i++)
        {
            cout <<" "<< i-1 << " --> ";

            s = hashTable[i-1];

            if(s==NULL)
            {
                cout<<endl;
            }

            else
            {


                while (s!=NULL)
                {
                    //cout<<s->get_type();
                    cout << "<" << s->get_name() << " : " << s->get_type()<< ">  ";

                    s = s->next;
                }

                cout<<endl;
            }
            //delete s;

        }
        cout<<endl;
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
    void Enter_Scope()
    {
        ScopeTable *s=new ScopeTable(n);
        s->set_parentScope(current_scope);
        current_scope=s;
        current_id++;
        s->set_uniqueid(current_id);
        cout<<" New ScopeTable with id "<<current_id<<" created"<<endl;


    }
    void Exit_Scope()
    {
        if(current_id==0)
        {
            cout<<"No Scope Table is found."<<endl;
        }

        ScopeTable *temp=current_scope;
        current_scope=current_scope->get_parentScope();
        cout<<"ScopeTable with id "<<this->current_id<<" removed"<<endl;
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
            cout<<"No Scope Table is Found"<<endl;
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
main()
{
    freopen("input.txt","r",stdin);
   freopen("output.txt","w",stdout);
//    ofstream cout;
//    cout.open("cout1.txt");
    int n;
    cin>>n;
    SymbolTable s(n);

    string str;

    while(cin>>str)
    {
        cout<<str<<" ";
        if(str=="I")
        {
            string name,type;
            cin>>name>>type;
            cout<<name<<" "<<type<<endl<<endl<<" ";
            s.table_insertion(name,type);
        }
        else if(str=="L")
        {
            string name;
            cin>>name;
            cout<<name<<endl<<endl<<" ";

            SymbolInfo* t=s.table_Lookup(name);
            if(t==NULL)
            {
                cout<<name<<"Not Found"<<endl;
            }
        }
        else if(str=="D")
        {
            string name;
            cin>>name;
            cout<<name<<endl<<endl<<" ";

            s.table_remove(name);
        }
        else if(str=="P")
        {
            string name;
            cin>>name;
            cout<<name<<endl<<endl;

            if(name=="A")
            {
                s.print_all_scopeTable();
            }
            else
                s.print_current_scopeTable();
        }
        else if(str=="S")
        {
            cout<<endl<<endl<<" ";

            s.Enter_Scope();

        }
        else if(str=="E")
        {
            cout<<endl<<endl<<" ";

            s.Exit_Scope();

        }
        else
        {
            cout<<endl;
            cout<<"Pls enter the correct word."<<endl;
        }
        cout<<endl;

    }

    return 0;

}
