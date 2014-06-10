function [neighValues] = cross(matrix,i,j)
    neighValues = [matrix(i,j+1) matrix(i-1,j) matrix(i,j-1) matrix(i+1,j)];
end

