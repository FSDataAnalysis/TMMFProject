% clear all;
% load INITIAL_DATA;
% struct_clean=struct;
% struct_raw=struct;
% for iii=1:NNN_NumberOfSubFolders
%     
%     foo_name_pro=sprintf('%s_N_%i', 'PROCESSED_SETS', iii);    
%     
%     load (foo_name_pro);
%     
%     if iii==1
%         struct_clean=unpacked_Force_CLEAN; 
%         struct_raw=unpacked_Force_RAW;
%         
%     else
%         
%         struct_clean=[struct_clean, unpacked_Force_CLEAN];
%         struct_raw=[struct_raw, unpacked_Force_RAW];
%     end
%     
% end