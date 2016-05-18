%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LOOPING through LAYERS, UNITS and LAMDA below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;

%%%% No LAYERS iteration

if LAYER_optimize==1
    i_layer_n=0;

    for iii=1:1:(number_iterations_LAYER+1)
        i_layer_n(iii)=min_LAYER+(increase_LAYER_factor)*(iii-1);
    end

    for No_Of_LAYERS_iteration=min_LAYER:increase_LAYER_factor:max_LAYER

        No_LAYERS=No_Of_LAYERS_iteration;

        if UNIT_optimize==1
            i_layer_n=0;

            for iii=1:1:(number_iterations_UNIT+1)
                i_unit_n(iii)=min_UNIT+(increase_UNIT_factor)*(iii-1);
            end

            for No_Of_UNITS_iteration=min_UNIT:increase_UNIT_factor:max_UNIT

                No_UNITS=No_Of_UNITS_iteration;
                names=cell([],1);

                if lamda_optimize==1

                    i_l_n=0;

                    for iii=1:1:(number_iterations_lamda+1)
                        i_l_n(iii)=min_lamda*(increase_lamda_factor^(iii-1))
                    end

    %                 buffer_outcome_N=number_iterations_lamda+1;   
                    main_counter_iteration=0;

                    if lamda_zero_only==1
                        number_iterations_lamda=0;
                    end
                    for counter_lamda=1:(number_iterations_lamda+1)
                        
                          if lamda_zero_only==1
                            lamda=0;
                          else     
                             lamda=i_l_n(counter_lamda);
                          end
                         

                          main_architecture;


                          main_counter_iteration=main_counter_iteration+1;
                          save_outcome;

                          %%%%%%%%%%%% Loop to save minima %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                          saving_absolute_minima;

                          counter_of_iterations_ABSOLUTE=counter_of_iterations_ABSOLUTE+1;

                    end % End Iteration lamda


                    ParentDirMain=pwd;
                    %% In the SAVED_DATA directory all the data will be saved for each file
                    save_all_data=strcat(ParentDirMain,'\SAVED_DATA'); 
                    cd(save_all_data);
                    dumb_iteration_name = char(sprintf('LAYER_%i_UNITS_%i', No_LAYERS, No_UNITS));
                    save (dumb_iteration_name);
                    cd(ParentDirMain);

                end   % End if Optimize lamda

            end % End Iteration UNITS

        end   % End if Optimize UNITS

    end % End Iteration LAYER

end  % End if Optimize LAYER

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LOOPING through LAYERS, UNITS and LAMDA below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%