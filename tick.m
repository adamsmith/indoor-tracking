
%record graphdata
global enable_hybrid hybridused min_hybrid min_index min_x min_D min_U min_Qscale min_reject_buf min_suspect_buf min_runcounter minP_index minP_x minP_D minP_U minP_Qscale minP_reject_buf minP_suspect_buf minP_runcounter minP_PR_glob

if graphs(1,1) == 1
    graphdata(1,graphcnter) = abs(squeeze(exp_data(data_pointer-1,1,3)) - sqrt((x(1,1)-c(beac_chirp,1))^2+(x(1,2)-c(beac_chirp,2))^2+(x(1,3)-c(beac_chirp,3))^2));
end
if graphs(1,2) == 1
    graphdata(graphs(1,1)+1,graphcnter) = lasttrack_index;
end
graphptr = [2,1];
for i=graphs(1,1)+graphs(1,2)+graphs(1,3)+1:graphcnt
    while graphs(graphptr(1),graphptr(2)) == 0
        if graphptr(2) < size(graphs,2)
            graphptr(2)=graphptr(2)+1;
        else
            graphptr(2)=1;
            graphptr(1)=graphptr(1)+1;
        end
    end
    
    if graphptr(2) == 1 % Record absolute error for this model
        graphdata(i,graphcnter) = min([sqrt((x(1,1)-x(graphptr(1),1))^2+(x(1,2)-x(graphptr(1),2))^2+(x(1,3)-x(graphptr(1),3))^2),sqrt((x(1,1)-x(graphptr(1),1))^2+(x(1,2)-x(graphptr(1),2))^2+(x(1,3)+2*252.73-x(graphptr(1),3))^2)]);
    elseif graphptr(2) == 2 % Record chisqr error for the last sensor measurement under this model
        graphdata(i,graphcnter) = chisqr_out(graphptr(1));
    elseif graphptr(2) == 3 % Record whether or not hybrid data was used during the last iteration (note: invariant of which model we're talking about, for now)
        graphdata(i,graphcnter) = hybridused;
    end
    
    if graphptr(2) == size(graphs,2)
        graphptr(1)=graphptr(1)+1; graphptr(2)=1;
    else
        graphptr(2) = graphptr(2)+1;
    end
end

%shift graph data in preparation for new data on next tick
graphcnter = graphcnter + 1;

if data_type == type_active_beacon
    
    tick2_active
    
elseif data_type == type_passive_beacon
    
    tick2_passive
    
else
    
    error('Unknown data_type');
    
end