%%% Modified S Santos APril 21 2015: Save different CLEAN slim file minimal_STATS

clear all; clc;
 
 
[FileName_Stats,PathName_Stats,FilterIndex_Stats] = uigetfile('*.mat','MultiSelect', 'off');
 
if strcmp(class(FileName_Stats), 'double')
        display('No file selected. Select Mat file');
        error('msgString');
end
 
%%% load MAT FILE with forces %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path_stats_file=strcat(PathName_Stats, FileName_Stats);
load (path_stats_file);
 
%%% Loads two structures SAVED ACCORDING TO LINE 314 of calculate_forces.m
%%% unpacked_Force_CLEAN;
%%% unpacked_Force_RAW;
%%% Raw_No1 => Force_real; === VS col N0 7 for d_min (raw)
%%% Raw_No8 => d_min_mean VS Raw_No11 (Last COL) Fts_smoothened
%%%
%%% CLEAN structure HAS extra columns with smoothend Edis and Fts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%% Main interface STATS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt= {'Multiple ref:','Number of points:', 'Initial:','Final:', 'Plot Final Force:', ...
    'Save data:', 'New Custering (D VS FORCE req): (0/1)'};
dlg_title='Metrics dFAD/Work of Adhesion';
% num_lines=1;
default={'1','10', '0.05','0.95', '1', '1', '0'};
answer=inputdlg(prompt,dlg_title,[1, length(dlg_title)+40], default); 
 
 
multiple_dFAD=str2double(answer(1));
No_points_dFAD=str2double(answer(2));
initial_value_dFAD=str2double(answer(3));
final_value_dFAD=str2double(answer(4));
plot_force=str2double(answer(5));
save_ALL_Data=str2double(answer(6)); 
New_clustering=str2double(answer(7)); 

%%%% 
if multiple_dFAD==0   
    dumb_loop=2;
    dFAD_vector=[initial_value_dFAD final_value_dFAD];
    
elseif multiple_dFAD==1  
    dumb_loop=No_points_dFAD;
    
    intervals_in_between=(final_value_dFAD-initial_value_dFAD)/(No_points_dFAD-1);
    
    
    dFAD_vector=initial_value_dFAD:intervals_in_between:final_value_dFAD;  
end
 
%%% dFAD_vector contains numbers to do, i.e. 10%... 90%. 
 
Percentage_dFAD=floor(dFAD_vector*100);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% COMPUTATION STATS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
if New_clustering==0
    dumb_field_names=(fieldnames(unpacked_Force_CLEAN));
    LLL_stats=length(dumb_field_names);  % No of files to compute 

    %%%%
    dumb_cols=length(unpacked_Force_CLEAN.No_1(1,:));
    smooth_force_col=dumb_cols;                         % last column
    d_min_mean_col=8;                                   % d_min_mean column


    vector_of_names_files = (fieldnames(unpacked_Force_CLEAN));
else
    dumb_field_names=(fieldnames(D));
    LLL_stats=length(dumb_field_names);  % No of files to compute 
    
    %%%%
    
     for ddd_i=1:LLL_stats

        dumb_name_d_vs_force_now=sprintf('No_%i', ddd_i);
        
        unpacked_Force_CLEAN.(dumb_name_d_vs_force_now)(:,2)=D.(dumb_name_d_vs_force_now);
        unpacked_Force_CLEAN.(dumb_name_d_vs_force_now)(:,1)=FORCE.(dumb_name_d_vs_force_now);   
                
     end
    
    dumb_cols=length(unpacked_Force_CLEAN.No_1(1,:));
    smooth_force_col=1;                         % last column
    d_min_mean_col=2;                                    % d_min_mean column
    
    
    vector_of_names_files = (fieldnames(unpacked_Force_CLEAN));

end

%%%%%%%%%

%%%% TO SEND TO PAR OF AS ROLLVED VECTORS 
unrolling_Vectors_Stats;

LLL_cumulative_forces_Stats_ini=LLL_cumulative_forces_Stats+1;
initial_roll_Stats=[1; LLL_cumulative_forces_Stats_ini(1:end-1)];
final_roll_Stats=LLL_cumulative_forces_Stats;
%%%%%%%%


F_Adhesion_Stats=[];
d_min_zeroed_Stats=[];
element_adhesion_Stats=[];
dFAD_matrix_Stats=[];
dFAD_FAD_zero_matrix_Stats=[];
AREA_matrix_Stats=[];
    
time_calc_stats=tic;
 

 
parfor No_files=1:LLL_stats
    

  %%%%%%%%% function that partitions files %%%%%%%%%%%%%%%%%%%%%%%%%%%
  [F_Adhesion, d_min_zeroed, element_adhesion, ...
  dFAD_matrix, AREA_matrix, dFAD_FAD_zero_matrix]= ...
    DoStats( ...
  unrolled_forces_Stats(initial_roll_Stats(No_files):final_roll_Stats(No_files)), ...
  unrolled_d_min_Stats(initial_roll_Stats(No_files):final_roll_Stats(No_files)), ...
  multiple_dFAD, dFAD_vector, New_clustering);               % send d_min_mean (clean)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  F_Adhesion_Stats=[F_Adhesion_Stats; F_Adhesion];                         % Single column 
  d_min_zeroed_Stats=[d_min_zeroed_Stats; d_min_zeroed];                   % Single row (TO PLOT VERSUS FORCE )
  element_adhesion_Stats=[element_adhesion_Stats,  element_adhesion(1)];      % Single Column, Elements F_Adhesion in vector
  dFAD_matrix_Stats=[dFAD_matrix_Stats; dFAD_matrix];                      % Matrix Concateation, Single row per file 
  AREA_matrix_Stats=[AREA_matrix_Stats; AREA_matrix];                      % Matrix Concateation, Single row per file 
  dFAD_FAD_zero_matrix_Stats=[dFAD_FAD_zero_matrix_Stats;dFAD_FAD_zero_matrix]; 
end
 
dFAD_matrix_Percentage_FILES=[ Percentage_dFAD' , dFAD_matrix_Stats'];
dFAD_FAD_zero_matrix_Percentage_FILES=[ Percentage_dFAD' , dFAD_FAD_zero_matrix_Stats'];
AREA_matrix_Percentage_FILES=[ Percentage_dFAD' , AREA_matrix_Stats'];
F_Adhesion_FILES=F_Adhesion_Stats;


%%% roll d_min back to get zeroed dmin at adhesion 
rolling_d_min_Back_Stats;

time_stats=toc(time_calc_stats)
 
if save_ALL_Data==1
    
    save ALL_DATA_STATS;
else   
    save ´('ALL_DATA_STATS', 'dFAD_matrix_Percentage_FILES', 'AREA_matrix_Percentage_FILES', 'dFAD_FAD_zero_matrix_Percentage_FILES');
end
    


save ('minimal_STATS', 'dFAD_matrix_Percentage_FILES', ...
    'D', 'FORCE', 'AREA_matrix_Percentage_FILES', 'F_Adhesion_FILES', 'unpacked_Force_CLEAN', 'dFAD_FAD_zero_matrix_Percentage_FILES');

