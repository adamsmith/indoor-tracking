global min_Qscale
graphmetadata = zeros(15,17,6237);

for slkdjflk=3:17
    min_Qscale = zeros(20,1);
	min_Qscale(3:17) = 10^(7 - 2*(slkdjflk-3));
    p
    graphmetadata(slkdjflk-2,:,:) = graphdata(:,:);
    clear graphdata
end
% REMEMBER TO COMMENT OUT min_Qscale initialization in p.m







% min_Qscale(3) = 10^-5;
% min_Qscale(4) = 10^5.3;
% min_Qscale(5) = 10^-5.6;
% min_Qscale(6) = 10^-5.9;
% min_Qscale(7) = 10^-6.2;
% min_Qscale(8) = 10^-6.5;
% min_Qscale(9) = 10^-6.8;
% min_Qscale(10) = 10^-7.1;
% min_Qscale(11) = 10^-7.4;
% min_Qscale(12) = 10^-7.7;
% min_Qscale(13) = 10^-8;
% min_Qscale(14) = 10^-8.3;
% min_Qscale(15) = 10^-8.6;
% min_Qscale(16) = 10^-8.9;
% min_Qscale(17) = 10^-9.2;

% expG 3tick optimal: outer = 8 Qscale=10^-7
%                       inner = 6 chisqrmax=10^4