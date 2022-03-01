function [ind] = finds(A,b)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
count = 1;
for i=1:length(b)
    try
    ind(count) = find(A==b(i));
    count = count + 1;
    catch
        disp(i);
    end
end
end

