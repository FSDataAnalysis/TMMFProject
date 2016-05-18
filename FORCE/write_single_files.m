function [dummy_files_vector, dummy_rows_vector, dummy_cols_vector, ...
    dummy_length_file_unrolled, names_of_single_file]= ...
    write_single_files(ppp_8, Mydata_To_Split, ...
     file_name_dumb, fff, saving_single_text_files)

        ppp=(ppp_8-1)*8+1;
        
        filenumb_dumb = round((ppp+8)/8);

        if filenumb_dumb < 10                                  %%%% Edited by YO, putting the file in correct order
            file_name = sprintf( 'file_000%u',  filenumb_dumb );   
            file_name=strcat(file_name_dumb, file_name);
        elseif filenumb_dumb < 100
            file_name = sprintf( 'file_00%u',  filenumb_dumb );
            file_name=strcat(file_name_dumb, file_name);
        elseif filenumb_dumb < 1000
            file_name = sprintf( 'file_0%u',  filenumb_dumb );
            file_name=strcat(file_name_dumb, file_name);
        else
            file_name = sprintf( 'file_%u',  filenumb_dumb );
            file_name=strcat(file_name_dumb, file_name);
        end

        file_number_name.(file_name)=Mydata_To_Split(:,ppp:ppp+7);


        dumb=file_number_name.(file_name);   % current file matrix
        dumb2=dumb;

        minimum_zero_raw=10e12;

        %%% This loop crops zeros of each file 
        for xxx=fff


            element_is = find(dumb2(:,xxx)==0);

            if ~isempty(element_is)
                if element_is(1)<minimum_zero_raw
                    minimum_zero_raw=element_is(1);
                    flag=1;
                end          
            end

        end

        if minimum_zero_raw==10e12
            flag=0;
        end

        if flag==1
            dumb2=dumb(1:(minimum_zero_raw-1),:);
        end

        
        newFileName = sprintf('%s.txt', file_name); 
        
        dummy_files_vector=dumb2(:);
        
        LLL_size_dummy_files_vector=size(dumb2);
        
        dummy_rows_vector=LLL_size_dummy_files_vector(1,1);
        dummy_cols_vector=LLL_size_dummy_files_vector(1,2);
        
        dummy_length_file_unrolled=length(dummy_files_vector);
        names_of_single_file=newFileName;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if saving_single_text_files==1
            if ~exist('DONE_FILES', 'dir')
                mkdir('DONE_FILES');  
            end

            direct_main=pwd;
            char_dumb='\DONE_FILES';
            directory_TEXT_FILES=strcat(direct_main,char_dumb);
            cd(directory_TEXT_FILES);    
            dlmwrite(newFileName, dumb2, '\t');
            cd(direct_main); 
        end
        
        
end
