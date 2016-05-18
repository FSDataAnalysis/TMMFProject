clear all; clc; close all;


if exist('SAVED_PLOT_DATA', 'dir')
    rmdir('SAVED_PLOT_DATA', 's');  %delete everything in it!
end
mkdir('SAVED_PLOT_DATA');


ParentDirMain_plot=pwd;
%% In the SAVED_DATA directory all the data will be saved for each file
saved_data=strcat(ParentDirMain_plot,'\SAVED_DATA'); 
save_all_data_plot=strcat(ParentDirMain_plot,'\SAVED_PLOT_DATA'); 

if exist('OPTIMUM_DATA_cost.mat', 'file')
    movefile('OPTIMUM_DATA_cost.mat',save_all_data_plot);
end
if exist('OPTIMUM_DATA_error.mat', 'file')
    movefile('OPTIMUM_DATA_error.mat',save_all_data_plot);
end
if exist('OPTIMUM_DATA_F_1_score.mat', 'file')
    movefile('OPTIMUM_DATA_F_1_score.mat',save_all_data_plot);
end
if exist('OPTIMUM_DATA_recall.mat', 'file')
    movefile('OPTIMUM_DATA_recall.mat',save_all_data_plot);
end
if exist('OPTIMUM_DATA_precision.mat', 'file')
    movefile('OPTIMUM_DATA_precision.mat',save_all_data_plot);
end

cd(saved_data);                        
%%%% find mat files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mat_files_raw = dir(fullfile('*.mat') );
%%%%% Get names
Mat_files_raw_names = strcat({Mat_files_raw.name});
cd(ParentDirMain_plot);

number_of_files_mat=length(Mat_files_raw_names);
%%% Loop through mat files, i.e. different lamda (x-axis), No Units, No LAYERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for fff=1:number_of_files_mat

    dumd_pwd=pwd;
    
    cd(saved_data);   
    load_mat_number=char(sprintf('load %s',char(Mat_files_raw_names(fff))));  
    eval (load_mat_number);
    cd(dumd_pwd);  
    
    M_size=5;
    LL=size(names);

    cost_vect_CV=[];
    error_funct_vect_CV=[];

    precision_vector_CV=[];
    recall_vector_CV=[];
    F_1_SCORE_vector_CV=[];

    lamda_vect=[];

    for iii=1:LL(:,1)

        dumb_name=names{iii};

        cost_vect_CV(iii)=cost_funct_CV_matrix.(dumb_name);  
        error_funct_vect_CV(iii)=error_function_matrix.(dumb_name);

        F_1_SCORE_vector_CV(iii)=F_1_SCORE_matrix.(dumb_name);
        precision_vector_CV(iii)=Precision_matrix.(dumb_name);
        recall_vector_CV(iii)=Recall_matrix.(dumb_name);

        lamda_vect(iii)=lamda_matrix.(dumb_name);
    end

    counter_figs=0;
    dumb_name_legend = char(sprintf('%s', dumb_iteration_name));

    names_of_figures=cell([],1);
    figure (1)  %%% lamda, cost_funct
    hold on
    
    counter_figs=counter_figs+1;
    names_of_figures{counter_figs}='cost funct CV';
    
    
    title(names_of_figures{counter_figs},'fontsize',12)
    xlabel('lamda','fontsize',14) 
    ylabel(names_of_figures{counter_figs},'fontsize',14)
    
    plot(log10(lamda_vect), cost_vect_CV, '-.Vk','Markersize',M_size, 'displayname',dumb_name_legend);
    

    figure (2)  %%% lamda, error
    hold on

    counter_figs=counter_figs+1;
    names_of_figures{counter_figs}='error funct CV';
    
    title(names_of_figures{counter_figs},'fontsize',12)
    xlabel('lamda','fontsize',14) 
    ylabel(names_of_figures{counter_figs},'fontsize',14)
    
    
    plot(log10(lamda_vect), error_funct_vect_CV,'-.Vk','Markersize',M_size, 'displayname',dumb_name_legend);


    
    figure (3)  %%% lamda, cost_funct
    hold on
    
    
    counter_figs=counter_figs+1;
    names_of_figures{counter_figs}='F1 SCORE CV';
    
    title(names_of_figures{counter_figs},'fontsize',12)
    xlabel('lamda','fontsize',14) 
    ylabel(names_of_figures{counter_figs},'fontsize',14)
    
    
    plot(log10(lamda_vect), F_1_SCORE_vector_CV,'-.Vk','Markersize',M_size, 'displayname',dumb_name_legend);

    figure (4)  %%% lamda, cost_funct
    hold on
    
    counter_figs=counter_figs+1;
    names_of_figures{counter_figs}='Precision CV';
    
    title(names_of_figures{counter_figs},'fontsize',12)
    xlabel('lamda','fontsize',14) 
    ylabel(names_of_figures{counter_figs},'fontsize',14)
    
    
    plot(log10(lamda_vect), precision_vector_CV,'-.Vk','Markersize',M_size, 'displayname',dumb_name_legend);

    counter_figs=counter_figs+1;
    names_of_figures{counter_figs}='Recall CV';
    
    figure (5)  %%% lamda, cost_funct
    hold on
    
    
    title(names_of_figures{counter_figs},'fontsize',12)
    xlabel('lamda','fontsize',14) 
    ylabel(names_of_figures{counter_figs},'fontsize',14)
    
    plot(log10(lamda_vect), recall_vector_CV,'-.Vk','Markersize',M_size, 'displayname',dumb_name_legend);
    
    
    dumb_name_vectorized_plot = char(sprintf('%s_vectorized', dumb_iteration_name));
    
    cd(save_all_data_plot);  
    save (dumb_name_vectorized_plot);
    cd(ParentDirMain_plot);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save_plots=1;

if save_plots==1    %% save files automatically
    
    cd(save_all_data_plot);  
    
    for iii=1:counter_figs
        saveas(iii, char(names_of_figures(iii)),'fig')	
    end
    
    cd(ParentDirMain_plot);
end



