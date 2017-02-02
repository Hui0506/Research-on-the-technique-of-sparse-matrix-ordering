function number=number_rcm(A,m,d)
[n,n]=size(A);
q=n*n;
number=zeros(q);
number(1,1)=m;
visited=zeros(1,n);
visited(m)=1;
d=zeros(1,n);
layer=1;
num_1=1;
num_2=1;
i=number(layer,num_1);
while sum(visited)<n
    while number(layer,num_1)>0
        c=zeros(1,n);
        seq=zeros(1,n);
        for j=1:n
            if A(i,j)==1&&visited(j)==0
                c(j)=d(j);
                seq(j)=d(j);
            end
        end
        if sum(c)>0
             seq(find(seq==0))=[];
             while length(seq)>0
                    k=find(c==min(seq));
                    visited(k)=1;
                    number(layer+1,num_2)=k(1);
                    num_2=num_2+1;
                    seq(find(seq==min(seq)))=[];
             end
        end
        if number(layer,num_1+1)>0
            num_1=num_1+1;
            i=number(layer,num_1);
        else
            layer=layer+1;
            i=number(layer,1);
            num_2=1;
            num_1=1;
        end
    end
end
number=number';
number=reshape(number,1,q*q);
number(find(number==0))=[];