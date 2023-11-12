col_length=size(Timestamps,2);

fprintf('length:%d\n',col_length)
for a=1:fix(col_length/32000)
    Timestamps(a*3200000+1)-Timestamps((a-1)*3200000+1)
end
