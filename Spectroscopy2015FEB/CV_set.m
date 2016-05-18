
% clear all; clc;
% load output_training_set;

function [jVal_CV, error_function, number_outputs_CV, Precision, Recall, ...
    F_1_SCORE, Not_asigned, True_positive, True_negative, False_positive, False_negative, ...
    No_predicted_positives, No_positives, h_x_CV] = CV_set ...
    (No_LAYERS, theta_number, lamda, Precision_cut_off, Recall_cut_off)

    load input_CV;

    %%% 1. FORWARD PROPAGATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

    a=struct;
    a_ACTIVATIONS=struct;
    z=struct;

    a_ACTIVATIONS.('LAYER_1')=X_CV;
    No_examples=length(X_CV(1, :));
    a_LAYER_1_zero=ones(1,No_examples);


    a.('LAYER_1')= [a_LAYER_1_zero; a_ACTIVATIONS.('LAYER_1')];

    for NL=1:(No_LAYERS-1)

        dumb_layer = char(sprintf('LAYER_%i', NL));
        dumb_layer_plus_1 = char(sprintf('LAYER_%i', (NL+1)));

        z.(dumb_layer_plus_1)=theta_number.(dumb_layer)*a.(dumb_layer);


        a_ACTIVATIONS.(dumb_layer_plus_1)=1./(1+exp(-z.(dumb_layer_plus_1)));

        a.(dumb_layer_plus_1)=[a_LAYER_1_zero; a_ACTIVATIONS.(dumb_layer_plus_1)];

    end

    h_x_CV= a.(dumb_layer_plus_1)(2:end, :);


    %%% 2. COST FUNCTION 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    %%%% SUM of thetas %%%%%%%%%%%%

    sum_thetas=0;

    for zzz=1:(No_LAYERS-1)

        foo_layer = char(sprintf('LAYER_%i', zzz));
        sum_thetas=sum_thetas+ sum(sum(theta_number.(foo_layer)(:,2:end).^2));

    end


    %%%% Cost Function jVal %%%%%%%%%%%%
    %%%% Sums over examples in y and over outputs in y (K classifications). 

    jVal_CV_dumb=-1/No_examples* sum((sum(Y_CV.*(log(h_x_CV)) + ...
        (1-Y_CV).*(log(1-h_x_CV))))) + ...
        (lamda/(2*No_examples))*(sum_thetas);

    jVal_CV=jVal_CV_dumb;
    
    
    %%% Error function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% AND PRECISION-RECALL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    error_function_dumb=0;
    precision=0;
    recall=0;
    
    True_positive=0;
    True_negative=0;
    False_positive=0;
    False_negative=0;
    
    Not_asigned=0;
    
    
    for n_c=1:length(h_x_CV(1,:))
        
        for n_r=1:length(h_x_CV(:,1))
        
            if  ((h_x_CV(n_r, n_c)>=Precision_cut_off))&&(Y_CV(n_r,n_c)==0)

                 error_function_dumb=error_function_dumb+1;
                
                 False_positive=False_positive+1;

            elseif ((h_x_CV(n_r, n_c) <= (Recall_cut_off)))&&(Y_CV(n_r,n_c)==1)

                 error_function_dumb=error_function_dumb+1;
                 
                 False_negative=False_negative+1;
                 
            elseif ((h_x_CV(n_r, n_c)  <= (Recall_cut_off)))&&(Y_CV(n_r,n_c)==0)

                True_negative=True_negative+1;
             
            elseif ((h_x_CV(n_r, n_c)>=Precision_cut_off))&&(Y_CV(n_r,n_c)==1)
                
                True_positive=True_positive+1;
            else
                Not_asigned=Not_asigned+1;
            end
                
        end
    end    
    
    No_predicted_positives=0;
    No_positives=0;
    
    for n_c=1:length(h_x_CV(1,:))
        
        for n_r=1:length(h_x_CV(:,1))
            
            if h_x_CV(n_r, n_c)>=Precision_cut_off
            
                No_predicted_positives=No_predicted_positives+1;
            end
            
            if Y_CV(n_r, n_c)==1
            
                No_positives=No_positives+1;
            end
            
         end
    end 
    
    %%% error function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    number_outputs_CV_dumb=size(Y_CV);
    
    number_outputs_CV=number_outputs_CV_dumb(1,1)*number_outputs_CV_dumb(1,2);
    error_function=1/(number_outputs_CV)*error_function_dumb;

    %%% F_1_SCORE- PRECISION AND RECALL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    No_predicted_positives_summation=True_positive+False_positive;
    
    if No_predicted_positives_summation==0
        Precision=1;
    else
        Precision=True_positive/(No_predicted_positives_summation);
    end
    
    No_actual_positives_summation=True_positive+False_negative;
    
    if No_actual_positives_summation==0
        Recall=1;
    else
        Recall=True_positive/(No_actual_positives_summation);
    end
    
    if (Precision+Recall)==0
        F_1_SCORE=0;
    else
        F_1_SCORE=2*(Precision*Recall)/(Precision+Recall);
    end
end
