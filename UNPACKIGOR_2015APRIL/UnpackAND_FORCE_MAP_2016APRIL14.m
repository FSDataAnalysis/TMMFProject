%%% 2015 March 16 finished and updated by S Santos
%%% fPath for TXT folder produced by R script is now read automatically but
%%% it can be changed by uncommenting fPath below

%%% This script can unpack Igor files using R scripts
%%%% exec=system('Rscript.exe UnPackIgor.R')  to run R 
%%%% REQUIREMENT: PUT Rscript.exe into environment in windows, i.e. 
%%%% C:\Program Files\R\R-3.0.3\bin\x64
%%%%Takes files from a directory called FILES from IOGOR format to txt format

clear all;
clc;

%%% If do not shuffle files, it leaves sequence as is
prompt_main= {'Amplitude InVolts:', 'Name sample:', 'shufle files (0/1):', ...
    'Igor to text (0/1):', 'Sort in natural order (0/1):'};


dlg_title='Cantilever Inputs and processing';
num_lines=1;
default_main={'40e-9','File', '0', '1', '1'};  %% Paralel computing AND tuning other parameters 
          
answer_main=inputdlg(prompt_main,dlg_title,[1, length(dlg_title)+40], default_main); 

AmpV_nm= str2double(answer_main(1));					
name_sample= char(answer_main(2));		
shuffle_files=str2double(answer_main(3));
IgorToText=str2double(answer_main(4));
Sort_natural=str2double(answer_main(5));

if IgorToText==1   
    time_to_unpack_files_i=tic;
    exec_Igor_to_txt=system('Rscript.exe UnPackIgor.R')  %%% to run R 
    time_to_unpack_files=toc(time_to_unpack_files_i)
end

originaldir=pwd;
format shortEng
% The following code should be used for an automated process
% Select the folder containing all of the .txt files in the order you would
% like them to be analyzed- no subfolders!!

%%% could choose another
% % fPath = uigetdir('.', 'Select directory containing the files');
% % 
% % if fPath==0, error('no folder selected'),
% % 
% % end


fPath=strcat(originaldir, '\TXT');

if exist('NEW_TXT', 'dir')
    rmdir('NEW_TXT', 's');  %delete everything in it!
end
mkdir('NEW_TXT');

new_text_dir=strcat(originaldir,'\NEW_TXT');

tic    



Txt_files = dir(fullfile(fPath,'*.txt') );
name_cell={Txt_files.name};

if Sort_natural==1
    name_cell=sort_nat(name_cell);
end

nnn=length(name_cell);

if shuffle_files==1

   random_file=randperm(nnn);
    
end





parfor iii=1:nnn
    
    if shuffle_files==1
           
        char_IBWname=char(name_cell(random_file(iii))); %transfer the name into char
        
    else 
        
         char_IBWname=char(name_cell(iii)); %transfer the name into char
    end
    
    
    fMyTxtFile = strcat(fPath, filesep, char_IBWname);
    
    dummy_file=load (fMyTxtFile);     

    Z_c=dummy_file(:,1);
    
    L_Z_c=length(Z_c);
    
    if Z_c(1) < Z_c(floor(L_Z_c/5))  % means it goes up in zc!
        
        max_zc=max(Z_c);
        Zc_element_pos=find(Z_c==max_zc);
        
    else %% it goes down in zc
        
        min_zc=min(Z_c);
        Zc_element_pos=find(Z_c==min_zc);
        
    end
   
    Zc_element_pos=Zc_element_pos(1);
    Z_c_value=Z_c(Zc_element_pos);
    
    Z_c_value=Z_c_value(1);

    
    
    if Zc_element_pos < floor(L_Z_c/2)
        
        du=Zc_element_pos;
        du2=L_Z_c-du;
        difference=du2-du;
       

        dummy_zero=zeros(difference,1);
        
        Z_sensor_ext=[dummy_file(1:Zc_element_pos,1); dummy_zero];
       
        
        du2=length(dummy_file(Zc_element_pos+1:end,1));
         
        Z_sensor_ret=dummy_file(Zc_element_pos+1:end,1);
        
        rr=length(Z_sensor_ret);
        ee=length(Z_sensor_ext);
        
        
        
        def_ext=[(dummy_file(1:Zc_element_pos,4)/(AmpV_nm*1.09)); dummy_zero];
        def_ret=dummy_file(Zc_element_pos+1:end,4)/(AmpV_nm*1.09);
        
        Amp_V_ext=[dummy_file(1:Zc_element_pos,3)/(AmpV_nm); dummy_zero];
        Amp_V_ret=dummy_file(Zc_element_pos+1:end,3)/(AmpV_nm);
%         Amp_V_ext=[dummy_file(1:Zc_element_pos,3); dummy_zero];
%         Amp_V_ret=dummy_file(Zc_element_pos+1:end,3);
%         
        phase_ext=[dummy_file(1:Zc_element_pos,5); dummy_zero];
        phase_ret=dummy_file(Zc_element_pos+1:end,5);
        
        if rr~=ee
 
            Z_sensor_ext=Z_sensor_ret(1:end-1);
            def_ext=def_ext(1:end-1);
            Amp_V_ext=Amp_V_ext(1:end-1);
            phase_ext=phase_ext(1:end-1);
        end
        
    
    else
 
        Z_sensor_ext=dummy_file(1:Zc_element_pos,1);
        du=length(Z_sensor_ext);
        
        du2=length(dummy_file(Zc_element_pos+1:end,1));
        difference=du-du2;
        
      
        dummy_zero=zeros(difference,1);
        Z_sensor_ret=[dummy_file(Zc_element_pos+1:end,1); dummy_zero];
        
        rr=length(Z_sensor_ret);
        ee=length(Z_sensor_ext);
        
       
        
        def_ext=(dummy_file(1:Zc_element_pos,4)/(AmpV_nm*1.09));
        def_ret=[dummy_file(Zc_element_pos+1:end,4)/(AmpV_nm*1.09); dummy_zero];
        
        Amp_V_ext=dummy_file(1:Zc_element_pos,3)/AmpV_nm;
        Amp_V_ret=[dummy_file(Zc_element_pos+1:end,3)/AmpV_nm; dummy_zero];
        
        phase_ext=dummy_file(1:Zc_element_pos,5);
        phase_ret=[dummy_file(Zc_element_pos+1:end,5); dummy_zero];
        
         if rr~=ee
 
            Z_sensor_ret=Z_sensor_ret(1:end-1);
            def_ret=def_ret(1:end-1);
            Amp_V_ret=Amp_V_ret(1:end-1);
            phase_ret=phase_ret(1:end-1);
        end
    end
    
   

    matrix=[Z_sensor_ext,def_ext,Z_sensor_ret,def_ret,Amp_V_ext, Amp_V_ret, phase_ext, phase_ret];


    newFileName=sprintf('%s_No_%i.txt', name_sample, iii);
    
    
    cd(new_text_dir);
    dlmwrite(newFileName,matrix,'delimiter','\t');
    cd(originaldir);


end
toc

this=0;


