   
add_adhesion_parameter=0;
add_adhesion_parameter_norm=0;
tip_radius=10e-9;
%%%Increase_by_normalized=3;

No_LAYERS=2;  %%%% CHOOSE NUMBER OF :LAYERS
theta_number=theta_number_matrix.LAY_2_U_2_lamda_3;    %%% Choose LAYERS
% UNITS AND LAMDA CALCITE EXAMPLE

% theta_number=theta_number_matrix.LAY_2_U_2_lamda_2;   EXAMPLE CALCITE
% 
% theta_number=theta_number_matrix.LAY_4_U_4_lamda_2;
% 

%% NEED TO BE THE SAME AS THOSE USED TO MAKE SETS FOR MODEL Neural network

answer_main={'2', '1', '1', '0'};

Start_normalize_row= str2double(answer_main(1));
Increase_by_normalized= str2double(answer_main(2));
divisor_mean= str2double(answer_main(3));
End_normalize_row=str2double(answer_main(4));

Percentages_found= unique(dFAD_matrix_Percentage_FILES(:,1));
No_percentages=length(Percentages_found);

if No_percentages~=10
    display('The data does not have 10 values of dFAD');
    error('msgString');
end


NORMALIZE_STATS_INPUT;

%%%%%%%%%%%%%%%%
a=struct;
a_ACTIVATIONS=struct;
z=struct;


a_ACTIVATIONS.('LAYER_1')=X_CV(2:end, :);
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
  
%%%% OUTPUT 
h_x_CV= a.(dumb_layer_plus_1)(2:end, :);


this=0;
