function [delta_cm,P]=calcu_rcm(tree,number)
% This function is used to calculate the bandwidth of each tree.
% First, we transform the cell to a matrix of a tree.
% Then calculate the bandwidth of each tree.
n=length(number);
B=zeros(n);
A=zeros(n);
belt=zeros(1,n);
adj=[];
for i=1:n
    adj=tree{i,3};
    p=length(adj);
    for j=1:p
        A(i,adj(j))=1;
        A(adj(j),i)=1;    %Transform the cell to a matrix
    end
end
for i=1:n
    B(:,i)=A(:,number(i));
end
for i=1:n
    pp=find(A(i,:)~=0);
    belt(i)=abs(i-pp(1));
end
delta_cm=max(belt);
P=sum(belt);
    
    
