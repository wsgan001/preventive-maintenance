function [ column ] = Diagonal( square )
%SPLITMATRIX Returns the diagonal of the given square matrix in column
%form.
column = zeros(size(square,1),1);
for i=1:size(square,1)
    column(i)=square(i,i);
end
end
