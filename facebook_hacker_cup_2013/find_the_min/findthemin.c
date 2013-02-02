//This program use linked list in C

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TRUE 1
#define FALSE 0

struct node {
    long val;
    struct node *next;
};

void print_arr(node* list,long size){
	long i;
	node * n;
	n = list;
	printf("[");
	for(i=0;i<size;i++){
		if(i<size-1)
			printf(" %ld,",n->val);
		else
			printf(" %ld",n->val);
		n = n->next;
	}
	printf("]\n");
}

node* generate_k(long a,long b,long c,long r,long k){
	long i;
	long m;
	node * k_list;
	node * n,*temp;
	m=a;
	k_list = n = (node *) malloc(sizeof(node));
	n->val = m;
	n->next = 0;
	for(i=1;i<k;i++){
		temp = (node *) malloc(sizeof(node));
		temp->val = m = (b*m+c)%r;
		temp->next = 0;
		n->next = temp;
		n = temp;
	}
	return k_list;
}

char contains(long val, node* list, long size){
	long i;
	node * n;
	n = list;
	for(i=0;i<size;i++){
		if(n->val == val)
			return TRUE;
		n = n->next;
	}
	return FALSE;
}

node* get_tail(node* list, long size){
	long i;
	node* n;
	n = list;
	for(i=1;i<size;i++){
		n = n->next;
	}
	return n;
}

node* solve(node* k_list, long a,long b,long c,long r,long k, long n){
	long output=-1;
	long removed=-1;
	long index=0;
	long rounds = n-k;
	long round_index;
	node* t;
	node* tail;
	long i;

	tail = get_tail(k_list,k);

	for(round_index=0;round_index<rounds;round_index++){

		if(output==-1){	//if first round
			index=0;
		}else{
			//not the first round, 
			//the list has been appended by "output"
			//and it has removed the value "removed" from the list
			if(removed<output){	
				//if the removed value is lower than the new one
				//we can start enumerating from the removed value,
				//unless, there are many of "removed" value left in the list
				if(contains(removed,k_list,k)==TRUE)
					//if the list still has a duplicated removed value,
					// starts from the last appended value (output)
					index=output+1;
				else
					//start from the lower one, which is the removed value
					index=removed;
			}else{
				//if removed value >= output, the removed value does not matter now.
				//start the enumeration from the last appended value(output)
				index=output+1;
			}
		}

		while(contains(index,k_list,k)==TRUE){
			index++;
		}
		output = index;

		//append new node
		t = (node*) malloc(sizeof(node));
		t->val = output;
		t->next = 0;
		tail->next = t;
		tail = t;

		//remove first one
		removed = k_list->val;
		t = k_list;
		k_list = k_list->next;
		free(t);
	
		//printf("K..%p\n",k_list);
	}

	return k_list;
}

void clean_list(node* list, long size){
	long i;
	node* n;

	for(i=0;i<size;i++){
		n = list;
		list = list->next;
		//printf("cleaning..%p\n",n);
		free(n);
	}
}

int main(int argc, char** argv){
	int cases, case_no;
	long a, b, c, r, k, n;
	node* k_list, *tail;
	long output;
	float start_time, end_time;
	char* filename = "sample.txt";
	if(argc>=2){
		filename = argv[1];
	}

	FILE* infile = fopen(filename,"r");
	FILE* outfile = fopen("out.txt","w");
	fscanf(infile,"%d",&cases);
	for(case_no=1;case_no<=cases;case_no++){
		//input
		fscanf(infile,"%ld %ld",&n,&k);
		fscanf(infile,"%ld %ld %ld %ld",&a,&b,&c,&r);
		printf("Case #%d: %ld/%ld: %ld %ld %ld %ld\n",case_no,k,n,a,b,c,r);
		start_time = (float) clock()/CLOCKS_PER_SEC;

		//generate first k-values
		k_list = generate_k(a,b,c,r,k);
		//print_arr(k_list,k);

		//execution
		k_list = solve(k_list, a, b, c, r, k, n);
		tail=get_tail(k_list,k);
		output = tail->val;
		//print_arr(k_list,k);

		//post-execution
		clean_list(k_list,k);
		end_time = (float) clock()/CLOCKS_PER_SEC;
		printf("Case #%d: Output: %ld\n",case_no,output);
		fprintf(outfile,"Case #%d: %ld\n",case_no,output);
		printf("Time %f sec\n",end_time-start_time);
	}
	fclose(infile);
	fclose(outfile);

	return 0;
}