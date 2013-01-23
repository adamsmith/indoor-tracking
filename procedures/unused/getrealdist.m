function dist = getrealdist(m,c,list)
% Returns real distance to beacon 'm'
dist = sqrt((c(m,1)-list(1))^2+(c(m,2)-list(2))^2+(c(m,3)-list(3))^2);