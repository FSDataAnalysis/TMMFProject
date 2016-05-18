% Choose a directory where to shuffle file No
clear all; clc;
originaldir=pwd;
format shortEng
% The following code should be used for an automated process
% Select the folder containing all of the .txt files in the order you would
% like them to be analyzed- no subfolders!!

prompt_main= {'Sample:', 'shuffle'};


dlg_title='Cantilever Inputs and processing';
num_lines=1;
default_main={'Sample', '1'};  %% Paralel computing AND tuning other parameters 
          
answer_main=inputdlg(prompt_main,dlg_title,[1, length(dlg_title)+40], default_main); 

					
new_name_sample= char(answer_main(1));	
shuffle=str2double(answer_main(2));	

fPath = uigetdir('.', 'Select directory containing the files');

if fPath==0, error('no folder selected'),

end

FilesToShuffle = dir(fullfile(fPath,'*.txt') );

name_cell={FilesToShuffle.name};

name_cell=sort_nat(name_cell);

nnn2=length(name_cell);


random_file=randperm(nnn2);

cd(fPath);

for iii=1:nnn2
    

    % Get the file name (minus the extension)
    
   [~, f] =fileparts(char(name_cell(random_file(iii))));
%     = fileparts(files(id).name);
      % Convert to number

          % If numeric, rename
   
    
   if shuffle~=1
      movefile(char(name_cell(iii)), sprintf('%s_Not_Shuffled_No_%i.txt',new_name_sample, iii)); 
   else
       movefile(char(name_cell(random_file(iii))), sprintf('%s_Shuffled_No_%i.txt',new_name_sample, iii));
   end
end

cd(originaldir);

this=0;