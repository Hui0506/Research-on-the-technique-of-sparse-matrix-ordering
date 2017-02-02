function [new_tree,numbering]=gps_min(tree_u,u,tree_v,v,A)
%The function is used to realize the gps arithmetic.
%Inputs tree_v and tree_u is the output of wdr arithmetic. And u and v are
%their root nodes respectively.
%A is the original matrix which should be dealt with.
%Output new_tree is the result of this step of minimal the tree-width.
%Numbering is the final output of gps.
A_1=A; %A is saved in A_1 because in the step of minimal the tree-width, we will change the structure of A
n=length(tree_u); %n is the scale of matrix A.
new_tree=cell(n,1);
number=zeros(n,2); %number is used to store associated pairs of each node.
gra=zeros(1,n); %gra is used to calculate how many nodes A still have after delete nodes with same elements in their associated pairs.
numbering=[];  %numbering is the final output which convey the numbering of nodes
N=zeros(1,n); %N is the vector which represent the n in the arithmetic.
d=zeros(1,n); %d is the degree of each node.
mark_1=zeros(1,n);
mark_2=zeros(1,n); %mark is used to judge whether we should reverse the numbering.
for i=1:n
    d(i)=tree_u{i,2};
end
for i=1:n
    gra(i)=i;
end
[tree_um,layer_u]=find_layer(tree_u,u); %This step is used to emphasize the level structure of tree_u
[tree_vm,layer_v]=find_layer(tree_v,v); %This step is used to emphasize the level structure of tree_v
for i=1:layer_u
    adj=tree_um{i,2};
    l=length(adj);
    for k=1:l
        number(adj(k),1)=i; %this step is used to calculate the first element of the associated pair.
    end
end
for j=1:layer_v
    adj=tree_vm{j,2};
    l=length(adj);
    for k=1:l
        number(adj(k),2)=layer_v+1-j; %this step is used to calcute the second element of the associated pair.
    end
end
for i=1:n
    if number(i,1)==number(i,2)
        new_tree{number(i,1),1}=[new_tree{number(i,1)},i]; %We find nodes whose first value of associated pair and the second is equal.
        A(i,:)=0;
        A(:,i)=0; %We delete edges of those nodes.
        gra(find(gra==i))=[]; %We delete those nodes.
    end
end
[gra_stru,b,t]=gra_gps(A,gra); %We find how many unconnected graphs A still have
[~,b_1]=sort(b); %We sort those unconnected graphs according to their number of nodes.
for i=1:t %We put nodes in the new tree according to each graph.
    B=gra_stru{b_1(i),1};
    l_1=length(B);
    for j=1:n
        N(j)=length(new_tree{j,1});
    end
    h=N;
    la=N;
    h_0=max(h);
    l_0=max(la);
    if h_0<l_0
        for k=1:l_1
            new_tree{number(B(k),1),1}=[new_tree{number(B(k),1),1},B(k)]; %We set nodes according to the first element.
            h(k)=h(k)+1;
        end
        mark_1(i)=1;
    elseif h_0>l_0
        for k=1:l_1
            new_tree{number(B(k),2),1}=[new_tree{number(B(k),2),1},B(k)]; %We set nodes according to the second element. 
            la(k)=la(k)+1;
        end
        mark_2(i)=1;
    else
        for k=1:l_1
            wid_1=length(new_tree{number(B(k),1),1}); %We compare the width of those two modes
            wid_2=length(new_tree{number(B(k),2),1});
            if wid_1<wid_2
                new_tree{number(B(k),1),1}=[new_tree{number(B(k),1),1},B(k)]; %We choose the the mode with the smaller width 
                h(k)=h(k)+1;
                mark_1(i)=1;
            elseif wid_1>wid_2
                new_tree{number(B(k),2),1}=[new_tree{number(B(k),2),1},B(k)];
                la(k)=la(k)+1;
                mark_2(i)=1;
            else
                new_tree{number(B(k),1),1}=[new_tree{number(B(k),1),1},B(k)]; %If width are equal, we choose the first one.
                h(k)=h(k)+1;
                mark_1(i)=1;
            end
        end
    end
end
mark_3=0;
if d(u)>d(v)
    uu=u;
    u=v;
    v=uu;
    mark_3=1;
    for i=1:t
        cha=new_tree{i,1};
        new_tree{i,1}=new_tree{t+1-i,1}; %If the degree of u is larger than v, we change u and v.
        new_tree{t+1-i,1}=cha;
    end
end
lay=0;
for i=1:n
    if ~isempty(new_tree{i,1}) %lay is the parameter used to store the layer numbers of new tree.
        lay=lay+1;
    end
end
numbering(1)=u; %We set u as the first one.
C=new_tree{1,1};
C(find(C==u))=[];
l_n1=length(C);
b_sto=[];
Num=cell(n,1);
for j=1:l_n1  %We numbering the first level according to the rules.
    if j<=length(numbering)
        k=numbering(j);
        C(find(C==k))=[]; %C is used to store unnumbered nodes.
        for i=1:l_n1
            if A_1(k,C(i))==1
                b_sto=[b_sto,C(i)]; %b_sto is the number of adjacent nodes of smallest numbered node.
                C(i)==[];
            end
        end
        d_n1=d(b_sto);
        [~,b_n2]=sort(d_n1); %We sort d_sto according to their degree
        numbering=[numbering,b_sto(b_n2)];
    end
end
[~,b_n2]=sort(d(C));
numbering=[numbering,C(b_n2)];
Num{1,1}=numbering;
visited=zeros(1,n);
for i=2:lay  %We begin to number elements from the second level to the last level.
    D=Num{i-1,1}; %D is used to store nodes in the last level
    C=new_tree{i,1}; %C is used to store nodes in the present level which have not been numbered.
    M=C; 
    l_n1=length(C);
    l_n2=length(D);
    for k=1:l_n2
        b_sto=[];
        m=D(k);
        visited(m)=1;
        for j=1:l_n1
            if A_1(m,C(j))==1&&visited(C(j))==0
                b_sto=[b_sto,C(j)];
                M(find(M==C(j)))=[]; %b_sto is used to store nodes adjacent to the respective smallest node in the last level. 
                visited(C(j))=1; %visited is used to record those nodes we have called.
            end
        end
        d_n1=d(b_sto);
        [~,b_n2]=sort(d_n1);
        numbering=[numbering,b_sto(b_n2)];
        Num{i,1}=[Num{i,1},b_sto(b_n2)]; %We set numbering according to their degree.
    end
    if ~isempty(M) %M is used to store nodes in the present level but is unconnected with any nodes in the last level.
        l_n4=length(M);
        nod=b_sto;
        l_n5=length(nod);
        visited_1=zeros(1,l_n4);
        adj=[];
        for mm=1:(l_n4+l_n5-1)
            kk=nod(mm);
            for nn=1:l_n4
                if A_1(kk,M(nn))==1&&visited_1(nn)==0
                    nod=[nod,M(nn)];
                    visited_1(nn)=1;
                    adj=[adj,M(nn)];
                    M(nn)=0;
                end
            end
            [~,adj_1]=sort(d(adj));
            numbering=[numbering,adj(adj_1)];
            Num{i,1}=[Num{i,1},adj(adj_1)];
        end
        M(find(M==0))=[];
        [~,b_n3]=sort(d(M));
        numbering=[numbering,M(b_n3)];
        Num{i,1}=[Num{i,1},M(b_n3)];
    end
end
[~,b_1,~]=unique(numbering);
numbering=numbering(sort(b_1)) %We delete nodes we have recorded repeatedly.
if (mark_3==1&&mark_2(1)==1)||(mark_3==0&&mark_1(1)==1)
    for i=1:n
        reverse_gps(i)=numbering(n+1-i);
    end
end

    




        
            

    


    

