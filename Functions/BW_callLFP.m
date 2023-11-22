function lfp = callLFP(path)
    
    if ispc
        % Mode
        fields = [1 0 1 0 1];
        extractHeader = 1;
    
        % Call directory
        lfp = dir([num2str(path), '\CSC*.ncs']);
    
        % sort 'file' by channel
        for i = 1:numel(lfp)
            idx = sscanf(string(lfp(i).name), ['CSC','%f']);
            lfp(i).channel = idx;
        end
        lfpT = struct2table(lfp);
        sortedT = sortrows(lfpT, 'channel');
        lfp = table2struct(sortedT);
    
        % Progress bar
        p = waitbar(0, 'Loading data ...');
    
        % Call lfp
        for f = 1:numel(lfp)
            [CSC_TimeStamps, CSC_SampleFrequency, CSC_Samples, Header] = Nlx2MatCSC([path, '\', lfp(f).name], fields, extractHeader, 1);
            [Trial_Samples, CSC_TimeStamps] = straightenCSC(CSC_Samples, CSC_TimeStamps);
    
            % Align amplitude
            ADBitVolt = sscanf(string(Header(17)), ['-ADBitVolts', '%f']);
            ADBituV = ADBitVolt * 1000000;
            Trial_Samples_uV = Trial_Samples * ADBituV;
    
            % Save
            lfp(f).header = Header;
            lfp(f).fs = CSC_SampleFrequency(1);
            lfp(f).lfp = Trial_Samples_uV;
            lfp(f).ts = (CSC_TimeStamps - CSC_TimeStamps(1)) / 1000000; % sec
    
            waitbar(f/length(lfp), p, 'Loading data ...');
        end
    
        close(p);
    end

    if ismac || isunix
        % Call directory
        lfp = dir(fullfile(num2str(path), 'CSC*.mat'));

        % sort 'file' by channel
        for i = 1:numel(lfp)
            idx = sscanf(string(lfp(i).name), ['CSC','%f']);
            lfp(i).channel = idx;
        end
        lfpT = struct2table(lfp);
        sortedT = sortrows(lfpT, 'channel');
        lfp = table2struct(sortedT);

        % Progress bar
        p = waitbar(0, 'Loading data ...');

        % Call lfp
        for f = 1:numel(lfp)
            [CSC_TimeStamps, CSC_SampleFrequency, CSC_Samples, Header] = Nlx2MatCSC_v3([path, '\', lfp(f).name], fields, extractHeader, 1);
            [Trial_Samples, CSC_TimeStamps] = straightenCSC(CSC_Samples, CSC_TimeStamps);

            % Align amplitude
            ADBitVolt = sscanf(string(Header(17)), ['-ADBitVolts', '%f']);
            ADBituV = ADBitVolt * 1000000;
            Trial_Samples_uV = Trial_Samples * ADBituV;
    
            % Save
            lfp(f).header = Header;
            lfp(f).fs = CSC_SampleFrequency(1);
            lfp(f).lfp = Trial_Samples_uV;
            lfp(f).ts = (CSC_TimeStamps - CSC_TimeStamps(1)) / 1000000; % sec
            
            waitbar(f/length(lfp), p, 'Loading data ...');
        end

        close(p);
    end
end