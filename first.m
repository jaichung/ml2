function [p,n] = first(po,no)
sp = num2str(po);
sn = num2str(no);
if numel(sp)>2 && numel(sn)>2
    p = str2double(sp(1:2));
    n = str2double(sn(1:2)); 
elseif numel(sp)>2 && numel(sn)<3
    p = str2double(sp(1:2));
    n = str2double(sn(1)); 
elseif numel(sp)<3 && numel(sn)>2
    p = str2double(sp(1));
    n = str2double(sn(1:2));  
else
    p = str2double(sp(1));
    n = str2double(sn(1));
end