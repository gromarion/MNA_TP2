function VQ_data=vq2(data,I) 
%VQ_data:ÏòÁ¿Á¿»¯ºóµÄÊý¾Ý 
%data:ÊäÈëÊý¾Ý 
%I:ÏòÁ¿»¯Âë±¾ 
[row,col]=size(data); 
[I_size,I_num]=size(I); 
sqrt_num=sqrt(I_num); 
x_count=row/sqrt_num; 
y_count=col/sqrt_num; 
for i=1:x_count 
   for j=1:y_count      
      temp=data((i-1)*sqrt_num+1:i*sqrt_num,(j-1)*sqrt_num+1:j*sqrt_num); %²âÊÔÏòÁ¿ 
      temp2=sum((((ones(I_size,1)*temp(:)')-I).^2)')'; 
      min_index=min(find(temp2==min(temp2)));   %ÇóÂë±¾ÖÐÓë´ý²âÏòÁ¿×î½Ó½üµÄÂë±¾   
      block=reshape(I(min_index,:),sqrt_num,sqrt_num);%×ª»»³Ésqrt_num*sqrt_numµÄ¿éÐÎÊ½ 
      VQ_data((i-1)*sqrt_num+1:i*sqrt_num,(j-1)*sqrt_num+1:j*sqrt_num)=block; %´úÌæÔ­ÏòÁ¿              
   end 
end 
