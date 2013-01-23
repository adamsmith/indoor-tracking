function val = findvec(haystack,needle)
a=size(haystack);
if a==1
    a = size(haystack,2);
end
val = 0;
for i=1:a
    if haystack(i) == needle
        val = i
        break
    end
end