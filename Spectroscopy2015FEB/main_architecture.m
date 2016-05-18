load input_TRAINING;

X=Input;
Y=Output;

initialize_theta_epsilon=0.1;


%%% Options of optimization algorithm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


options = optimset('GradObj', 'on', 'MaxIter', max_number_iterations );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Establish Number of thetas, UNITS and LAYERS 

NetworkParameters;


%%% minimize COST FUNCTION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[opt_theta, function_val, exit_flag] = fminunc(@costFunct, ...
         initialize_theta_Vector, options);

     
%%%  ROLL thetas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 theta_number=struct;
 index_theta=0;
    
for NL=1:(No_LAYERS-1)


    dumb_layer = char(sprintf('LAYER_%i', NL));

    start_index=index_theta;
    end_index_is=start_index+length_UNITS_ZETAS_LAYER(NL);

    if NL~=length(No_theta)
        theta_number.(dumb_layer)=reshape(opt_theta(start_index+1:end_index_is), ...
            (No_UNITS_LAYER{NL+1}-1),No_UNITS_LAYER{NL});       
    else
        theta_number.(dumb_layer)=reshape(opt_theta(start_index+1:end_index_is), ...
            (No_UNITS_LAYER{NL+1}),No_UNITS_LAYER{NL});   
    end

    index_theta=end_index_is;

end  

if save_output_from_training_set==1
    
    dumb_name_training_set_each = char(sprintf('TRAINING_LAY_%i_U_%i_lamda_%i', No_LAYERS, No_UNITS, counter_lamda));
    
    cd(save_training_folder);
    save (dumb_name_training_set_each);
    cd(ParentDirMain);
      
end

[jVal_CV, error_function, number_outputs_CV, Precision, Recall, ...
    F_1_SCORE, Not_asigned, True_positive, True_negative, False_positive, False_negative, ...
    No_predicted_positives, No_positives, h_x_CV] = CV_set ...
    (No_LAYERS, theta_number, lamda, Precision_cut_off, Recall_cut_off);




