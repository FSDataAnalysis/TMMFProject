%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Parameters of the Network: Interface_1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LAYERS 

No_UNITS_LAYER= cell(1, No_LAYERS);

%%% LAYER 1
activation_units_L1=length(Input(:,1));
No_UNITS_LAYER{1}=activation_units_L1+1;


%%% INTERMEDIATE LAYERS 

for NL=2:1:(No_LAYERS-1)   
    
    if activate_n_units_hidden_layer==1
        
        No_UNITS_LAYER{NL}=Hidden_UNITS(NL-1)+1;
    else
        
        No_UNITS_LAYER{NL}=No_UNITS+1;
    end
   
end

No_UNITS_LAYER{No_LAYERS}=length(Y(:,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% THETAS 

%%% Initialize thetas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Names 

No_theta=[];
initialize_theta_Vector=[];
initialize_theta=struct;

for NL=1:(No_LAYERS-1)  
    
    foo_name_L = char(sprintf('LAYER_%i', NL));
   
    if NL~=(No_LAYERS-1) 
        initialize_theta.(foo_name_L)=rand(Rstream, ...
            No_UNITS_LAYER{NL+1}-1,No_UNITS_LAYER{NL})*(2*initialize_theta_epsilon)-initialize_theta_epsilon;
    else
        initialize_theta.(foo_name_L)=rand(Rstream, ...
            No_UNITS_LAYER{NL+1},No_UNITS_LAYER{NL})*(2*initialize_theta_epsilon)-initialize_theta_epsilon;
    end
     
    LL_dumb=size(initialize_theta.(foo_name_L));
    length_UNITS_ZETAS_LAYER(NL)=LL_dumb(1)*LL_dumb(2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Unroll thetas 
    
    foo_name_theta = char(sprintf('theta_LAYER_%i', NL));
    No_theta{NL}=foo_name_theta;
    
    initialize_theta_Vector=[initialize_theta_Vector; initialize_theta.(foo_name_L)(:)];
end



%%% Saves inputs and outputs in X and Y under vectors_samples and Number of UNITS AND LAYERS 

save vectors_samples;