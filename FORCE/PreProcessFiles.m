clear all;
clc;



originaldir=pwd;
format shortEng
%The following code should be used for an automated process
% Select the folder containing all of the .txt files in the order you would
% like them to be analyzed- no subfolders!!
fPath = uigetdir('.', 'Select directory containing the files');
if fPath==0, error('no folder selected'), end
fMyTxtFile = dir(fullfile(fPath,'*.txt') );
fMyTxtFile = strcat(fPath, filesep, {fMyTxtFile.name});


[pathstr, name, ext]=fileparts(fMyTxtFile{1});

Mydata_To_Split=load(fMyTxtFile{1});

columns=size(Mydata_To_Split);
cols=columns(1,2);



%%%%%%%%%% choose to cut zeros at extension or retraction %%%%%%%%%%%%

prompt= {'Extension (0) / Retraction (1):','Organize columns (0/1):'};
dlg_title='Inputs: Organize 1 only if "Cypher shift collected"';
num_lines=1;
default={'0', '0'};
answer=inputdlg(prompt,dlg_title,num_lines,default);

%%%%%%% Data on outliers/or start and end of vectors %%%%%%%%%%%%%%%%%%%%%%

Extension= str2double(answer(1));     % If this value is zero it takes 

%%%% standard %%%%
% ZEx =1 ; DfEx =2 ; ZRet = 3;  DfRet = 4; AEx =5 ;  ARet =6 ; PEx =7 ;  PRet =8 ;

%NumberOfFiles=cols/8;


%%%%%%%%%%%% If reorganize columns  is 1 it will set columns to standard
%%%%%%%%%%%% above
Re_organize= str2double(answer(2));

if Re_organize==1
    
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

file_number_name=struct; 

%%% choose the rows that are of interest, i.e. extension or retraction 
if Extension==0
     fff=[1 2 5 7];      
elseif Extension==1
    fff=[3 4 6 8];
else
    fff=[1 2 5 7]; 
end


flag_is=0;

for ppp=1:8:cols
   
    filenumb_dumb = round((ppp+8)/8)
    file_name = sprintf( 'file%u',  filenumb_dumb )
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

    newFileName = sprintf('m_%s.txt', file_name)   
    dlmwrite(newFileName, dumb2, '\t')
    
end   



