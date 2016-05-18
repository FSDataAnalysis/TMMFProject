function [vector_values, x, y, length_file_unrolled] = ReadOneFile(name_dumb_file, ...
   Re_organize_files)
 
    Mydata_To_Split=load (name_dumb_file);
   

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ZEx =1 ; DfEx =2 ; ZRet = 3;  DfRet = 4; AEx =5 ;  ARet =6 ; PEx =7 ;  PRet =8 ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %NumberOfFiles=cols/8;
    % 
    % 
    % %%%%%%%%%%%% If reorganize columns  is 1 it will set columns to standard

    
    if Re_organize_files==1
    
        Mydata_To_Split_dumb=Mydata_To_Split;
        Mydata_To_Split_original=Mydata_To_Split;

        foo_size=size(Mydata_To_Split_dumb);

        NNN=foo_size(2);
        MMM=NNN-8;   % all other data 
        TTT=MMM/2;   %% first zc, def   --- second A and P
        SSS=TTT/2;   %% First A ---- then P

        for yyy=1:((NNN/8)-1)

            Mydata_To_Split_dumb(:,(9+(yyy-1)*8):(9+3 +(yyy-1)*8))=Mydata_To_Split(:,(9+(yyy-1)*4):(9+3+(yyy-1)*4));   %%% zc and def
            Mydata_To_Split_dumb(:,(9+4 +(yyy-1)*8):(9+4+1+(yyy-1)*8))=Mydata_To_Split(:,(9+TTT+(yyy-1)*2):(9+TTT+1+(yyy-1)*2));  %%% Am ext Am ret
            Mydata_To_Split_dumb(:,(9+6 +(yyy-1)*8):(9+6+1 +(yyy-1)*8))=Mydata_To_Split(:,(9+TTT+SSS +(yyy-1)*2):(9+TTT+SSS+1+(yyy-1)*2));  %%% Am ext Am ret

        end

        Mydata_To_Split=Mydata_To_Split_dumb;
    end


   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   
   dumb_size=size(Mydata_To_Split);
   x=dumb_size(1,1); %% rows
   y=dumb_size(1,2); %% columns
   
   length_file_unrolled=x*y;
   
   vector_values=Mydata_To_Split(:);  %%% unroll
   
end