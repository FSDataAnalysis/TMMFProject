function  [F_Adhesion, d_min_zeroed, element_adhesion, ...
    dFAD_T, AREA_T, dFAD_zero_T]= ...
    DoStats( ...
    dumb_force, dumb_d_min, ...
    multiple_dFAD, dFAD_vector, New_clustering)

    %%% Find adhesion and zero dmin %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
    
    F_Adhesion=min(dumb_force);
    
    if New_clustering==0
        element_adhesion_dumb=find(dumb_force==F_Adhesion);
        element_adhesion=element_adhesion_dumb(1);
        d_min_zeroed=dumb_d_min-dumb_d_min(element_adhesion);
        
    else
        d_min_zeroed=dumb_d_min;
        element_adhesion_dumb=find(dumb_force==F_Adhesion);
        element_adhesion=element_adhesion_dumb(1);
    end
    
    %%% Distances %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dFAD_T=zeros(1,length(dFAD_vector));  %% change later 
    dFAD_zero_T=zeros(1,length(dFAD_vector));  %% change later 

    %%% Work of adhesion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ccc=1:1:length(dFAD_T)
        
        dumb_find_points_dFAD = dumb_force < dFAD_vector(ccc)*F_Adhesion;
  
        dFAD_Force_dumb=dumb_force(dumb_find_points_dFAD);
        dFAD_Distance_dumb=d_min_zeroed(dumb_find_points_dFAD);

        minimum_position_1=find(dFAD_Force_dumb==F_Adhesion);
        
        minimum_position=minimum_position_1(1);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% Area (MIGHT FIND WAY TO ENTER LOOP ONVE ) %%%%%%%%%%%%%%%%%%%%%%%%%
   

        count_iteration_area=1;
        raw_matrix_area=zeros(length(dFAD_Distance_dumb), 2);
        %%%%% Area 
        dFAD_Distance_dumb_area=dFAD_Distance_dumb;

        while count_iteration_area < length(dFAD_Distance_dumb)+1

            dumb_raw_area_element=dFAD_Distance_dumb_area==dFAD_Distance_dumb_area(count_iteration_area);

            Y_ind=mean(dFAD_Force_dumb(dumb_raw_area_element));
            X_ind=dFAD_Distance_dumb_area(dumb_raw_area_element);

            raw_matrix_area(count_iteration_area, 1)=X_ind(1); 
            raw_matrix_area(count_iteration_area, 2)=Y_ind;

            count_iteration_area=count_iteration_area+1;
        end
        

        %%%% delta_X (FOR AREA)
        delta_X_dumb = raw_matrix_area(2:end,1)-raw_matrix_area(1:end-1,1);
        %%%% Effective Y (FOR AREA)
        Y_dumb = raw_matrix_area(1:end-1,2)-dFAD_vector(ccc)*F_Adhesion;
        dumb_Area=sum(delta_X_dumb.*Y_dumb);      
        %%%% End of itertion for area
        
        %%%% dFAD
        dFAD=abs(dFAD_Distance_dumb(1)-dFAD_Distance_dumb(end));
        
        if dFAD_Distance_dumb(minimum_position)<dFAD_Distance_dumb(end)
            dFAD_zero=abs(dFAD_Distance_dumb(minimum_position)-dFAD_Distance_dumb(end));
        else
            dFAD_zero=abs(dFAD_Distance_dumb(minimum_position)-dFAD_Distance_dumb(1));
        end
        
        dFAD_T(ccc)=dFAD;
        dFAD_zero_T(ccc)=dFAD_zero;
        AREA_T(ccc)=dumb_Area;

    end
    
    

end

