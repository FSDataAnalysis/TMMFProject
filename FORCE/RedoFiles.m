%%% this file processes the files from the Cypher Asylum Research

% tic

if ~ProcessFiles_main==0   
    
    rolled_values =[];
    rows_files=[];
    col_files=[];
    length_file_unrolled=[];


    parfor No_raw_files=1:How_many_raw_files

      %%%%%%%%% function that partitions files %%%%%%%%%%%%%%%%%%%%%%%%%%%
      [rolled_values_dumb, rows_file_dumb, col_files_dumb, ...
           length_file_unrolled_dumb]= ...
      ReadOneFile(RawFileName_path{No_raw_files}, ...
      Re_organize_files); 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      rolled_values=[rolled_values; rolled_values_dumb];
      rows_files=[rows_files, rows_file_dumb];

      col_files=[col_files, col_files_dumb];
      length_file_unrolled=[length_file_unrolled, length_file_unrolled_dumb];

    end

    % time_to_load_files=toc

    values_files=struct;

    % tic;
    initial_value=1;

    %%%% save into original files BUT organized %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for iii=1: How_many_raw_files


        if iii < 10                                   
            file_name_dumb = sprintf( 'Meta_000%i',  iii );
        elseif iii < 100
            file_name_dumb = sprintf( 'Meta_00%i',  iii );
        elseif iii < 1000
            file_name_dumb = sprintf( 'Meta_0%i',  iii );
        else
            file_name_dumb = sprintf( 'Meta_%i',  iii );
        end

        final_value=initial_value+col_files(iii)*rows_files(iii)-1;
        values_files.(file_name_dumb)=reshape(rolled_values(initial_value:final_value), ...  
             rows_files(iii), col_files(iii));
        initial_value=final_value+1;
    end  % % time_to_resize_metafiles=toc

    % All files are single files  from the begining and all well set 

    %%%%% Save files into individual file names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% choose the rows that are of interest, i.e. extension or retraction 

    if Extension_answer==0
         fff=[1 2 5 7];      
    elseif Extension_answer==1
        fff=[3 4 6 8];
    else
        fff=[1 2 5 7]; 
    end



    if exist('DONE_FILES', 'dir')
        rmdir('DONE_FILES', 's');  %delete everything in it!
    end

    % tic

    %%%%%% rolled single file information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    single_file_rolled_ALL=[];
    single_file_rows_ALL=[];
    single_file_cols_ALL=[];
    single_file_length_ALL=[];
    single_file_name_ALL=[];

    for lll=1:length(RawFileName_path)

        %%% alows up to 10 thousand meta_files
        if lll < 10                                   
            file_name_dumb = sprintf( 'Meta_000%i',  lll );
        elseif lll < 100
            file_name_dumb = sprintf( 'Meta_00%i',  lll );
        elseif lll < 1000
            file_name_dumb = sprintf( 'Meta_0%i',  lll );
        else
            file_name_dumb = sprintf( 'Meta_%i',  lll );
        end


        Mydata_To_Split=values_files.(file_name_dumb);

        columns=size(Mydata_To_Split);

        cols=columns(1,2);

        flag_is=0;

        cols_rounded=floor(cols/8);


        single_file_rolled =[];
        single_file_rows=[];
        single_file_cols=[];
        single_file_length=[];
        single_file_name=[];

        parfor ppp_8=1:cols_rounded

            %%%%% make individual file sets to process %%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [dummy_files_vector, dummy_rows_vector, dummy_cols_vector, ...
            dummy_length_file_unrolled, names_of_single_file]= ...
                write_single_files(ppp_8, Mydata_To_Split, ...
            file_name_dumb, fff, saving_single_text_files);
            %%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            single_file_rolled=[single_file_rolled; dummy_files_vector];
            single_file_rows=[single_file_rows, dummy_rows_vector];
            single_file_cols=[single_file_cols, dummy_cols_vector];
            single_file_length=[single_file_length, dummy_length_file_unrolled];
            single_file_name=[single_file_name; names_of_single_file];
        end

        single_file_rolled_ALL=[single_file_rolled_ALL; single_file_rolled];
        single_file_rows_ALL=[single_file_rows_ALL, single_file_rows];
        single_file_cols_ALL=[single_file_cols_ALL, single_file_cols];
        single_file_length_ALL=[single_file_length_ALL, single_file_length];
        single_file_name_ALL=[single_file_name_ALL; single_file_name];

    end

    display('Single files have been generated');
    single_file_name_ALL=single_file_name_ALL(:,1:end-4);
    % time_to_write_files=toc

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Resize sigle vectors %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % tic

    data_single_file=struct;

    % tic;
    initial_value_single=1;

    LLL_length_No_files=length(single_file_length_ALL);

    %%%% save into original files BUT organized %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for iii=1: LLL_length_No_files

        foo_name=single_file_name_ALL(iii, :);

        final_value_single=initial_value_single + ...
            single_file_cols_ALL(iii)*single_file_rows_ALL(iii)-1;

        single_meta_file.(foo_name)= ...
            reshape(single_file_rolled_ALL(initial_value_single:final_value_single), ...  
             single_file_rows_ALL(iii), single_file_cols_ALL(iii));
        initial_value_single=final_value_single+1;
    end

else %% No need to rearrange text files since they are single files

    % tic;
    initial_value=1;

    %%%% save into original files BUT organized %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    LLL_length_No_files=How_many_raw_files;
    for iii=1: How_many_raw_files


        if iii < 10                                   
            file_name_dumb = sprintf( 'File_0000%i',  iii );
        elseif iii < 100
            file_name_dumb = sprintf( 'File_000%i',  iii );
        elseif iii < 1000
            file_name_dumb = sprintf( 'File_00%i',  iii );
        elseif iii < 10000
            file_name_dumb = sprintf( 'File_0%i',  iii );
        else
            file_name_dumb = sprintf( 'File_%i',  iii );
        end
        
        Mydata_To_Split=load(RawFileName_path{iii});
        
        single_file_name_ALL_dumb{iii}=file_name_dumb;
        single_meta_file.(file_name_dumb)=Mydata_To_Split;
    end
    
    single_file_name_ALL=char(single_file_name_ALL_dumb(:));
end
% time_is=toc



