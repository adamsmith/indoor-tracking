function index = find_end_from_here(matrix, col, i0)

init = matrix(i0,col);
index = i0;

if index+1 > size(matrix,1)
    return
end

while matrix(index+1,col) == init
    index = index + 1;
    if index+1 > size(matrix,1)
        return;
    end
end