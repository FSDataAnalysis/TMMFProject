
Input_abs=[];
Input_abs=dFAD_matrix_Percentage_FILES(:,2:end);

LLL_new_output=length(Input_abs(1,:));


Input_normalized=[];
jjj=0;
for iii=Start_normalize_row:Increase_by_normalized: (No_percentages +End_normalize_row)    %  End_normalize_row is either 0 or negative
    jjj=jjj+1;
    Input_normalized(jjj,:)=Input_abs(iii,:)./(Input_abs(Start_normalize_row,:));
end

if (add_adhesion_parameter==1)||(add_adhesion_parameter_norm==1)
    
    F_Adhesion_FILES_nN=abs(F_Adhesion_FILES)*1e9;
    
    if (add_adhesion_parameter_norm==1)
         F_Adhesion_FILES_nN=abs(F_Adhesion_FILES/tip_radius);
    end
    
    X_CV=[Input_normalized; F_Adhesion_FILES_nN'];
else
    X_CV=Input_normalized;
end
foo=1;

% Input_normalized=floor(Input_normalized*1000);
% Input_normalized=Input_normalized/1000;