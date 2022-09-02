function [cfg, imgStruct] = postInitializationSetup(cfg, imgStruct)

    % generic function to finalize some set up after psychtoolbox has been
    % initialized

    cfg = initFixation(cfg);

    imgNames = fieldnames(imgStruct);
    for i = 1:length(imgNames)
        imgStruct.(imgNames{i}).texture = Screen('MakeTexture', ...
                                                 cfg.screen.win, ...
                                                 imgStruct.(imgNames{i}).data);
    end

    cfg.screen.stimulusRect  = [cfg.screen.center(1) - cfg.stimSize / 2, ...
                                cfg.screen.center(2) - cfg.stimSize / 2, ...
                                cfg.screen.center(1) + cfg.stimSize / 2, ...
                                cfg.screen.center(2) + cfg.stimSize / 2];

end
