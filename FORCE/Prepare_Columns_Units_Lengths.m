
%% This file is valid for both experimental and simulation data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Chopping data if too long %%%%%%%%%%%

if Maximum_lenght_data_set==1
		
		counter_cuts=0;	
	    dumb_set=set_d;	
		while (length((dumb_set(:,1))))>=(2*Maximum_lenght_data)
			
			Actual_length_set=length(dumb_set(:,1));
			
			if mod(dumb_set(:,1),2)==0
				Actual_length_set=Actual_length_set-1;
			end
			
			dumb_set=dumb_set(1:2:Actual_length_set,:);
			counter_cuts=counter_cuts+1;
		end
		set_d=dumb_set;
end  % end chopping 



    if (Extension==1) %% Extension chosen    
    
		
        ZsnrEx=set_d(:,ZEx);    %m  %%%% get zc   
		set_d;
        IfZr = find(ZsnrEx==0);
        ZsnrEx(IfZr,:)=[];
  
        DflEx = set_d(:,DfEx);   % volt   get defl

        IfZr = find(DflEx==0);
        DflEx(IfZr,:)=[];
%     DflEx=flipud(DflEx);
        Dfl_offset = mean(DflEx(1:floor(2*Averaging_percentage_of_signal*length(DflEx))));
        DflEx=DflEx - Dfl_offset; % zeroing defl
		
		if Simulation==0
			DflEx = smooth(DflEx,s_defl,'rloess');
		end
        
    
        AmEx=set_d(:,AEx);      %volt  get amplitude
        IfZr = find(AmEx==0);
        AmEx(IfZr,:)=[];    
%     AmEx=flipud(AmEx);


        PhEx=set_d(:,PEx );      %Angle in degrees
        IfZr = PhEx==0;
        PhEx(IfZr,:)=[];  
%     PhEx=flipud(PhEx);
        Ph_offset = 90-mean(PhEx(1:floor(Averaging_percentage_of_signal*length(PhEx))));
        PhEx=PhEx + Ph_offset; % offseting Phase
		
	    if Simulation==1  %% E dissipation real
		   Edis_T=set_d(:,E_T);
	    end

% 


%   
    %%% Resizing in case of small differences!
        LZ = length(ZsnrEx);
        LD = length(DflEx);
        LA = length(AmEx);
        LP = length(PhEx);
		if Simulation==1
			LE=length(Edis_T);
			MnL = min([LZ LP LD LA LE])-1;
			Edis_T=Edis_T(end-MnL:end);
		else
		
		MnL = min([LZ LP LD LA])-1;
       
        ZsnrEx= ZsnrEx(end-MnL:end);
        DflEx= DflEx(end-MnL:end);
        AmEx= AmEx(end-MnL:end);
        PhEx= PhEx(end-MnL:end);
		end

    end
    
    
if (Extension==0)  %% Retraction has been chosen so we need to change stuff  

      ZsnrRet=set_d(:,ZRet);   %m
      IfZr = find(ZsnrRet==0);
      ZsnrRet(IfZr,:)=[];
%     ZsnrRet=flipud(ZsnrRet);

      DflRet = set_d(:,DfRet);
      IfZr = find(DflRet==0);
      DflRet(IfZr,:)=[];
%     DflRet=flipud(DflRet);
      Dfl_offset = mean(DflRet(end-floor(2*Averaging_percentage_of_signal*length(DflRet)):end));
      DflRet=DflRet- Dfl_offset;          % zeroing defl
      DflRet = smooth(DflRet,s_defl,'rloess');

      AmRet=set_d(:,ARet);     %volt
      IfZr = find(AmRet==0);
      AmRet(IfZr,:)=[];
%     AmRet=flipud(AmRet);
    
      PhRet=set_d(:,PRet);     %Angle
      IfZr = find(PhRet==0);
      PhRet(IfZr,:)=[];
%     PhRet=flipud(PhRet);
      Ph_offset = 90-mean(PhRet(end-floor(Averaging_percentage_of_signal*length(PhRet)):end));
      PhRet= PhRet + Ph_offset;                % offseting Phase
	  

%%% Resizing in case of small differences!
      LZ = length(ZsnrRet);
      LD = length(DflRet);
      LA = length(AmRet);
      LP = length(PhRet); 
 
	  
      MnL = min([LZ LP LD LA]);
      ZsnrRet= ZsnrRet(1:MnL);
      DflRet= DflRet(1:MnL);
      AmRet= AmRet(1:MnL);
      PhRet= PhRet(1:MnL);
    
	  
        figure (count_figures+80)
        plot (ZsnrRet, AmRet, '.k', 'Markersize',3)
        figure (count_figures+81)
        plot (ZsnrRet, PhRet, '.k', 'Markersize',3)
        figure  (count_figures+82)
        plot(ZsnrRet, DflRet, '.k', 'Markersize',3)
   
   
        %%% If extension chosen keep moving to next section, otherwise we need
        %%% to rearrange the matrix to make the first elements be the ones that
        %%% start at large cantilever separation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ZsnrEx=fliplr(ZsnrRet')';
        AmEx=fliplr(AmRet')';
        PhEx=fliplr(PhRet')';
        DflEx=fliplr(DflRet')';
		
        %% End of locating retraction data for the extension profile
   
end