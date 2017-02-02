function [tree_out,layer]=find_layer(tree,m)
%the function is uesed to transform a tree to another version
%the original tree emphasize the relation among nodes. But the new version
%emphasize the layer constructure of the tree
n=length(tree);
tree_out=cell(n,2);
tree_out{1,1}=1;  %the first part is the number of layer
tree_out{1,2}=m;  %the second part is used to store nodes in the same layer
number=[];
number(1)=m;
wid=zeros(1,n);
layer=1;
wid(1)=1;
while sum(wid)<n
    layer=layer+1;
    while ~isempty(number)
        tree_out{layer,1}=layer;
        tree_out{layer,2}=[tree_out{layer,2},tree{number(1),3}];
        number(1)=[];  %number is used to store nodes that we visited so that we can call them easily.
    end
    number=tree_out{layer,2};
    wid(layer)=length(tree_out{layer,2}); %wid is used to store the length of each layer
end

    