% convert .mat for ants

function lfp = extract_to_ants(path)
    
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

    % Call lfp
    for f = 1:numel(lfp)
        [CSC_TimeStamps, CSC_SampleFrequency, CSC_Samples, Header] = Nlx2MatCSC(num2str(strcat(path, '\', lfp(f).name)), fields, extractHeader, 1);
        [Trial_Samples, CSC_TimeStamps] = straightenCSC(CSC_Samples, CSC_TimeStamps);

        % Align amplitude
        ADBitVolt = sscanf(string(Header(17)), ['-ADBitVolts', '%f']);
        ADBituV = ADBitVolt * 1000000;
        Trial_Samples_uV = Trial_Samples * ADBituV;

        % Save
        header = Header;
        sample_frequency = CSC_SampleFrequency(1);
        samples = Trial_Samples_uV;
        timestamps = CSC_TimeStamps;

        save(strcat(path, '\', lfp(f).name(1:4), '.mat'), "header", "samples", "timestamps", "sample_frequency");
        clear header samples timestamps sample_frequency;
    end
end