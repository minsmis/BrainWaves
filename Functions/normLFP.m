function [normlfp, criteria] = normLFP(lfp, mode)

    if isequal(mode, 'No norm.') % without normalization
        normlfp = lfp;
        criteria = 'NaN';

    elseif isequal(mode, 'RMS') % root mean square
        % Calc root mean square
        lfp_rms = rms(lfp);
        criteria = 'rms';
    
        % Normalize with rms
        normlfp = lfp./lfp_rms;

    elseif isequal(mode, '% RMS') % percent rms (do not use)
        % Calc root mean square
        lfp_rms = rms(lfp);
        criteria = '%rms';
        
        % Percentage normalize with rms
        normlfp = 100*(lfp-lfp_rms)./lfp_rms;

    elseif isequal(mode, 'Z-Score') % z-score
        % Calc z-score
        normlfp = zscore(lfp);
        criteria = 'z-score';
    end
end