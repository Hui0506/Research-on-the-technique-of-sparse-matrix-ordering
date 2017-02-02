function [tree_v,v_1,tree_u,u]=h_wdr(A)
%the function is used to realize the wdr algorithm.
%we have 2 different conditions.
%first we choose those nodes with smallest degree.
%we find the minimal ratio of width and depth.
%if we have only one node which have the smallest ratio, we use it as v and
%find another node with the smallest ratio in the last line.
%if we have more than one node which share the smallest ratio. We find v
%and u which are satisfied in the condition that their distance is k-1, if
%no, we find the smallest ratio node in the last line.
n=length(A);
d=zeros(1,n);
ratio=[];
for i=1:n
    for j=1:n
        if A(i,j)==1
            d(i)=d(i)+1; %d is a set used to store the degree of each node
        end
    end
end
v=find(d==min(d));    %we choose those who have the smallest degree
k=length(v);          %k is the number of nodes satifying with the smallest degree condition
for m=1:k
    tree=tree_wdr(A,d,v(m));  %use each smallest degree node as root node and form a tree
    [ratio(m),~]=wid_dep(tree,d,v(m));  %calculate the ratio of width and depth of each node
end
ratio_3=min(ratio);    %find the smallest ratio
ratio_2=v(find(ratio==min(ratio)));   %ratio_2 is used to store those nodes with smallest degree and ratio.
k=length(ratio_2);
if k==1
    v_1=ratio_2(1);
    tree_v=tree_wdr(A,d,ratio_2(1));
    [~,number_1]=wid_dep(tree_v,d,ratio_2(1)); %number_!is used to store nodes in the last layer
    l=length(number_1);
    ratio_1=zeros(1,l);
    for i=1:l
        tree=tree_wdr(A,d,number_1(i));
        [ratio_1(i),~]=wid_dep(tree,d,number_1(i));
    end
    u=number_1(find(ratio_1==min(ratio_1)))       %we find u which have the smallest ratio in the last layer
    tree_u=tree_wdr(A,d,u(1))
else         %if we have more than one node who have the smallest ratio
    l=length(ratio_2);
    find_1=0; 
    i=0;
    while i<l||find_1==0  
        i=i+1;
        tree=tree_wdr(A,d,ratio_2(i));
        [~,number_2]=wid_dep(tree,d,ratio_2(i));
        find_1=intersect(ratio_2,number_2);  %find_1 is used to judge whether we have a u whose distance with v is k-1
        if find_1     %if find_1=0, we cannot find u whose distance with v is k-1, we find the smallest ratio in the last line.
            u=find_1(1);
            tree_u=tree_wdr(A,d,find_1(1))
            v_1=ratio_2(i);
            tree_v=tree_wdr(A,d,ratio_2(i))
            break;
        else
            v_1=ratio_2(1);
            tree_v=tree_wdr(A,d,v_1)
            [~,number]=wid_dep(tree_v,d,v_1);
            l=length(number);
            for j=1:l
                tree=tree_wdr(A,d,number(j));
                [ratio_4,~]=wid_dep(tree,d,number(j));
            end
            u=find(ratio_4==min(ratio_4));
            tree_u=tree_wdr(A,d,u) %find_1=0, we look for the smallest ratio in the last layer
            break;
        end
    end
end

