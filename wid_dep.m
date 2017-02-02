function [ratio,number]=wid_dep(tree,d,m)
%the function is used to calculate the ratio of brandwidth and depth
%the input variables are tree(a cell), degree of each node and the root
%node.
%we use a set wid to store the width of each line.
%the layer is used to store the layers of the tree.
%number is used to store nodes in the last line
n=length(d);
wid=zeros(1,n);      %a set used to store width of each line
wid(1)=1;
number(1)=m;         %a set used to store nodes in the same line which are easily to call
layer=1;
while sum(wid)<n     %if we have called all nodes, the sum of the width will be equal to n
    adj=[];
    while ~isempty(number)
        p=number(1);
        number(1)=[];   %we delet node which we called just now so that we can use the loop codition
        adj=[adj,tree{p,3}];%the adj set is used to store nodes in the same line temporaryly.
    end
    number=adj;
    layer=layer+1;
    wid(layer)=length(number);
end
wid_1=max(wid);
ratio=wid_1(1)/layer;
