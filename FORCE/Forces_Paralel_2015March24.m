clear all; clc;

FULL_computation_time_start=tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% standard  columns for single files  ASYLUM RESEARCH %%%%%%%%%%%%%%%%%%
ZEx =1 ; DfEx =2 ; ZRet = 3;  DfRet = 4; AEx =5 ;  ARet =6 ; PEx =7 ;  PRet =8 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Panel Interface %%%%
%%%% Affects the main_code_forces.m computation and the preprocessing of
%%%% text files via redo_files.m
prompt_main= {'Spring Constant:','Q factor:','Normalized Resonance:', ...
            'Amplitude InVolts:', 'Process Files:', 'Organize columns (0/1):', ...
            'Paralel computing (0/1):', 'Smoothing Model (1/2/3)', ...              % Model 1 is NANS, etc, 2 remove large numbers and 3, averaging remove
            'Tune other parameters (0/1):', ...
            'Save all data (0/1):', 'distance (0):'};


dlg_title='Cantilever Inputs and processing';
num_lines=1;
default_main={'40','500','1', ...
              '40', '0', '0', ...
              '1', '3', '0', '0', '0'};  %% Paralel computing AND tuning other parameters 
          
answer_main=inputdlg(prompt_main,dlg_title,[1, length(dlg_title)+40], default_main); 


k= str2double(answer_main(1));					
Q= str2double(answer_main(2));						                    
omg_f0= str2double(answer_main(3));	
%%% 
omg_drive=omg_f0;


AmpInvOLS =  str2double(answer_main(4));
ProcessFiles_main=str2double(answer_main(5));
Re_organize_files= str2double(answer_main(6));
    
   
Parallel_computing=str2double(answer_main(7));
Smoothing_Model=str2double(answer_main(8));
Tuning_panel=str2double(answer_main(9));
save_ALL_data=str2double(answer_main(10));
distance=str2double(answer_main(11));

%%% chooses the clean model to employ to smooth Force and Energy in
%%% calculate_force.m
if Smoothing_Model==1
    smoothen_NANS_Fts=1; smoothen_MODEL_1_Fts=0; smoothen_MODEL_2_Fts=0;
elseif Smoothing_Model==2
    smoothen_NANS_Fts=0; smoothen_MODEL_1_Fts=2; smoothen_MODEL_2_Fts=0;
elseif Smoothing_Model==3
    smoothen_NANS_Fts=0; smoothen_MODEL_1_Fts=0; smoothen_MODEL_2_Fts=3;
end

TuningOfOtherParameters;


ParentDirMain=pwd;



if Parallel_computing==1
    
    check_paralle_running = matlabpool('size');
    
    if check_paralle_running==0
        matlabpool
    end
end

%%%% Ask if processing the files and how
%%%% if ProcessFiles_main==1 then it has to "split the files" otherwise
%%%% copy paset directly into directory inside Statistics foleder
% default_process_files={};


save data_main;

unpacking_files=tic;

Folder_RAWFILES_LARGE_TREE = uigetdir('.', 'Select directory containing the files');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subfolders = dir(Folder_RAWFILES_LARGE_TREE);
isSub = [subfolders(:).isdir]; %# returns logical vector
nameSuBFolds = {subfolders(isSub).name}';

nameSuBFolds(ismember(nameSuBFolds,{'.','..'})) = [];
    
   
%%%% LOOP FOR SUBFOLDERS ADDED ON THE 16th of March 2015 by S Santos 

NNN_NumberOfSubFolders=length(nameSuBFolds);
NNN_sub=1;

% Folder_RAWFILES=char(sprintf('%s',ParentDirMain, '\DATA_SETS')); 
if NNN_NumberOfSubFolders>1
    save INITIAL_DATA;
    display('Cleared screen and Data for preprocessing files');
    display('Now saving each subfolder into PROCESSED_SETS%Number');
end

while NNN_sub <= (NNN_NumberOfSubFolders)
    
    FULL_computation_time_single=tic;
       
    Folder_RAWFILES=char(strcat(Folder_RAWFILES_LARGE_TREE, '\', nameSuBFolds(NNN_sub)));
    
        % Folder_RAWFILES=char(sprintf('%s',ParentDirMain, '\DATA_SETS')); 
    RawFileName = dir(fullfile(Folder_RAWFILES,'*.txt') );
  
    
    RawFileName_path = strcat(Folder_RAWFILES, filesep, {RawFileName.name});
    RawFileName_path=sort_nat(RawFileName_path);

    [pathstr_is, name_is, ext_is]=fileparts(RawFileName_path{1});
    How_many_raw_files=length(RawFileName_path);

    %%%% This does the files in the format from Asylum Research to selected
    %%%% as:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% standard  columns for single files  ASYLUM RESEARCH %%%%%%%%%%%%%%%%%%
    %%%% ZEx =1 ; DfEx =2 ; ZRet = 3;  DfRet = 4; AEx =5 ;  ARet =6 ; PEx =7 ;  PRet =8 ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    RedoFiles;


    time_to_unpack_files=toc(unpacking_files)


    if save_data_processed_files==1
        save_process_foo=sprintf('data_processed_files_N_%i', NNN_sub);
        save save_process_foo;
    end


    %%%%%% Star Main Panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% THE STRUCTURE single_meta_file CONTAINS ALL FILES AND NAMES

    computing_forces_time_start=tic;

    %%%% Computation of forces 
    main_code_forces;

    computing_forces_time=toc(computing_forces_time_start)

    

    if save_ALL_data==1 
        foo_save_1=sprintf('ALL_DATA_N_%i', NNN_sub);
        
        save (foo_save_1);   
    end

    if NNN_NumberOfSubFolders>1
        foo_save_2=sprintf('%s_N_%i', 'PROCESSED_SETS', NNN_sub);       
    else
        foo_save_2='PROCESSED_SETS';
    end
    
    NNN_sub=NNN_sub+1;
    
    save (foo_save_2, 'unpacked_Force_RAW', 'unpacked_Force_CLEAN');
    
    if NNN_NumberOfSubFolders>1
        save ('INITIAL_DATA', 'NNN_sub', '-append');
    end
    
    FULL_computation_single_folder=toc(FULL_computation_time_single)
    
    if NNN_NumberOfSubFolders>1
        
        clear all; 
        load INITIAL_DATA;
    end
    
    
end   % while loop for FILES

FULL_computation_time=toc(FULL_computation_time_start)

