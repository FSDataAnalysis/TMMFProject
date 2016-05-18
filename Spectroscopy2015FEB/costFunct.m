function [jVal, gradient]=costFunct(theta)  

    %%%% load parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load vectors_samples;  %%% These are the examples in X and Y
    No_examples=length(Y(1,:));
    K_Output=length(Y(:,1));
    
    %%% 1. Roll matrix thetas      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    theta_number=struct;
    index_theta=0;
    
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
        
        dumb_layer = 'LAYER_2';
        dumb_layer_minus_1 = 'LAYER_1';
        
        z.(dumb_layer)=theta_number.(dumb_layer_minus_1)*a.(dumb_layer_minus_1);

        a_ACTIVATIONS.(dumb_layer)=1./(1+exp(- z.(dumb_layer))); 
        a.(dumb_layer)=[a_UNIT_0_L1; a_ACTIVATIONS.(dumb_layer)];
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
    dc=1;
    
    jVal=-1/No_examples* sum((sum(dc*Y.*(log(h_x)) + ...
         (1-Y).*(log(1-h_x))))) + ...
         (lamda/(2*No_examples))*(sum_thetas);
    
   
    %%% 4. BACK Propagation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Analytic Formulae %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%% deltas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    delta=struct;
    g_prime_z=struct; 
    
    dumb_layer = char(sprintf('LAYER_%i',No_LAYERS));
    delta.(dumb_layer)=h_x-Y;
    
    if (No_LAYERS>2) 
        
        for NL=(No_LAYERS-1):-1:2

                dumb_layer = char(sprintf('LAYER_%i', NL));
                dumb_layer_plus_1 = char(sprintf('LAYER_%i', (NL+1)));
                
                g_prime_z.(dumb_layer)=a_ACTIVATIONS.(dumb_layer).*(1-a_ACTIVATIONS.(dumb_layer));
                delta.(dumb_layer)=((theta_number.(dumb_layer)(:,2:end)')*delta.(dumb_layer_plus_1)).*g_prime_z.(dumb_layer);  


        end    
    else  %% ONLY TWO LAYERS
        
        dumb_layer = 'LAYER_1';
        dumb_layer_plus_1 = 'LAYER_2';
                
        g_prime_z.(dumb_layer)=a_ACTIVATIONS.(dumb_layer).*(1-a_ACTIVATIONS.(dumb_layer));
        delta.(dumb_layer)=((theta_number.(dumb_layer)(:,2:end)')*delta.(dumb_layer_plus_1)).*g_prime_z.(dumb_layer);  
        
    end 
   
    %% DELTAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    DELTA=struct;
    
    if (No_LAYERS>2) 
        
        for NL=(No_LAYERS-1):-1:1

                dumb_layer = char(sprintf('LAYER_%i', NL));
                dumb_layer_plus_1 = char(sprintf('LAYER_%i', (NL+1)));
                
                DELTA.(dumb_layer)=delta.(dumb_layer_plus_1)*a.(dumb_layer)';
                

        end    
    else  %% ONLY TWO LAYERS
        
        dumb_layer = 'LAYER_1';
        dumb_layer_plus_1 = 'LAYER_2';
                
        DELTA.(dumb_layer)=delta.(dumb_layer_plus_1)*a.(dumb_layer)';
        
    end 
       

    %%% 5. DERIVATIVES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Analytic Formulae %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Der_ZERO=struct;
    Der=struct;
    
    if (No_LAYERS>2) 
        
        for NL=(No_LAYERS-1):-1:1

                dumb_layer = char(sprintf('LAYER_%i', NL));
                
                Der_ZERO.(dumb_layer)=(1/(No_examples))*(DELTA.(dumb_layer)(:,1));
                Der.(dumb_layer)=(1/(No_examples))*((DELTA.(dumb_layer)(:,2:end))) ...
                    +lamda*(theta_number.(dumb_layer)(:,2:end));
   
        end    
    else  %% ONLY TWO LAYERS
        
        dumb_layer ='LAYER_1';
                
        Der_ZERO.(dumb_layer)=(1/(No_examples))*(DELTA.(dumb_layer)(:,1));
        Der.(dumb_layer)=(1/(No_examples))*((DELTA.(dumb_layer)(:,2:end))) ...
               +lamda*(theta_number.(dumb_layer)(:,2:end));
    end 
   
    
    %%% 6. Roll Derivatives 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    gradient=[];
    
    for NL=1:(No_LAYERS-1)
  
        dumb_layer = char(sprintf('LAYER_%i', NL));
        gradient=[gradient; Der_ZERO.(dumb_layer)(:); Der.(dumb_layer)(:)];
 
    end   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Numeric formulae %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if activate_numeric_gradient==1
        
        %%% Analytic gradient to check against 
        gradient_analytic_check=gradient;
        
        
        %%% Unrolled theta
        theta_check=theta; 
        Length_theta=length(theta);
        numeric_gradient=zeros(Length_theta,1);
        
        for ttt=1:Length_theta
        
            theta_plus=theta_check;
            theta_minus=theta_check;
            
            theta_plus(ttt)=theta_plus(ttt)+epsilon_gradient;
            theta_minus(ttt)=theta_plus(ttt)-epsilon_gradient;
            
            [numeric_gradient_dumb]=calculate_numeric_gradient(theta_plus, theta_minus, epsilon_gradient, ...
                length_UNITS_ZETAS_LAYER, No_UNITS_LAYER, X, Y, ...
                lamda, No_LAYERS, No_theta, No_examples);
            
            numeric_gradient(ttt)=numeric_gradient_dumb;
 
        end
        
        if use_numeric_gradient==1
            
            gradient=0;
            gradient=numeric_gradient;
        end
    end
    
end