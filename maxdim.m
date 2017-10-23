function y = maxdim(cell)
for i = 1:size(cell,1)
    if i == 1
        hi = numel(strsplit(cell{i}));
    end
    if i > 1 && numel(strsplit(cell{i}))>hi
        hi = numel(strsplit(cell{i}));
    end
end
y = hi - 1;