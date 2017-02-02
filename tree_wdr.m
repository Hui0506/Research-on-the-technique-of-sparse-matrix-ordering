function tree=tree_wdr(A,d,m)
% The function is used to form a tree through a matrix A and its rooted
% node.
% We use cell to store such a tree.
% We call the rooted node, and mark its all adjacent nodes.
% We visite each node in the adjacent or rooted node set one by one.
% We set the marked node as the rooted node and back to step 3.
n=length(A);        %the order of the matrix of A
tree=cell(n,3);     %store the tree via cell
visited=zeros(1,n);
visited(m)=1;       %mark those nodes which we have visited
% i=m;
number=[];
number(1)=m;        %number is used to store visited nodes so that we can call them easily
p=1;
while p<n+1
    i=number(p);
    p=p+1;
    tree{i,1}=i;    %the first unit is used to store the nodes, it is just a number
    tree{i,2}=d(i); %the second unit is used to store the degree of the node.
    adj=[];
    k=1;
    for j=1:n
        if A(i,j)==1&&visited(j)==0
            adj(k)=j;
            k=k+1;
            visited(j)=1;
        end
    end
    tree{i,3}=adj;    %the third unit is used to store the adjacent nodes expect its mother node
    number=[number,adj];
end