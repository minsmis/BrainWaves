function [dsf, dslfp] = dsLFP(lfp, lfpFs, downsampledFs)

    % Downsampling coefficient
    dsc = round(lfpFs/downsampledFs); % downsampling coefficient

    % Downsampled frequency
    dsf = round(lfpFs/dsc);

    dslfp = downsample(lfp, dsc); % downsampled lfp
end