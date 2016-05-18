 
function [RAW_DATA_SET, ...
        RAW_DATA_SET_NANS, ...
        RAW_DATA_SET_MODEL_1, ...
        RAW_DATA_SET_MODEL_2, ...  
        Fts_cons_smooth, E_dis_smooth, ...
        length_file_SET, length_file_SET_NANS, ...
        length_file_SET_MODEL_1, length_file_SET_MODEL_2]= ...
            calculate_force(dumb_meta_data, ...
        AEx, ZEx, PEx, DfEx, ...
        ARet, ZRet, PRet, DfRet, ...
        s_d_min, s_d_min_Incr, s_Omega_AM, s_Omega_Incr, ...
        s_Fts, s_E_dis, ...
        coefficient_A0_calc, ...
        Extension_answer, remove_start, remove_end, ...
        omg_f0, omg_drive, Q, AmpInvOLS, k,   ... 
        small_treshold, large_treshold, ...  
        remove_outliers_in_force_NANS, ...
        remove_outliers_in_force_MODEL_1, ...   % extreme values ALL Curve
        grouped_data_Fts_MODEL_2, ...
        remove_outliers_in_force_MODEL_2, ...   % nearby other values 
        model_noise, ...
        smoothen_NANS_Fts, smoothen_MODEL_1_Fts, smoothen_MODEL_2_Fts, ...
        SLOW_processes_1, distance)

    set_dumb=dumb_meta_data;
    
    if (Extension_answer==0) %% Extension chosen 
        
        AmEx=dumb_meta_data(:,AEx);
        PhEx=dumb_meta_data(:,PEx);
        ZsnrEx=dumb_meta_data(:,ZEx);
        DflEx=dumb_meta_data(:,DfEx);
        
    elseif (Extension_answer==1) %% Retraction chosen 
        
        AmEx=dumb_meta_data(:,ARet);
        PhEx=dumb_meta_data(:,PRet);
        ZsnrEx=dumb_meta_data(:,ZRet);
        DflEx=dumb_meta_data(:,DfRet);
    end
    
    %%%%%%%%%%%%% ARRANGE CURVES deleting zeros and turning them  %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    IfZr_cum=[];
    %%% DELETE ZEROS %%%%%%%%%%%%%%%%%%%%%%%%%
    IfZr = find(ZsnrEx==0);
    IfZr_cum=[IfZr_cum; IfZr];
    
    IfZr = find(DflEx==0);
    IfZr_cum=[IfZr_cum; IfZr];
    
    IfZr = find(AmEx==0);
    IfZr_cum=[IfZr_cum; IfZr];   

    IfZr = find(PhEx==0);
    IfZr_cum=[IfZr_cum; IfZr];
    
    IfZr_cum_u=unique(IfZr_cum);
    set_dumb(IfZr_cum_u,:)=[];
    %%% The variables again without zeros
    if (Extension_answer==0) %% Extension chosen 
        
        AmEx=set_dumb(:,AEx);
        PhEx=set_dumb(:,PEx);
        ZsnrEx=set_dumb(:,ZEx);
        DflEx=set_dumb(:,DfEx);
        
    elseif (Extension_answer==1) %% Retraction chosen 
        
        AmEx=set_dumb(:,ARet);
        PhEx=set_dumb(:,PRet);
        ZsnrEx=set_dumb(:,ZRet);
        DflEx=set_dumb(:,DfRet);
    end
   
   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
   % this will force first element zc in vector to be zc>>A0 and last Zc<<A0 no change in data
    
    Dumb=ZsnrEx;

    if ZsnrEx(1)<0   %% First value smaller than zero 
        if ZsnrEx(1)<ZsnrEx(length(ZsnrEx))
            Dumb=-Dumb; % if increaseing zc as cantilever goes down then no more changes needed
        end
        % if decreasing zc as cantilever goes down
        
        if ZsnrEx(1)>ZsnrEx(length(ZsnrEx)) %  increaseing zc as cantilever goes down                     
           Dumb=Dumb-Dumb(end); 
        end
        
    end
    
    if ((ZsnrEx(1))>=0)   %% First value larger than zero 
        
        if ZsnrEx(1)<ZsnrEx(length(ZsnrEx)) %  increaseing zc as cantilever goes down          
            difference=2*(ZsnrEx(2:end)-ZsnrEx(1:end-1));
            for iii=2:1:length(ZsnrEx)
                Dummy=0;
                for nnn=1:1:(iii-1)
                    Dummy=Dummy-difference(nnn);
                end
                Dumb(iii)=Dumb(iii)+Dummy;
            end
            
        end
    end
     
    Dumb=Dumb-Dumb(end); %% separation ends in zero
    ZsnrEx=Dumb;
    
    Separation=ZsnrEx;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%Because begining and end might induce errors %%%%%%%%%%%%%%%%%%%%%%%%
    %% Removes errors in beginibg and end of vectors %%%%%%%%%%%%%%%%%%%%%%
    
    Set_remove=[ZsnrEx, AmEx, PhEx, DflEx];
    Set_remove=Set_remove(remove_start:end-remove_end,:);   
    ZsnrEx=Set_remove(:,1);
    AmEx=Set_remove(:,2);
    PhEx=Set_remove(:,3);
    DflEx=Set_remove(:,4);
    
    
    %%%%%  Amax and deflection in nm ==========================================================================================%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    AmEx=AmEx*AmpInvOLS*1e-9;
	DflEx=DflEx*AmpInvOLS*(1e-9)/1.09;
	%%% IMPORTANT, from here on Amplitude and deflection are in nm ====================================================%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% 1.  The separation  now starts allways from large to small 
    %%% 2. The zeros have been removed and also part of begining and end of
    %%%    the data files
    
        
    Dfl_offset = mean(DflEx(1:floor(coefficient_A0_calc*length(DflEx))));
    DflEx=DflEx - Dfl_offset; % zeroing defl
    
    Ph_offset = 90-mean(PhEx(1:floor(coefficient_A0_calc*length(PhEx))));
    PhEx=PhEx + Ph_offset; % offseting Phase
    
    Amplitude=AmEx;
    Phase=PhEx;
    Deflection=DflEx;
    Separation=ZsnrEx;
    
    if distance~=0 
        Separation=Separation+distance/2/length(Separation);
    end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%  1. A0 AND DMIN defined raw ====================================
    
    
    
    A0 = mean(Amplitude(1:floor(coefficient_A0_calc*length(Amplitude)))); 
    
    %%%%%%%  1.2 d_min defined raw ====================================
    d_min=Separation-Amplitude;  
    
    if SLOW_processes_1==1
        d_min_Smth= smooth(d_min,s_d_min,'rloess');
    end
    
    d_min_Incr=d_min(2:end)-d_min(1:end-1);
    
    if SLOW_processes_1==1
        d_min_Incr_Smth= smooth(d_min_Incr,s_d_min_Incr,'rloess');
    end
     %%%%%%%  Drive defined raw ====================================
    A_DRIVE=(A0/omg_f0^(2))*((omg_f0^(2)-omg_drive^(2))^(2)+(omg_f0^(2)*omg_drive^(2)/Q^(2)))^(1/2); 
    Amplitude_DriveRatio_Ex=A_DRIVE./AmEx;
    
        
    if SLOW_processes_1==1
        DflEx = smooth(DflEx,s_defl,'rloess');
    end
    
    
    cosine_angle_EX=cos(Phase*pi/180);
    sine_angle_EX=sin(Phase*pi/180);
    

    %%%%%%%%   1.3 RESONANCE FREQUENCY ========
    
    OMEGA=omg_drive/omg_f0; %% normalised natural frequency
    OMEGA_sqr=OMEGA*OMEGA;
    OMEGA_AM=(OMEGA_sqr+Amplitude_DriveRatio_Ex.*cosine_angle_EX).^(0.5)-1;  %% True resonance frequency shift
    
    if SLOW_processes_1==1
        OMEGA_AM_Smth= smooth(OMEGA_AM,s_Omega_AM,'rloess');
    end
    
    OMEGA_AM_Dif=OMEGA_AM(2:end)-OMEGA_AM(1:end-1);
    
    if SLOW_processes_1==1
        OMEGA_AM_Dif_Smth= smooth(OMEGA_AM_Dif,s_Omega_Incr,'rlowess');
    end
    
    %%%%%%%%   1.4 RESONANCE FREQUENCY ========
    
    gamma_medium=k/omg_f0/Q;
    Damping_coefficient=gamma_medium*(A0./AmEx.*sine_angle_EX-1);
    
    
    %%%%%%%%   2.  PREPARING NUMERICAL INTEGRATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    d_min_mean=(d_min(1:end-1)+d_min(2:end))/2;         %% mean value for integration  
    OMEGA_AM_mean=(OMEGA_AM(1:end-1)+ OMEGA_AM(2:end))/2;
    AmEx_mean=(Amplitude(1:end-1)+Amplitude(2:end))/2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Vectorized Numerical Integration PARAMETERS
  
    d_min_M = (repmat(d_min(2:end), 1, length(Separation)-1))';
    
    dummy_squared=AmEx_mean.^(0.5);
    AmEx_mean_sq_M=(repmat(dummy_squared,1, length(Separation)-1));
    
    d_min_mean_M=(repmat(d_min_mean ,1, length(Separation)-1));
    
    dummy_int=OMEGA_AM_mean.*d_min_Incr;
    Integrator_1=(repmat(dummy_int ,1, length(Separation)-1));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Vectorized Numerical Integration INTEGRATION 
    
    time_integral_begins=tic;  %%%%%=======================================
   
    I_1_M=(1+((AmEx_mean_sq_M)/8)./(sqrt(pi*(d_min_mean_M -d_min_M)))).*Integrator_1;
    
    dummy_15_sr_Amplitude=(AmEx_mean).^(1.5);
    AmEx_mean_sq15_M=(repmat(dummy_15_sr_Amplitude ,1, length(Separation)-1));
    OMEGA_AM_Dif_M=(repmat(OMEGA_AM_Dif ,1, length(Separation)-1));
    
    I_2_M=-(AmEx_mean_sq15_M)./(sqrt(2*(d_min_mean_M -d_min_M))).*OMEGA_AM_Dif_M;

    Fts_cons_raw=(-2*k*(sum(I_1_M+I_2_M)))';

    Fts_cons_real=real(Fts_cons_raw);
 
    time_integral=toc(time_integral_begins);  %%%%%=========================
    
    
    %%%% Energy 
    
    E_dis=pi*k.*Amplitude.*(A_DRIVE.*sine_angle_EX-(OMEGA/Q).*Amplitude)*6.24e18;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Clean Vectors (REMOVE NOISE) 
    
    RAW_DATA_SET=[Fts_cons_real, Fts_cons_raw, ...
        Amplitude(1:end-1), Phase(1:end-1), Separation(1:end-1), ...
        Deflection(1:end-1), ...
        d_min(1:end-1), d_min_mean, ...
        E_dis(1:end-1), Damping_coefficient(1:end-1)];
   
    RAW_DATA_SET_NANS=RAW_DATA_SET;
    RAW_DATA_SET_MODEL_1=RAW_DATA_SET;
    RAW_DATA_SET_MODEL_2=RAW_DATA_SET;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Clean Vectors (No NOISE 1/3) 
    if remove_outliers_in_force_NANS==1
          
        time_remove_nans=tic;
        ind_Fts_M=[];
        %%% Remove NANS
        ind_Fts = find(isnan(Fts_cons_real));
        ind_Fts_M=[ind_Fts_M; ind_Fts];
        %%% Remove ZEROS
        ind_Fts =find(Fts_cons_real==0);
        ind_Fts_M=[ind_Fts_M; ind_Fts];
        %%% Remove very large numbers 
        ind_Fts =find(Fts_cons_real> large_treshold);
        ind_Fts_M=[ind_Fts_M; ind_Fts];
        %%% Remove very large numbers 
        ind_Fts =find(Fts_cons_real < small_treshold);
        ind_Fts_M=[ind_Fts_M; ind_Fts];

        
        RAW_DATA_SET_NANS(ind_Fts_M, :)=[];
        
        removed_NANS_in_sec=toc(time_remove_nans);
    end
  
    if remove_outliers_in_force_MODEL_1&&remove_outliers_in_force_NANS
        
        RAW_DATA_SET_MODEL_1=RAW_DATA_SET_NANS;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Clean Vectors (No NOISE 2/3) 
    
    if remove_outliers_in_force_MODEL_1==1
        
        time_cleaning_MODEL_1= tic;
        RR_Matrix_MODEL_1=[];           % Indices to delete  in the set  

        counter_exclusions_MODEL_1=0;
   
        DATA_SET_RAW_dumb=RAW_DATA_SET_MODEL_1;
        Data_input=DATA_SET_RAW_dumb(:,1);
            
        %%% First round of cleaning 
        av=mean(Data_input);
        stnd=std(Data_input);

        L=size(Data_input,1);   
        tst = icdf(model_noise,1-1/(4*L),0,1);   %std_deviations_away 4*L
        tst_data=(Data_input-av)/stnd;
        [RR,C]=find(abs(tst_data)>tst);
        excluded=Data_input(RR,:);
        RR_Matrix_MODEL_1=[RR_Matrix_MODEL_1; RR]; % indices to delete 
        Data_input(RR,:)=[];
        counter_exclusions_MODEL_1= counter_exclusions_MODEL_1+1;

        while isempty(excluded)~=1

            av=mean(Data_input); stnd=std(Data_input);

            L=size(Data_input,1); 

            tst = icdf(model_noise, 1-1/(4*L),0,1);  %1-1/(std_deviations_away*L) 1-1/(4*L)
            tst_data=(Data_input-av)/stnd;

            [RR,C]=find(abs(tst_data)>tst);

            excluded=Data_input(RR,:);
            Data_input(RR,:)=[];
            RR_Matrix_MODEL_1=[RR_Matrix_MODEL_1; RR]; 
            counter_exclusions_MODEL_1= counter_exclusions_MODEL_1+1;
        end
    
         dummy_length1=length(RAW_DATA_SET_MODEL_1(:,1));
         dummy_length2=length(RR_Matrix_MODEL_1);
         
         if (dummy_length1-dummy_length2)> 100
             
             RAW_DATA_SET_MODEL_1(RR_Matrix_MODEL_1, :)=[];
         end
             
         time_MODEL_1 =toc(time_cleaning_MODEL_1);
         
    end  %%%% End remove noise MODEL 1

 
    if remove_outliers_in_force_MODEL_2&&remove_outliers_in_force_MODEL_1

        RAW_DATA_SET_MODEL_2=RAW_DATA_SET_MODEL_1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Clean Vectors (No NOISE 2/3) 
           
    if remove_outliers_in_force_MODEL_2==1
        
        time_cleaning=tic;

        DATA_SET_RAW_dumb=RAW_DATA_SET_MODEL_2;
        length_Data_input_ALL=length(DATA_SET_RAW_dumb(:,1));

        iteration_clean=floor(length_Data_input_ALL/grouped_data_Fts_MODEL_2);   % Number of iterations 

        DATA_SET_RAW_dumb=DATA_SET_RAW_dumb(1:(grouped_data_Fts_MODEL_2*iteration_clean), :);

        RR_Matrix_MODEL_2=[];  
        RR_excluded_MODEL_2=[];

        initial_value_remove=1;

        for i_t=1:iteration_clean

            %%%% start ITERATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            RR_Matrix=[]; 
            RR_excluded=[];

            final_value_remove=initial_value_remove+grouped_data_Fts_MODEL_2-1;

            Data_input=DATA_SET_RAW_dumb(initial_value_remove:final_value_remove, 1);

            %%% First round of cleaning 
            av=mean(Data_input);
            stnd=std(Data_input);
            %%test
            L=size(Data_input,1);   
            tst = icdf(model_noise,1-1/(4*L),0,1);   %std_deviations_away 5*L
            tst_data=(Data_input-av)/stnd;
            %%End test
            [RR,C]=find(tst_data>tst);
            excluded=Data_input(RR,:);
            RR_excluded=[RR_excluded; excluded];
            RR_Matrix=[RR_Matrix; RR]; % indices to delete 
            Data_input(RR,:)=[];
            %%%% enf first round %%%%
            
            while isempty(excluded)~=1

                av=mean(Data_input); stnd=std(Data_input);

                L=size(Data_input,1); 

                tst = icdf(model_noise, 1-1/(4*L),0,1);  %1-1/(std_deviations_away*L) 1-1/(2*L)
                tst_data=(Data_input-av)/stnd;

                [RR,C]=find(abs(tst_data)>tst);

                excluded=Data_input(RR,:);
                RR_excluded=[RR_excluded; excluded];
                Data_input(RR,:)=[];
                RR_Matrix=[RR_Matrix; RR]; 

            end
       
            RR_excluded_MODEL_2=[RR_excluded_MODEL_2; RR_excluded];
            dumb_iertation_add=RR_Matrix+initial_value_remove-1;
            RR_Matrix_MODEL_2=[RR_Matrix_MODEL_2; dumb_iertation_add];

            initial_value_remove=final_value_remove+1;

        end
  
        
         dummy_length1=length(RAW_DATA_SET_MODEL_2(:,1));
         dummy_length2=length(RR_Matrix_MODEL_2);
         
         if (dummy_length1-dummy_length2)> 100
             
             RAW_DATA_SET_MODEL_2(RR_Matrix_MODEL_2, :)=[];
         end

        time_to_clean=toc(time_cleaning);

    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Smoothen force "ONCE ONLY" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    if smoothen_NANS_Fts==1
        Fts_cons_smooth=smooth(RAW_DATA_SET_NANS(:,1),s_Fts,'rlowess');
        E_dis_smooth=smooth(RAW_DATA_SET_NANS(:,9),s_E_dis,'rlowess');
    elseif smoothen_MODEL_1_Fts==2
        Fts_cons_smooth=smooth(RAW_DATA_SET_MODEL_1(:,1),s_Fts,'rlowess');
        E_dis_smooth=smooth(RAW_DATA_SET_MODEL_1(:,9),s_E_dis,'rlowess');
    elseif smoothen_MODEL_2_Fts==3
        Fts_cons_smooth=smooth(RAW_DATA_SET_MODEL_2(:,1),s_Fts,'rlowess');
        E_dis_smooth=smooth(RAW_DATA_SET_MODEL_2(:,9),s_E_dis,'rlowess');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% END New Force Vectors (No NOISE 1/3 and 2/3 and 3/3) 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Returning 

    length_file_SET=length(RAW_DATA_SET(:,1));

    length_file_SET_NANS=length(RAW_DATA_SET_NANS(:,1));

    length_file_SET_MODEL_1=length(RAW_DATA_SET_MODEL_1(:,1));

    length_file_SET_MODEL_2=length(RAW_DATA_SET_MODEL_2(:,1));
      
    
end


%%% previous force
%     for iii=1:1:length(Separation)-1
%          
%          for ppp=1:1:iii
% 
%             I_1(ppp,1)=(1+(AmEx_mean(ppp,1))^(0.5)/8/(sqrt(pi*(d_min_mean(ppp,1) - ...
%                 d_min (iii+1,1)))))*OMEGA_AM_mean(ppp,1)*d_min_Incr(ppp,1);
%             
%             I_2(ppp,1)=-(AmEx_mean(ppp,1))^(1.5)/(sqrt(2*(d_min_mean(ppp,1) ...
%                 -d_min (iii+1,1))))*OMEGA_AM_Dif(ppp,1);
% 
%             Fts_cons_raw(iii,1)= Fts_cons_raw(iii,1)-2*k*(I_1(ppp,1)+I_2(ppp,1));
% 
%         end
%      end


 %%% raw %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     I_1=zeros(length(Separation),1);
%     I_2=zeros(length(Separation),1);
   
    %%%%%%%%    2.2 NUMERICAL INTEGRATION
    %%% nm %%%
    
%     AmEx_mean_nm=AmEx_mean*1e9;
%     d_min_mean_nm=d_min_mean*1e9;
%     d_min_Incr_nm=d_min_Incr*1e9;
%     OMEGA_AM_mean_Kilo=OMEGA_AM_mean*1e3;
%     d_min_nm=d_min*1e9;
%  
%     Fts_cons_raw_pN=zeros(length(Separation),1);
%     Fts_cons_Smth_pN=zeros(length(Separation),1);
%     
%     OMEGA_AM_Dif_Kilo=OMEGA_AM_Dif*1e3;