DATA_SET_ALL=[];
DATA_SET_NANS_ALL=[];
DATA_SET_MODEL_1_ALL=[];
DATA_SET_MODEL_2_ALL=[];

Fts_cons_smooth_ALL=[];
E_dis_smooth_ALL=[];

length_file_SET_ALL=[];

length_file_SET_NANS_ALL=[];

length_file_SET_MODEL_1_ALL=[];

length_file_SET_MODEL_2_ALL=[];


this_is_initial_computation=tic;

%% 1. Values wihout final M are raw
%% 2. Values with M are values after calculation of force

parfor i_parallel=1:LLL_length_No_files
    
   [RAW_DATA_SET, ...
   RAW_DATA_SET_NANS, ...
   RAW_DATA_SET_MODEL_1, ...
   RAW_DATA_SET_MODEL_2, ...
   Fts_cons_smooth, E_dis_smooth,  ...
   length_file_SET, length_file_SET_NANS, ...
   length_file_SET_MODEL_1, length_file_SET_MODEL_2]= ...
        calculate_force(single_meta_file.(single_file_name_ALL(i_parallel, :)), ...
   AEx, ZEx, PEx, DfEx, ... 
   ARet, ZRet, PRet, DfRet, ...
   s_d_min, s_d_min_Incr,  s_Omega_AM, s_Omega_Incr, ...
   s_Fts, s_E_dis, ...
   coefficient_A0_calc, ...
   Extension_answer, remove_start, remove_end, ...
   omg_f0, omg_drive, Q, AmpInvOLS, k, ... 
   small_treshold, large_treshold, ...     %% Remove small and large values in force (selected in main panel)
   remove_outliers_in_force_NANS, ...
   remove_outliers_in_force_MODEL_1, ...   % extreme values ALL Curve
   grouped_data_Fts_MODEL_2, ...
   remove_outliers_in_force_MODEL_2, ...   % nearby other values 
   model_noise, ...
   smoothen_NANS_Fts, smoothen_MODEL_1_Fts, smoothen_MODEL_2_Fts, ...
   SLOW_processes_1, distance);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Returning
    
    %%% Rolled data from single files (METADATA)
    DATA_SET_ALL=[DATA_SET_ALL; RAW_DATA_SET];
    DATA_SET_NANS_ALL=[DATA_SET_NANS_ALL; RAW_DATA_SET_NANS];
    DATA_SET_MODEL_1_ALL=[DATA_SET_MODEL_1_ALL; RAW_DATA_SET_MODEL_1];
    DATA_SET_MODEL_2_ALL=[DATA_SET_MODEL_2_ALL; RAW_DATA_SET_MODEL_2];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    Fts_cons_smooth_ALL=[Fts_cons_smooth_ALL; Fts_cons_smooth];
    E_dis_smooth_ALL=[E_dis_smooth_ALL; E_dis_smooth];
    
    length_file_SET_ALL=[length_file_SET_ALL; length_file_SET];

    length_file_SET_NANS_ALL=[length_file_SET_NANS_ALL; length_file_SET_NANS];

    length_file_SET_MODEL_1_ALL=[length_file_SET_MODEL_1_ALL; length_file_SET_MODEL_1];

    length_file_SET_MODEL_2_ALL=[length_file_SET_MODEL_2_ALL; length_file_SET_MODEL_2];
    
 
end


Time_To_Cmpute_forces=toc(this_is_initial_computation);


format longEng;



unpacked_Force_RAW=struct;
unpacked_Force_CLEAN=struct;

initial_value_single_raw=1;
initial_value_single_clean=1;

if smoothen_NANS_Fts==1
    
    CLEAN_DATA_SET=DATA_SET_NANS_ALL;
    DUM_length=length_file_SET_NANS_ALL;
    
elseif smoothen_MODEL_1_Fts==2
    
    CLEAN_DATA_SET=DATA_SET_MODEL_1_ALL;
    DUM_length=length_file_SET_MODEL_1_ALL;
    
elseif smoothen_MODEL_2_Fts==3
    
    CLEAN_DATA_SET=DATA_SET_MODEL_2_ALL;
    DUM_length=length_file_SET_MODEL_2_ALL;  
end

CLEAN_DATA_SET=[CLEAN_DATA_SET, E_dis_smooth_ALL, Fts_cons_smooth_ALL];
    

RAW_DATA_SET_CLEAN=length(DUM_length);
RAW_DATA_SET_RAW=length(length_file_SET_ALL);



COLS_DATA_SET_RAW=length(DATA_SET_ALL(1,:));
COLS_DATA_SET_CLEAN=length(CLEAN_DATA_SET(1,:));

% names_files_in_cell=cellstr(single_file_name_ALL);

packing_forces=tic;

%%% save into original files FORCE RECONSTRUCTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iii=1: RAW_DATA_SET_RAW
    
    foo_name=sprintf('No_%i', iii);  
    
%     foo_name=single_file_name_ALL(iii, :);
    
    final_value_single_RAW=initial_value_single_raw + length_file_SET_ALL(iii)-1;
    final_value_single_clean=initial_value_single_clean + DUM_length(iii)-1;
    
    unpacked_Force_RAW.(foo_name)= ...
        reshape(DATA_SET_ALL(initial_value_single_raw:final_value_single_RAW, :), ...  
    length_file_SET_ALL(iii), COLS_DATA_SET_RAW);

    unpacked_Force_CLEAN.(foo_name)= ...
        reshape(CLEAN_DATA_SET(initial_value_single_clean:final_value_single_clean, :), ...  
    DUM_length(iii), COLS_DATA_SET_CLEAN);
    
    initial_value_single_raw=final_value_single_RAW+1;
    initial_value_single_clean=final_value_single_clean+1;
    
    
end


time_to_pack_forces=toc(packing_forces);























% LLL_aranged_variables, LLL_aranged_variables_F, ...








% 
% clear all;
% 
% load DUMMM;
% 
% tic
% Amplitude=[];
% Phase=[];
% Deflection=[];
% Separation=[];
% 
% Amplitude=struct;
% 
% parfor i_parallel=1:10 %LLL_length_No_files  
%    
%     [Amplitude_dumb]=Prepare_Columns_Units_Lengths(single_meta_file.(single_file_name_ALL(i_parallel, :)), ...
%         AEx, ZEx, PEx, s_d_min, s_d_min_Incr,  coefficient_A0_calc);
%     
% %     Amplitude_ALL=[Amplitude_ALL; Amplitude];
%     
%     dumb_name=sprintf('Number_%s', i_parallel);   
% 
%     Amplitude=Amplitude_dumb;
%     Phase=
%     Deflection=
%     Separation=
% end
% 
% this_is_toc=toc




% 
% rows_SET_ALL=[];
% cols_SET=[];
% length_file_SET=[];
% 
% rows_SET_NANS=[];
% cols_SET_NANS=[];
% length_file_SET_NANS=[];
% 
% rows_SET_MODEL_1=[];
% cols_SET_MODEL_1=[];
% length_file_SET_MODEL_1=[];
% 
% rows_SET_MODEL_2=[];
% cols_SET_MODEL_2=[];
% length_file_SET_MODEL_2=[];


%     rows_SET_ALL=[rows_SET_ALL; rows_SET];
%     cols_SET_ALL=[cols_SET_ALL; cols_SET];
%     length_file_SET_ALL=[length_file_SET_ALL; length_file_SET];
%     
%     rows_SET_NANS_ALL=[rows_SET_NANS_ALL; rows_SET_NANS];
%     cols_SET_NANS_ALL=[cols_SET_NANS_ALL; cols_SET_NANS];
%     length_file_SET_NANS_ALL=[length_file_SET_NANS_ALL; length_file_SET_NANS];
%     
%     rows_SET_MODEL_1_ALL=[rows_SET_MODEL_1_ALL; rows_SET_MODEL_1];
%     cols_SET_MODEL_1_ALL=[cols_SET_MODEL_1_ALL; cols_SET_MODEL_1];
%     length_file_SET_MODEL_1_ALL=[length_file_SET_MODEL_1_ALL; length_file_SET_MODEL_1];
%     
%     rows_SET_MODEL_2_ALL=[rows_SET_MODEL_2_ALL; rows_SET_MODEL_2];
%     cols_SET_MODEL_2_ALL=[cols_SET_MODEL_2_ALL; cols_SET_MODEL_2];
%     length_file_SET_MODEL_2_ALL=[length_file_SET_MODEL_2_ALL; length_file_SET_MODEL_2];