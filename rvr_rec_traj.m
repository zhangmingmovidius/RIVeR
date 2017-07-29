function [H_traj id_traj no_id]=rvr_rec_traj(id_result,resultslistptv,st,H,Hroi,id_traj)

X=[];
Y=[];
Id=[];
if id_result>size(resultslistptv,2)
    id_result=size(resultslistptv,2)-1; %in case that the mean result has been calculated
end
    
    for i=1:id_result
        X=[X;resultslistptv{2,i};resultslistptv{4,i}];
        Y=[Y;resultslistptv{1,i};resultslistptv{3,i}];
        Id=[Id;resultslistptv{6,i};resultslistptv{6,i}];
    end
    
    %rectify trajectories
    [Bi]=rvr_trans2rw([X';Y';0*X'+1],H);
    % T(:,1)=unique(Bi(1,:))'; T(:,2)=unique(Bi(2,:))'; %eliminates duplicates
    
    
    %delete duplicates
    [C1,ia1,ic1]=unique(Bi(1,:));
    [C2,ia2,ic2]=unique(Bi(2,:));
    ia=unique([ia1;ia2]);
    
    T(:,1)=Bi(1,ia);
    T(:,2)=Bi(2,ia);
    Id_filt=Id(ia);
    
    %exclude trajectories out of roi
    [id_in,on] = inpolygon(T(:,1),T(:,2),Hroi(1,:)',Hroi(2,:)');
    T=T(id_in==1,:);
    Id_filt=Id_filt(id_in==1,:);
    
    
    no_id=[];
    if isempty(id_traj)==1
        id_traj=unique(Id_filt)';
    end
    
    for i=id_traj
        try
            traj=T(Id_filt==i,:);
            des= sqrt(diff(traj(:,1)).^2 + diff(traj(:,2)).^2);
            vel=1000*des/st;
            pos=(cumsum([0; des(1:end-1)])+cumsum(des))./2;
            
            real_vel=interp1(pos,vel,cumsum([0; des]),'linear','extrap');%extrapolated velocity on real positions
            
            H_traj{i,1}=[traj real_vel];
        catch
            no_id=[no_id i]; %ida that don't exist
        end
        
    end

