if Tuning_panel==0

    load_text_files_directly=0; %% one would load text files directly from a folder (NOT DONE)
    coefficient_A0_calc=0.02; %% in function calculate_force.m for A0 calculation automation        % one for speed
    saving_single_text_files=0;   % zero for speed
    save_data_processed_files=0;  % zero for speed
    SLOW_processes_1=0;           % slow processes might get you smoothed data that is not strictly necessary, etc. 

    Extension_answer=0;           % 0 is extension, 1 retraction and 2 both (not done 2)
    remove_start= 50;             % removes points from start and end of files before processing
    remove_end= 50;               % Less nooise!

    small_treshold=-50e-9;        %% treshold for forces small 
    large_treshold=50e-9;         %% threshold for forces large 
    remove_outliers_in_force_NANS=1;
    remove_outliers_in_force_MODEL_1=1; % extreme values ALL Curve

    grouped_data_Fts_MODEL_2=30;        % grouping nearby
    remove_outliers_in_force_MODEL_2=1;   % nearby other values 
    model_noise='normal';

    %%%%%%%%% Smooth
    s_d_min=0.01;                   %%%% In calculate_force function SLOW
    s_d_min_Incr=0.01;              %%%% In calculate_force function SLOW
    s_defl=0.01;                    %%%% In calculate_force function SLOW NOT NECESSARY
    s_Omega_AM=0.01;
    s_Omega_Incr=0.01;
    s_Fts=0.01;
    s_E_dis=0.01;
    
elseif Tuning_panel==1


        %%%% tuning panel
        prompt_tuning= {'load_text_files_directly','coefficient_A0_calc:','saving_single_text_files:', ...
                    'save_data_processed_files:', 'SLOW processes 1 ON?:', 'Extension (0/1/2)', ... % BOTH NOT DONE
                    'remove end:', 'remove start:'...
                    'small_treshold:', 'large threshold:'};
    


        dlg_title='Tuning Panel';
        num_lines=1;
        default_tuning={'0','0.02','0', ...
                      '0', '0', '0', '50', '50' ...
                      '-50e-9', '50e-9'};  %% Paralel computing AND tuning other parameters 

        answer_tuning=inputdlg(prompt_tuning,dlg_title,[1, length(dlg_title)+90], default_tuning); 

%         default_process_files={};

                       
        load_text_files_directly=str2double(answer_tuning(1));
        coefficient_A0_calc=str2double(answer_tuning(2));  %% in function calculate_force.m for A0 calculation automation        % one for speed
        saving_single_text_files=str2double(answer_tuning(3));   % zero for speed
        
        
        save_data_processed_files=str2double(answer_tuning(4));  % zero for speed
        SLOW_processes_1=str2double(answer_tuning(5));           % mainly smoothing etc. in calculate_force.m 
        Extension_answer=str2double(answer_tuning(6));  
        remove_end= str2double(answer_tuning(7));                 % Less nooise!
        remove_start= str2double(answer_tuning(8));             % removes points from start and end of files before processing
    
        
        small_treshold=str2double(answer_tuning(9));        %% treshold for forces small 
        large_treshold=str2double(answer_tuning(10));         %% threshold for forces large 

        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Second Panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        prompt_tuning_2= { 'remove_outliers_in_force_NANS:', 'remove_outliers_in_force_MODEL_1', ...
                    'grouped_data_Fts_MODEL_2:', 'remove_outliers_in_force_MODEL_2', ...
                    'model_noise', ...
                    's_d_min:', 's_d_min_Incr:', ...              % Model 1 is NANS, etc, 2 remove large numbers and 3, averaging remove
                    's_defl:', 's_Omega_AM:',  ...
                    's_Omega_Incr:',  's_Fts:', 's_E_dis'};
    


        dlg_title_2='Tuning Panel 2';
        num_lines=1;
        default_tuning_2={ '1', '1', '30', '1', 'normal', ....
                      '0.01', '0.01', '0.01', '0.01', '0.01', '0.01', '0.01'};  %% Paralel computing AND tuning other parameters 

        answer_tuning=inputdlg(prompt_tuning_2,dlg_title_2,[1, length(dlg_title)+90], default_tuning_2); 

%         default_process_files={};

        remove_outliers_in_force_NANS=str2double(answer_tuning(1));  
        remove_outliers_in_force_MODEL_1=str2double(answer_tuning(2));  
        
        grouped_data_Fts_MODEL_2=str2double(answer_tuning(3));           % grouping nearby
        remove_outliers_in_force_MODEL_2=str2double(answer_tuning(4));      % nearby other values 
        model_noise=char(answer_tuning(5));   

        
        s_d_min=str2double(answer_tuning(6));                   %%%% In calculate_force function SLOW
        s_d_min_Incr=str2double(answer_tuning(7));             %%%% In calculate_force function SLOW
        s_defl=str2double(answer_tuning(8));                    %%%% In calculate_force function SLOW NOT NECESSARY
        s_Omega_AM=str2double(answer_tuning(9));
        s_Omega_Incr=str2double(answer_tuning(10));
        s_Fts=str2double(answer_tuning(11));
        s_E_dis=str2double(answer_tuning(12));
end