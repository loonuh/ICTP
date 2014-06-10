function [neighValues,coords] = percross(matrix,i,j)
xcor = i;
ycor = j;

xcor_p = i+1;
xcor_m = i-1;

ycor_p = j+1;
ycor_m = j-1;

if i == size(matrix,1)
    xcor_p = 1;
end

if i == 1
    xcor_m = size(matrix,1);
end


if j == size(matrix,2)
    ycor_p = 1;
end

if j == 1
    ycor_m = size(matrix,2);
end
    neighValues = [matrix(xcor,ycor_p) matrix(xcor_p,ycor) ...
                   matrix(xcor,ycor_m) matrix(xcor_m,ycor)];
    coords = [xcor,ycor_p;xcor_p,ycor;xcor,ycor_m;xcor_m,ycor];
end

