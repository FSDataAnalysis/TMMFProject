

unrolled_forces_Stats=[];
unrolled_d_min_Stats=[];

LLL_unrolled_forces_Stats=[];
LLL_cumulative_forces_Stats=[];

%   NOT NEEDED, EQUIVALENT TO Forces
% LLL_unrolled_d_min_Stats=[];
%   NOT NEEDED, EQUIVALENT TO Forces
% LLL_cumulative_d_min_Stats=[];

for No_files=1:LLL_stats
    
  unrolled_forces_Stats=[unrolled_forces_Stats; ...
    unpacked_Force_CLEAN.(vector_of_names_files{No_files})(:,smooth_force_col)];

  dumb_length_forces=length(unpacked_Force_CLEAN.(vector_of_names_files{No_files})(:,smooth_force_col));

  LLL_unrolled_forces_Stats=[LLL_unrolled_forces_Stats; dumb_length_forces];
  
  if No_files==1 
    LLL_cumulative_forces_Stats=[LLL_cumulative_forces_Stats; dumb_length_forces];
  else
    LLL_cumulative_forces_Stats=[LLL_cumulative_forces_Stats; ...
        (LLL_cumulative_forces_Stats(No_files-1)+dumb_length_forces)];
  end
    
  
  
  unrolled_d_min_Stats=[unrolled_d_min_Stats; ...
      unpacked_Force_CLEAN.(vector_of_names_files{No_files})(:,d_min_mean_col)];
  
%   NOT NEEDED, EQUIVALENT TO Forces
%   dumb_length_d_min=length(unpacked_Force_CLEAN.(vector_of_names_files{No_files})(:,d_min_mean_col));
%   
%   LLL_unrolled_d_min_Stats=[LLL_unrolled_d_min_Stats; dumb_length_d_min];
      
%   NOT NEEDED, EQUIVALENT TO Forces
%   if No_files==1 
%     LLL_cumulative_d_min_Stats=[LLL_cumulative_d_min_Stats; dumb_length_d_min];
%   else
%   
%     LLL_cumulative_d_min_Stats=[LLL_cumulative_d_min_Stats; ...
%         (LLL_cumulative_d_min_Stats(No_files-1)+dumb_length_d_min)];
%   end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end
