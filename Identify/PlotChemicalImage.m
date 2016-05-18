trigger_high=7;
trigger_low=3;

floored_h_x=floor(h_x_CV*10);

Number_examples=length(floored_h_x(1, :));
Number_chemicals=length(floored_h_x(:, 1));

this=0;

Chemical_Number_vector=[];
 
    
for examples=1:Number_examples

    Number_of_positives=0;

    for chemical=1:Number_chemicals

        flag_positive_example_chemical=0;
        Chemical_Number=0;
        
        dummy=floored_h_x(chemical, examples);
        
        if floored_h_x(chemical, examples)> trigger_high

            flag_positive_example_chemical=1;
            Chemical_Number=chemical;

            for jj=1:Number_chemicals

                if jj~=chemical

                    if floored_h_x(jj, examples)> trigger_low

                        flag_positive_example_chemical=0.5;

                    end
                end
            end

            if flag_positive_example_chemical==1
                Chemical_Number_vector=[Chemical_Number_vector, Chemical_Number];
                break
            end

            if flag_positive_example_chemical==0.5
                Chemical_Number_vector=[Chemical_Number_vector, 0];
                break
            end

        end  % end positive found

%           
    end  %%% end chemicals

    if flag_positive_example_chemical==0

        Chemical_Number_vector=[Chemical_Number_vector, 0];
    end
             

end



ambiguous=find(Chemical_Number_vector==0);
L_ambiguous=length(ambiguous);

found_chem=struct;
L_chem=[];

for chemical=1:Number_chemicals
    
    dumb_name = char(sprintf('chemical%i', chemical));
 
    
    found_chem.(dumb_name)=find(Chemical_Number_vector==chemical);
    L_chem(chemical)=length(found_chem.(dumb_name));
end

This=0;

MakeImageRGB;

this=0;