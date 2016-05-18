function [numeric_gradient_calc]=calculate_numeric_gradient(theta_plus, theta_minus, epsilon, ...
            length_UNITS_ZETAS_LAYER, No_UNITS_LAYER, X, Y, ...
            lamda, No_LAYERS, No_theta, No_examples)
    
    %%% 1. Roll matrix thetas      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    theta_dumb=[theta_plus, theta_minus];
    
    for counter=1:2
    
        theta_number=struct;
        index_theta=0;
        
        theta=theta_dumb(:,counter);

        for NL=1:(No_LAYERS-1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            dumb_layer = char(sprintf('LAYER_%i', NL));

            start_index=index_theta;
            end_index_is=start_index+length_UNITS_ZETAS_LAYER(NL);

            if NL~=length(No_theta)
                theta_number.(dumb_layer)=reshape(theta(start_index+1:end_index_is), ...
                    (No_UNITS_LAYER{NL+1}-1),No_UNITS_LAYER{NL});       
            else
                theta_number.(dumb_layer)=reshape(theta(start_index+1:end_index_is), ...
                    (No_UNITS_LAYER{NL+1}),No_UNITS_LAYER{NL});   
            end

            index_theta=end_index_is;

        end


        %%% 2.  FORWARD Propagation    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %%%%%% Forward Propagation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        a=struct;
        a_ACTIVATIONS=struct;
        z=struct;

        a_UNIT_0_L1=ones(1,No_examples);

        a.('LAYER_1')=[a_UNIT_0_L1; X];
        a_ACTIVATIONS.('LAYER_1')=X;

        if (No_LAYERS>2) 

            for NL=2:No_LAYERS

                dumb_layer = char(sprintf('LAYER_%i', NL));
                dumb_layer_minus_1 = char(sprintf('LAYER_%i', (NL-1)));

                z.(dumb_layer)=theta_number.(dumb_layer_minus_1)*a.(dumb_layer_minus_1);

                a_ACTIVATIONS.(dumb_layer)=1./(1+exp(- z.(dumb_layer))); 
                a.(dumb_layer)=[a_UNIT_0_L1; a_ACTIVATIONS.(dumb_layer)];

            end

        else  %% ONLY TWO LAYERS

        end    

        last_dumb_layer = char(sprintf('LAYER_%i', No_LAYERS));

        dumm_final=a.(last_dumb_layer);
        h_x=dumm_final(2:end, :);


        %%% 3. COST FUNCTION 
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
     
        jVal_dumb(counter)=-1/No_examples* sum((sum(Y.*(log(h_x)) + ...
            (1-Y).*(log(1-h_x))))) + ...
            (lamda/(2*No_examples))*(sum_thetas);
    
        
    end %%% LOOPING for theta_minus and theta_plus
    
    numeric_gradient_calc= (jVal_dumb(1)-jVal_dumb(2))/(epsilon);
    
end