

d_min_zeroed_ALL_FILES=struct;
figure (1)

for No_files=1: LLL_stats
    
  dumb_name=sprintf('No_%i',No_files);  
  
  D.(dumb_name)=d_min_zeroed_Stats(initial_roll_Stats(No_files):final_roll_Stats(No_files));
  dumb_f=unpacked_Force_CLEAN.(vector_of_names_files{No_files})(:,smooth_force_col);
  FORCE.(dumb_name)=dumb_f;
  
  if plot_force==1
      hold on
      plot(D.(dumb_name), FORCE.(dumb_name))
      hold on
      dddd=0:0.1e-9: dFAD_FAD_zero_matrix_Percentage_FILES(2,1+No_files);
      plot(dddd, ones(1, length(dddd))*0.15*F_Adhesion_Stats(No_files), '.r')
  end
end

