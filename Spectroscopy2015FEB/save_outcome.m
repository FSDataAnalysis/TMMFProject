

if main_counter_iteration==1
    
    cost_funct_CV_matrix=struct;
    error_function_matrix=struct;
    number_outputs_CV_matrix=struct;
    Precision_matrix=struct;
    Recall_matrix=struct;
    F_1_SCORE_matrix=struct;
    Not_asigned_matrix=struct;
    True_positive_matrix=struct;
    True_negative_matrix=struct;
    False_positive_matrix=struct;
    False_negative_matrix=struct;
    No_predicted_positives_matrix=struct;
    No_positives_matrix=struct;
    No_LAYERS_matrix=struct;
    lamda_matrix=struct;
    Precision_cut_off_matrix=struct;
    Recall_cut_off_matrix=struct;
    cost_funct_TS_matrix=struct;
    
    h_x_CV_matrix=struct;
    theta_number_matrix=struct;
end


dumb_name = char(sprintf('LAY_%i_U_%i_lamda_%i', No_LAYERS, No_UNITS, counter_lamda));
names=[names; dumb_name];

cost_funct_CV_matrix.(dumb_name)= jVal_CV;
error_function_matrix.(dumb_name)=error_function;
number_outputs_CV_matrix.(dumb_name)=number_outputs_CV;
Precision_matrix.(dumb_name)=Precision;
Recall_matrix.(dumb_name)=Recall;
F_1_SCORE_matrix.(dumb_name)=F_1_SCORE;
Not_asigned_matrix.(dumb_name)=Not_asigned;
True_positive_matrix.(dumb_name)=True_positive;
True_negative_matrix.(dumb_name)=True_negative;
False_positive_matrix.(dumb_name)=False_positive;
False_negative_matrix.(dumb_name)=False_negative;
No_predicted_positives_matrix.(dumb_name)=No_predicted_positives;
No_positives_matrix.(dumb_name)=No_positives;
No_LAYERS_matrix.(dumb_name)=No_LAYERS;
lamda_matrix.(dumb_name)=lamda;
Precision_cut_off_matrix.(dumb_name)=Precision_cut_off;
Recall_cut_off_matrix.(dumb_name)=Recall_cut_off;
cost_funct_TS_matrix.(dumb_name)=function_val;

h_x_CV_matrix.(dumb_name)=h_x_CV;
theta_number_matrix.(dumb_name)=theta_number;


% save ('iterative_outcome', '-append');

