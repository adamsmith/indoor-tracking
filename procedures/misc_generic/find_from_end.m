function index = find_from_end(matrix, col, value)

index = -1;
for i = size(matrix,1):-1:1
    if matrix(i,col) == value
        index = i;
        break;
    end
end