function [gra_stru,b,t]=gra_gps(A,gra)
%The function is used to anlysize how many unconnected graphs the matrix A
%has.
%According to the last step, we set some lines of A all zeros.
%And to the graph, we need to delete some nodes and edges.
%Different matrix have different number of unconnected graphs, as a
%result, we need a program to count how many unconnected graphs A has.
%Inputs A is the matrix whose nodes have been delete, and gra is an array
%used to store nodes which are not been deleted.
%Output gra_stru is a cell, and each cell unit stores nodes in each
%unconnected graph, and b is an array used to store the number of nodes in
%each unconnected graph.
%Output t is the number of unconnected graphs.
l=length(gra);   %l is the number of nodes in the new matrix
n=length(A);     %n is the scale of matrix A
gra_stru=cell(l,1);  %gra_stru is used to store nodes in each unconnected graph
visited=zeros(1,n);  %visited is used to mark nodes which we have visited
number=[];          %number is used to store nodes we have visited so that we can call them easily
visited(gra(1))=1;
b=zeros(1,l);
k=1;
t=0;
while ~isempty(gra)  %we delete one node when we call it,so that we just need to call the first one and also set the loop conditon 
    number(1)=gra(1);
    gra_stru{k,1}=gra(1);
    while ~isempty(number) %we seek each adjacent node of the root node and second set the first adjacent node as the root node and loop it.
        adj=[];
        m=number(1);
        visited(m)=1;
        for j=1:n
            if A(m,j)==1&&visited(j)==0
                number=[number,j];
                adj=[adj,j];
                visited(j)=1;
                gra(find(gra==j))=[];
            end
        end   %we end the loop until we call all nodes in the first graph.
        gra_stru{k,1}=[gra_stru{k,1},adj];
        gra(find(gra==number(1)))=[]; %we delete nodes we have called.
        number(1)=[];
    end
    k=k+1; %then we find the second graph according to the array of gra.
end
for i=1:l
    b(i)=length(gra_stru{i,1});
end
for i=1:l
    if ~isempty(gra_stru{i,1});
        t=t+1;
    end
end
b(find(b==0))=[];