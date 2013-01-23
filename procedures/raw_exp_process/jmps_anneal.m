time_jmp = 300; % 500 ticks <=> 128ms
nominal_jmp = 80;

% % Find large time jumps
% for i=2:size(cl_1a,1)
%     if ((cl_1a(i,1) - cl_1a(i-1,1)) > time_jmp)
%         disp([num2str(i) ' : ' num2str(cl_1a(i-1,1)) ' => ' num2str(cl_1a(i,1))]);
%     end
% end

% % Visualize large time jumps
% for i=1:size(cl_2a,1)-1
%     tmp(i) = cl_2a(i+1) - cl_2a(i);
% end
% cdfplot(tmp)


% % Anneal large time jumps
% offset = 0;
% for i=2:size(cl_3a,1)
%     if ((cl_3a(i,1) - cl_3a(i-1,1)) > time_jmp)
%         offset = offset - ((cl_3a(i,1) - cl_3a(i-1,1)) - nominal_jmp);
%     end
%     cl_3a(i,1) = cl_3a(i,1) - offset;
% end