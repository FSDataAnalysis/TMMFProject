

dumb_min_Cost_funct=jVal_CV;
dumb_min_err_funct=error_function;

dumb_min_precision=Precision;
dumb_min_recall=Recall;
dumb_min_F_1_SCORE=F_1_SCORE;


 
if counter_of_iterations_ABSOLUTE==1
    
    best_No_LAYERS_No_UNITS=dumb_name;
    
    min_cost_funct=dumb_min_Cost_funct;
    min_err_funct=dumb_min_err_funct;
    min_precision=dumb_min_precision;
    min_recall=dumb_min_recall;
    min_F_1_SCORE=dumb_min_F_1_SCORE;
    
    save ('OPTIMUM_DATA_cost', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE');
    save ('OPTIMUM_DATA_error', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE');
    save ('OPTIMUM_DATA_F_1_score', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE');
    save ('OPTIMUM_DATA_precision', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE');
    save ('OPTIMUM_DATA_recall', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE');
    
    
else
    
        
         %% save new 
        best_No_LAYERS_No_UNITS=dumb_name;
        min_cost_funct=dumb_min_Cost_funct;
        min_err_funct=dumb_min_err_funct;
        min_precision=dumb_min_precision;
        min_recall=dumb_min_recall;
        min_F_1_SCORE=dumb_min_F_1_SCORE;

    if min_cost_funct> dumb_min_Cost_funct
        save ('OPTIMUM_DATA_cost', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE', '-append');
    end
    
    if min_err_funct > dumb_min_err_funct
        save ('OPTIMUM_DATA_error', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE', '-append');
    end
    
       
    if min_F_1_SCORE < dumb_min_F_1_SCORE
        save ('OPTIMUM_DATA_F_1_score', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE', '-append');
    end
    
       
    if min_precision < dumb_min_precision
        save ('OPTIMUM_DATA_precision', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE', '-append');
    end
    
       
    if min_recall < dumb_min_recall
        save ('OPTIMUM_DATA_recall', 'best_No_LAYERS_No_UNITS', 'lamda', 'min_cost_funct', ...
        'min_err_funct', 'min_precision', 'min_recall', 'min_F_1_SCORE', '-append');
    end
 
end
        
                                      
