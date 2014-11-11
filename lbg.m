%http://read.pudn.com/downloads178/sourcecode/math/825767/LBG.m__.htm
%http://www.pudn.com/downloads178/sourcecode/math/detail825767.html

function I=LBG(data,I_size,I_num,lmda) 
%I:×îºóµÃµ½µÄÂë±¾ 
%data:ÊäÈëÊý¾Ý 
%I_sizeÂë±¾´óÐ¡ 
%I_numÂë±¾Î¬¶È 
%lmdaÍË³öµü´úÌõ¼þ

[row col]=size(data); 
%ÑµÁ·ÐòÁÐµÄ´óÐ¡
T_num=row*col/I_num; 
temp=[]; 
sqrt_num=sqrt(I_num);
%ÐÐ·½Ïò·ÖµÄ¿éÊý 
x_count=row/sqrt_num;
%ÁÐ·½Ïò·ÖµÄ¿éÊý 
y_count=col/sqrt_num; 
%°ÑÊäÈëÊý¾Ý°´ÕÕÂë±¾Î¬¶ÈµÄ¿ª·½*Î¬¶ÈµÄ¿ª·½·Ö¿é 
for i=1:x_count 
   for j=1:y_count   
    temp1=data((i-1)*sqrt_num+1:i*sqrt_num,(j-1)*sqrt_num+1:j*sqrt_num);    
     temp=[temp;temp1(1:I_num)]; 
   end 
end 
%ÊäÈëÊý¾Ý×ª»»ÎªÑµÁ·ÐòÁÐµÄ¼ä¸ô
num1=x_count*y_count/T_num; 
T=[]; 
for i=1:num1:num1*T_num 
   T=[T;temp(i,:)]; 
end 
%ÊäÈëÊý¾Ý×ª»»Îª³õÊ¼Âë±¾µÄ¼ä¸ô
num2=x_count*y_count/I_size; 
I=[]; 
for i=1:num2:num2*I_size 
   I=[I;temp(i,:)]; 
end 
D=[]; 
count=1; 
D(1)=inf; 
while true    
   sum=0; 
   id=[]; 
   %ÇóÔÚÂë±¾ÖÐÓëÑµÁ·ÐòÁÐÆ½·½Îó²î×îÐ¡µÄÏòÁ¿
   for i=1:T_num    
      min_val=inf; 
      index=0;     
      for j=1:I_size 
         va=(T(i,:)-I(j,:))*transpose(T(i,:)-I(j,:));% 
         if va<min_val 
            min_val=va; 
            index=j;  
         end 
      end 
      sum=sum+min_val/I_num; 
      id=[id index]; 
   end
   %ËùÓÐÑµÁ·ÐòÁÐµÄÆ½·½Îó²îµÄËãÊõÆ½¾ùÖµ    
   D=[D sum/T_num]; 
   count=count+1;  
   fprintf('µÚ[%1.0f]´Îµü´ú,Æ½¾ùÆ½·½Îó²îÎª%1.9f\n',count-1,D(end)) 
   %·ûºÏÒªÇóÍË³öµü´ú
   if abs((D(count-1)-D(count))/D(count-1))<lmda,break,end     
   %¸üÐÂÂë±¾
   for i=1:I_num  
      k=0; 
      temp2=zeros(1,I_num);       
      for j=1:T_num 
         if id(j)==i 
            temp2=temp2+T(j,:); 
            k=k+1; 
         end 
      end 
      if k>0          
         I(i,:)=temp2/k; 
      end 
   end    
end 