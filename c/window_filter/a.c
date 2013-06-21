#include <stdio.h>
#include <stdlib.h>

typedef struct{
	int position;
	int width;
} filter;

/*
void sort(filter* filters,int n){
	filter temp;
	int i,j;
	for(i=0;i<n;i++){
		for(j=0;j<i;j++){
			if(filters[j].position>filters[j+1].position){
				temp = filters[j];
				filters[j] = filters[j+1];
				filters[j+1] = temp;
			}
		}
	}
}
*/

int sort(int *positions, char* parentheses, int n){
	int i,j,temp;
	char temp_char;
	for(i=0;i<n;i++){
		for(j=0;j<n;j++){
			if(positions[j]>positions[j+1]){
				temp = positions[j];
				positions[j] = positions[j+1];
				positions[j+1] = temp;

				temp_char = parentheses[j];
				parentheses[j] = parentheses[j+1];
				parentheses[j+1] = temp_char;
			}
		}
	}
	return n*2;
}

void convert(filter* filters,int n,int *positions,char *parentheses){
	int i=0;
	for(i=0;i<n;i++){
		parentheses[i*2] = '[';
		parentheses[i*2+1] = ']';
		positions[i*2] = filters[i].position;
		positions[i*2+1] = filters[i].position+filters[i].width;
	}
}

void print_arr(int *positions, char* parentheses, int n){
	int i;
	for(i=0;i<n;i++){
		printf("%3d",positions[i]);
	}
	printf("\n");
	for(i=0;i<n;i++){
		printf("%3c",parentheses[i]);
	}
	printf("\n");

}


int main(int argc, char** argv){
	int w,h,n,i,x,a;
	int num_layers=0;
	int *positions;
	char *parentheses;
	int area_clear=0, area_filtered=0;
	filter *filters;
	FILE* f;
	f = fopen("input.txt","r");
	fscanf(f,"%d %d %d",&w,&h,&n);
	printf("%d %d %d\n",w,h,n);
	filters = (filter*) malloc(n*sizeof(filter));
	for(i=0;i<n;i++){
		fscanf(f,"%d %d",&x,&a);
		filters[i].position = x;
		filters[i].width = a;
	}
	fclose(f);

	//sort(filters,n);
	positions = (int*) malloc(n*2*sizeof(int));	
	parentheses = (char*) malloc(n*2*sizeof(char));
	convert(filters,n,positions,parentheses);
	//print_arr(positions,parentheses,n*2);	

	sort(positions,parentheses,n*2);

	print_arr(positions,parentheses,n*2);	

		
	//before
	num_layers=0;
	if(positions[0]>0){
		area_clear+=positions[0] * h;
		printf("layers %d: clear=%d\n",num_layers,area_clear);
	}

	//between
	for(i=0;i<n*2-1;i++){
		//only works with bracket in window area
		if(positions[i]>w) break;

		if(parentheses[i]=='['){
			num_layers++;
		}else{
			num_layers--;
		}

		//only continue below when no continuous parentheses
		if(i!=n*2-1 
				&& parentheses[i+1]==parentheses[i]
				&& positions[i+1]==positions[i]) continue;

		if(num_layers==0){
			if(i!=n*2-1 && positions[i+1]<w){ //if not the last one
				area_clear += (positions[i+1]-positions[i]) * h;
			}else{
				area_clear+=(w-positions[n*2-1]) * h;
			}
			printf("layers %d: clear=%d\n",num_layers,area_clear);
		}else if(num_layers==1){
			if(i!=n*2-1 && positions[i+1]<w){ //if not the last one
				area_filtered += (positions[i+1]-positions[i]) * h;
			}else{
				area_filtered += (w-positions[i]) * h;
			}
			printf("layers %d: filtered=%d\n",num_layers,area_filtered);
		}
	}
	
	printf("CLEAR=%d filtered=%d\n",area_clear,area_filtered);

	free(filters);
	free(positions);
	free(parentheses);
	return 0;
}
