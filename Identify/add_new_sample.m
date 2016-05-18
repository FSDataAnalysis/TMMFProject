%% saving new set

% loading_file_name=FileName(1,1:end-4);
% 
% new_loading_name_path =strcat(PathName, loading_file_name);
% 
% load (new_loading_name_path);

Percentages_found= unique(dFAD_matrix_Percentage_FILES(:,1));
No_percentages=length(Percentages_found);

if No_percentages~=10
    display('The data does not have 10 values of dFAD');
    error('msgString');
end

vector_length=length(dFAD_matrix_Percentage_FILES(1,2:end));
LLL_single_percentage=vector_length;

%%%% Find OUT LENGTH of INPUT and OUTPUT matrices

No_column_examples_Input=length(Input(1,:));
No_sample_examples_Output=length(Output(:,1));


dumb_last_column_input=No_column_examples_Input;
dumb_last_raw_output=No_sample_examples_Output;


    
if divisor_mean>1


    initial_is=0;

    for iii=1:No_percentages % get percentages dFAD

        dumb_find=Percentages_found(iii);

        dumb_new_per = char(sprintf('%f', Percentages_found(iii)));

        new_percentage_name = char(sprintf('dFAD_%s', dumb_new_per(1:4)));

        dummy_vector_to_do=dFAD_matrix_Percentage_FILES(iii,2:end);

        dummy_vector_to_do_dim=floor(length(dummy_vector_to_do)/divisor_mean);
        dummy_vector_to_do_new=dummy_vector_to_do(1:dummy_vector_to_do_dim*divisor_mean);

        dummy_vector_to_do_new_matrix=reshape(dummy_vector_to_do_new', divisor_mean, dummy_vector_to_do_dim); 
        dummy_vector_to_do_new_matrix_mean=mean(dummy_vector_to_do_new_matrix); 
        dumb_new_Input(iii,:)=dummy_vector_to_do_new_matrix_mean;

    end
else
    dumb_new_Input=dFAD_matrix_Percentage_FILES(:,2:end);

end

if add_adhesion_parameter==1
    
    Input_dummmy=dumb_new_Input;
    dumb_new_Input=[];
    
     if divisor_mean>1
        
        dummy_adhesion_to_do_new=F_Adhesion_FILES(1:dummy_vector_to_do_dim*divisor_mean);      
        dummy_adhesion_to_do_new_matrix=reshape(dummy_adhesion_to_do_new', divisor_mean, dummy_vector_to_do_dim); 
        dummy_adhesion_to_do_new_matrix_mean=mean(dummy_adhesion_to_do_new_matrix); 
        
    else
        dummy_adhesion_to_do_new_matrix_mean=F_Adhesion_FILES(:,2:end);
    end   
    
    dumb_new_Input=[Input_dummmy; dummy_adhesion_to_do_new_matrix_mean];
    
       
end
    
    
    
    
LLL_new_sample=length(dumb_new_Input(1,:));
LLL_new_output=LLL_new_sample;


Input_abs_old=Input_abs;

Input_abs=dumb_new_Input;


   
if add_adhesion_parameter==1
 
    Input_abs=[];
    Input_abs=dumb_new_Input(2:end-1, :);
    
    F_ad_abs=dumb_new_Input(end, :);
    F_ad_nN=abs(F_ad_abs*1e9);
end
    

jjj=0;

for iii=Start_normalize_row:Increase_by_normalized:(No_percentages +End_normalize_row)  
    jjj=jjj+1;
    Input_normalized(jjj,:)=dumb_new_Input(iii,:)./(dumb_new_Input(Start_normalize_row,:));
end

if add_adhesion_parameter==1
    
    Input_normalized_dummy=Input_normalized;
    Input_normalized=[];
    Input_normalized=[Input_normalized_dummy;F_ad_nN];
end


Input_normalized=floor(Input_normalized*1000);
Input_normalized=Input_normalized/1000;



if non_linear_input==1
    
    
    dummy_input=2*Input_normalized(2,:);
    dummy_input2=2*Input_normalized(3,:);
    dummy_input3=2*Input_normalized(end-1,:);
    dummy_input4=2*Input_normalized(end,:);
    
    final_input_dummy=((dummy_input+dummy_input2).*(dummy_input3+dummy_input4))/1000;
    
    Input_normalized=[Input_normalized;floor(final_input_dummy)];
end



Input_abs=[Input_abs_old, dumb_new_Input(2:end, :)];

Input=[Input, Input_normalized(2:end, :)];


    
new_Output=ones(1,LLL_new_sample);
new2_Output=zeros(1,dumb_last_column_input);

new_3_Output=[ new2_Output, new_Output]; %% new raw

new4_output_zeros=zeros(dumb_last_raw_output, LLL_new_sample); 

new5_Output=[Output, new4_output_zeros]; % added zeros in old columns and new examples

Output=[new5_Output; new_3_Output];

data_base_set.(Sample_name)=dumb_last_raw_output+1;  % assigns the name of the sample to Ou`put Y (dumb_last_raw_output+1)



save (name_of_current_set, 'Input', 'Output', 'Input_abs' , 'new_set', 'data_base_set', '-append');