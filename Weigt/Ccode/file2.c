#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define D 1000
#define L 53 
#define q 21     


int main(void) {
  FILE *fp_1,*fp_2,*fp_3,*fp_4;
  int Data[D][L];
  int n[L][q];
  double omega[L][q];
  int tmp1,tmp2;
  double max[L];
  int i,j,k,a; 
  char c='A';
 
  fp_1=fopen("train.faa","r");
  fp_2=fopen("omega.txt","w");
  fp_3=fopen("max.txt","w");
  fp_4=fopen("data.txt","w");
  
  for(i=0;i<D;i++){
    c='a';
    while(c!='\n' && c!=EOF){
      c=fgetc(fp_1);
    }
    //printf("%d \n",i);
    for(j=0;j<53;j++){
      c=fgetc(fp_1);
      for(k=65;k<90;k++){
	if(k!=66 && k!=74 && k!=79 && k!=85 && k!=88){
	  if(c==k){
	    if(c==65){
	      Data[i][j]=1;
	    }
	    else if(c>65 && c<74){
	      Data[i][j]=c-65;
	    }
	    else if(c>74 && c<79){
	      Data[i][j]=c-66;
	    }
	    else if(c>79 && c<85){
	      Data[i][j]=c-67;
	    }
	    else if(c>85 && c<88){
	      Data[i][j]=c-68;
	    }
	    else{
	      Data[i][j]=20;
	    }
	  }
	}
      }
      if(c=='-'||c=='X'){
	Data[i][j]=q;
      }
    }
    fgetc(fp_1);
  }
  
  
  
  for(j=0;j<L;j++){
    for(a=0;a<q;a++){
      n[j][a]=0;
    }
  }	
  
  for(i=0;i<D;i++){
    for(j=0;j<L;j++){
      fprintf(fp_4,"%d ",Data[i][j]);
    }
    fprintf(fp_4,"\n");
  } 
  

  for(i=0;i<D;i++){
    for(j=0;j<L;j++){
      a=Data[i][j];
      n[j][a-1]++;
    }
  }
  
  for(j=0;j<L;j++){
    tmp1=0;
    for(a=0;a<q;a++){
      tmp1+=n[j][a];
      printf("%d ",n[j][a]);
    }
    printf("%d \n",tmp1);
  }
  
}
/*  
    for(i=0;i<L;i++){
    for(a=0;a<q;a++){
      omega[i][a]=(n[i][a]+1)/(1.0*(D+q));
      printf("%f ",omega[i][a]);
      }
    printf("\n");
  } 
  
  for(i=0;i<L;i++){
    for(j=0;j<q;j++){
      fprintf(fp_2,"%f ",omega[i][j]);
    }
    fprintf(fp_2,"\n");
  } 
 
  for(i=0;i<L;i++){
    max[i]=-1000;
    for(a=0;a<q;a++){
      if(omega[i][a]>max[i])
	max[i]=omega[i][a];
    }
    if(max[i]!=0)
      printf("%d %f \n",i,max[i]);
  }
  
  for(i=0;i<L;i++){
    fprintf(fp_3,"%f ",max[i]);
  }
  
  fprintf(fp_3,"\n");
  
  for(i=0;i<L;i++){
    fprintf(fp_3,"%d ",i+1);
  }
  
  fclose(fp_1);
  fclose(fp_2);
  fclose(fp_3);
  fclose(fp_4);
  return 0;
}
  */

