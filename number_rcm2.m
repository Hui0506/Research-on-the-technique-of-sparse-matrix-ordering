function number=number_rcm2(tree,d,m)
% This function is used to number nodes of trees.
% First we set the rooted node as the first one.
% And then we call its adjacent nodes and number them according to their
% degree, at the same time mark them.
% We call those marked nodes one by one.
n=length(d);
visited=zeros(n,1);   %used to mark those visited nodes
i=m; %the first node
k=1; %mark the nodes during the process of numbering
number(k)=m;
visited(m)=1;
u=1;
while sum(visited)<n
    adj=tree{i,3};     %the adjcent nodes
    p=length(adj);
    adj_d=[];
    if p>0
        for j=1:p
            adj_d(j)=d(adj(j)); %adj_d is used to store the adjcent nodes' degree
        end
        c=adj_d;
        while length(number)<k+p
            ind=find(adj_d==min(c));
            number=[number,adj(ind)];
            visited(adj(ind))=1;
            c(c==min(c))=[];
        end
        k=k+p;
    end
    u=u+1;   
    i=number(u);
end


    
    
        
    
        



    
        