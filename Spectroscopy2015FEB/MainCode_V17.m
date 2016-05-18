%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Comments

%%% 1.VERSION ALLOWING VARIABLE NUMBER OF INPUTS (X), OUTPUTS (K), LAYERS (L), AND UNITS (U) in HIDDEN LAYERS
%%% 2. Version 17 ALLOWS ITERATING LAMDA (option 1) and (No LAYERS) and (No UNITS)
%%% 3. VERSION 17 saves all "optimum" options in mat files and saves figures with all options
%%% 4. ALOOWS saving training data sets in FOLDER TRAINING DATA

%%% NEEDED To FINISH: 
%%% Priority: Make a control (higher level program, that saves in different folders)
%%% according to initial value of randomized initial thetas. 
%%% a) Number of UNITS per LAYER (sam enumber for all hidden layers). 
%%% b) Also turn OUTPUT into 0, and 1. 
%%% c) Saves absolute minima in Cost, error, etc. (could do save 2-3 best)
%%% d) COULD IMMPLEMENT iteration for different values of random theta



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc; close all;

%%% MAIN INPUT INTERFACE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


prompt_main= {  'Optimize parameters (0/1):' ...
                'Multiple initial conditions (theta) (0/1):' ...
                'How many initial conditions? (1-10):' ...
                'Max Number Iterations (opt) (200):', ...
                'lamda zero value only (0)'};
            
%%% IF 0, IT USES USER Entered parameters for Network, i.e. LAYERS, etc.
%%% IF 1: It will look for parameters to optimize

dlg_title_main='Main';
num_lines=1;
default_main={'1', '1', '2', '200', '0'};

answer_main=inputdlg(prompt_main,dlg_title_main,num_lines,default_main);

Optimize_Parameters= str2double(answer_main(1));
activate_multiple_initial_conditions= str2double(answer_main(2));
No_initial_conditions= str2double(answer_main(3));
max_number_iterations=str2double(answer_main(4));
lamda_zero_only=str2double(answer_main(5));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PROGRAM STARTS

if Optimize_Parameters==0
   
    prompt_parameters_1= {  'No LAYERS(2 or more):', ...
                            'No UNITS (1 or more):', ...
                            'lamda (0.001):', ...
                            'Precision CUT OFF:', ...
                            'Recall CUT OFF:', ...
                            'Arbitrary Number of Units (0/1):', ...
                            'Save Training Set Results (0/1):' , ...
                            'Activate numeric gradient (0/1):' ...
                            'Use numeric gradient (0/1):' ...
                            'Epsilon gradient (0.001):'};
                        

    dlg_title_main_1='Network Parameters';
    num_lines=1;
    default_prompt_parameters_1={'2', '1', '0.0001', '0.5', '0.5', '0', '0', '0', '0', '0.001'};
    
    answer_main_1=inputdlg(prompt_parameters_1,dlg_title_main_1,num_lines,default_prompt_parameters_1);

    No_LAYERS= str2double(answer_main_1(1));
    No_UNITS= str2double(answer_main_1(2));     %% Units in Hidden layers

    lamda=str2double(answer_main_1(3)); 

    Precision_cut_off=str2double(answer_main_1(4));   %%% 0.5 or more 
    Recall_cut_off=str2double(answer_main_1(5));      %%% 0.5 or less

    %%%% Choose different number of units per layer;
    activate_n_units_hidden_layer=str2double(answer_main_1(6));
    L_Arbitrary_No_UNITS_LAYER=No_LAYERS-2;

    %%%% Save output from training set
    save_output_from_training_set=str2double(answer_main_1(7));

    %%%% HIDDEN LAYERS NEEDS TO BE AUTOMATIZED WITH FOR LOOP %%% NOT DONE
    %%%% Under main_architecture then under NetworkParameters.m %%%%%%%%
    Hidden_UNITS(1)=1;  
    Hidden_UNITS(2)=1;
    Hidden_UNITS(3)=1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Numeric check
    activate_numeric_gradient=str2double(answer_main_1(8));
    use_numeric_gradient=str2double(answer_main_1(9));
    epsilon_gradient=str2double(answer_main_1(10));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    tic;
    main_architecture;
    toc

elseif Optimize_Parameters==1
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ParentDirMain=pwd;
    if exist('SAVED_DATA', 'dir')
        rmdir('SAVED_DATA', 's');  %delete everything in it!
    end
    mkdir('SAVED_DATA');
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%% lamda (regularization)optimization
    
    Optimize_panel_lamda= { 'Optimize lamda (regularization) (0:1)'...
                            'Minimum lamda (0.00001):' ...
                            'Maximum lamda (1):' ...
                            'Increse lamda by (factor 10):'};
                
    %%% IF 0, IT USES USER Entered parameters for Network, i.e. LAYERS, etc.
    %%% IF 1: It will look for parameters to optimize

    dlg_title_main_lamda='Optimize panel lamda (l=0.001)';
    num_lines=1;
    default_main_lamda={'1', '0.00001', '1', '10'};
   
    answer_main_lamda=inputdlg(Optimize_panel_lamda,dlg_title_main_lamda,num_lines,default_main_lamda);

   
    
    lamda_optimize= str2double(answer_main_lamda(1));
    min_lamda= str2double(answer_main_lamda(2));    
    max_lamda=str2double(answer_main_lamda(3));  
    increase_lamda_factor=str2double(answer_main_lamda(4));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% LAYERS optimization
    
    Optimize_panel_LAYERS= {    'Optimize No LAYERS (0/1):' ...
                                'Minimum LAYERS (2):' ...
                                'Maximum LAYERS(5):' ...
                                'Increse LAYERS by 1:'};
                
    %%% IF 0, IT USES USER Entered parameters for Network, i.e. LAYERS, etc.
    %%% IF 1: It will look for parameters to optimize

    dlg_title_main_l='Optimize panel LAYER';
    num_lines=1;
    default_main_l={'1', '3', '5', '1'};
   
    answer_main_LAYERS=inputdlg(Optimize_panel_LAYERS,dlg_title_main_l,num_lines,default_main_l);

   
    
    LAYER_optimize= str2double(answer_main_LAYERS(1));
    min_LAYER= str2double(answer_main_LAYERS(2));    
    max_LAYER=str2double(answer_main_LAYERS(3));  
    increase_LAYER_factor=str2double(answer_main_LAYERS(4));
    
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% UNITS optimization
    
    Optimize_panel_UNITS= {     'Optimize No UNITS (0/1):' ...
                                'Minimum UNITS(2):' ...
                                'Maximum UNITS(4):' ...
                                'Increse UNITS by 1:'};
                
    %%% IF 0, IT USES USER Entered parameters for Network, i.e. LAYERS, etc.
    %%% IF 1: It will look for parameters to optimize

    dlg_title_main_units='Optimize panel UNITS';
    num_lines=1;
    default_main_units={'1', '2', '4', '1'};
   
    answer_main_UNITS=inputdlg(Optimize_panel_UNITS,dlg_title_main_units,num_lines,default_main_units);

   
    
    UNIT_optimize= str2double(answer_main_UNITS(1));
    min_UNIT= str2double(answer_main_UNITS(2));    
    max_UNIT=str2double(answer_main_UNITS(3));  
    increase_UNIT_factor=str2double(answer_main_UNITS(4));
    
    
    
    %%%%%%%%% TO BE REDONE FOR ITERATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    prompt_parameters_1= {  'No LAYERS(2 or more):', ...
                            'No UNITS (1 or more):', ...
                            'lamda (0.0001):', ...
                            'Precision CUT OFF:', ...
                            'Recall CUT OFF:', ...
                            'Arbitrary Number of Units (0/1):', ...
                            'Save Training Set Results (0/1):' , ...
                            'Activate numeric gradient (0/1):' ...
                            'Use numeric gradient (0/1):' ...
                            'Epsilon gradient (0.001):'};     %%%% 'Save minima (3):'
                        

    dlg_title_main_1='Network Parameters';
    num_lines=1;
    default_prompt_parameters_l={'3', '3', '0.0001', '0.5', '0.5', '0', '0', '0', '0', '0.001'};
    
    answer_main_1=inputdlg(prompt_parameters_1,dlg_title_main_1,num_lines,default_prompt_parameters_l);

    if LAYER_optimize~=1
        No_LAYERS= str2double(answer_main_1(1));     
    end
    
    if UNIT_optimize~=1
         No_UNITS= str2double(answer_main_1(2));     %% Units in Hidden layers     
    end
   
    
    if lamda_optimize~=1
        lamda=str2double(answer_main_1(3));
    end

    Precision_cut_off=str2double(answer_main_1(4));   %%% 0.5 or more 
    Recall_cut_off=str2double(answer_main_1(5));      %%% 0.5 or less

    %%%% Choose different number of units per layer;
    activate_n_units_hidden_layer=str2double(answer_main_1(6));
%   L_Arbitrary_No_UNITS_LAYER=No_LAYERS-2;

    %%%% Save output from training set
    save_output_from_training_set=str2double(answer_main_1(7));
    
    if save_output_from_training_set==1
        
        if exist('TRAINING_DATA', 'dir')
            rmdir('TRAINING_DATA', 's');  %delete everything in it!
        end
        mkdir('TRAINING_DATA');
        save_training_folder=strcat(ParentDirMain,'\TRAINING_DATA');
    end

    %%%% HIDDEN LAYERS NEEDS TO BE AUTOMATIZED WITH FOR LOOP %%% NOT DONE
    %%%% Under main_architecture then under NetworkParameters.m %%%%%%%%
    Hidden_UNITS(1)=1;  
    Hidden_UNITS(2)=1;
    Hidden_UNITS(3)=1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Numeric check
    activate_numeric_gradient=str2double(answer_main_1(8));
    use_numeric_gradient=str2double(answer_main_1(9));
    epsilon_gradient=str2double(answer_main_1(10));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    number_iterations_LAYER=abs(max_LAYER-min_LAYER)/increase_LAYER_factor;
    number_iterations_UNIT=abs(max_UNIT-min_UNIT)/increase_UNIT_factor;
    number_iterations_lamda=log(max_lamda/min_lamda)/log(increase_lamda_factor);
    
    
    counter_of_iterations_ABSOLUTE=1;
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if activate_multiple_initial_conditions==1  %% affects main_architecture.m LINE 9 for stream of random numbers 
        
        initial_No_cell=cell(No_initial_conditions, 1);
        
        if exist('RANDOMS', 'dir')
            rmdir('RANDOMS', 's');  %delete everything in it!
        end
        mkdir('RANDOMS');
        randoms_folder=strcat(ParentDirMain,'\RANDOMS'); 
        
        
        for ccc=1:No_initial_conditions
            
            %%% generate random
            Rstream= RandStream.create('mrg32k3a','NumStreams',ccc,'StreamIndices',ccc); % for semi-random initialization
           
             
            %%%% main code for single random initialization
            LOOPING_CODE;
             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%% saving random struct
            %%% saving random struct
            dumb_rand_number = char(sprintf('Random_%i', ccc));
            number_rand_generator=Rstream;
            
            
            cd(randoms_folder);
            save (dumb_rand_number, 'number_rand_generator', 'initialize_theta_Vector');
            cd(ParentDirMain);
            
            %%% saving subfolder system
            cd(save_all_data);
            dumb_new_save_folder = char(sprintf('SAVED_DATA_%i', ccc));
            mkdir(dumb_new_save_folder);
            save_new_data_folder=strcat(ParentDirMain,'\SAVED_DATA\', dumb_new_save_folder); 
            movefile('*.mat',save_new_data_folder);
            cd(ParentDirMain);
            
        end
        
    else  % single initial condition
        
       Rstream = RandStream('mrg32k3a');  % for semi-random initialization
    
       LOOPING_CODE;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     
else    %% ERROR IN OPTION OPTIMIZE PARAMETERS UNITS, LAYERS, LAMDA
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    display('You need to select 0 or 1 for Optimize parameters.');  
    error('msgString');
end




    
    
    
    
    
    
    

