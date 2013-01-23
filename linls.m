function [x,y,z] = linls(z,c,m)

% tmp = zeros(1,3);
% tmp2 = zeros(1,1);
% for i=1:size(c,1)
%     sgood = 1;
%     for j=1:size(tmp,1)
%         if tmp(j,:) == c(i,:)
%             sgood = 0;
%         end
%     end
%     if sgood == 1
%         tmp(size(tmp,1),:) = c(i,:);
%         tmp(size(tmp,1)+1,:) = [0,0,0];
%         tmp2(size(tmp2,1),:) = z(i);
%         tmp2(size(tmp2,1)+1,:) = 0;
%     end
% end
% tmp = tmp(1:size(tmp,1)-1,:);
% tmp2 = tmp2(1:size(tmp2,1)-1,:);
% c = tmp;
% z = tmp2;
% m = size(c,1);

c = c(:,1:2);

if m < 3
    x=0;
    y=0;
    z=0;
else
	%linear least squares according to Allen's thesis
	A = zeros(m-1,2);
% 	A = zeros(m-1,3);
	b = zeros(m-1,1);
	
	for i=2:m
        for j=1:2
            A(i-1,j) = 2*(c(i,j)-c(1,j));
        end
        b(i-1) = c(i,1)^2-c(1,1)^2+c(i,2)^2-c(1,2)^2-(z(i)^2-z(1)^2);
	end
	
	pos = regress(b,A);
	x = pos(1);
	y = pos(2);
% 	z = pos(3);
	z = -1;
end