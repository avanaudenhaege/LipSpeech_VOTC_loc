% Clear all the previous stuff
clear;
clc;

if ~ismac
    close all;
    clear Screen;
end

% make sure we got access to all the required functions and inputs
initEnv();

% set and load all the parameters to run the experiment
cfg = setParameters;

cfg = userInputs(cfg);

cfg.startWith = input('Start with stimuli set A or B: ', 's');
% set defaults in case no the proper answer
if ~ismember(cfg.startWith, {'A', 'B'})
    cfg.startWith = 'A';
end
talkToMe(cfg, sprintf('\nLocalizer Experiment: start with stimuli subset: %s\n\n', ...
                      cfg.startWith));

cfg = createFilename(cfg);

% Prepare for the output logfiles with all
logFile = struct('extraColumns', {cfg.extraColumns}, ...
                 'isStim', false);
logFile = saveEventsFile('init', cfg, logFile);
logFile = saveEventsFile('open', cfg, logFile);

%% SET THE STIMULI/CATEGORY
talkToMe(cfg, '\nLoad stimuli:');

imgStruct = loadImages();
imgNames = fieldnames(imgStruct);

setUpRand();

allCatRep = shuffleBlocks(cfg);

%%  Experiment

% Safety loop: close the screen if code crashes
try

    %% Init the experiment
    cfg = initPTB(cfg);

    [cfg, imgStruct] = postInitializationSetup(cfg, imgStruct);

    unfold(cfg);

    % prepare the KbQueue to collect responses
    getResponse('init', cfg.keyboard.responseBox, cfg);

    standByScreen(cfg);
    talkToMe(cfg, '\nWAITING FOR TRIGGER (Instructions displayed on the screen)\n\n');
    waitForTrigger(cfg);

    drawFixation(cfg);
    cfg.experimentStart = Screen('Flip', cfg.screen.win);

    getResponse('start', cfg.keyboard.responseBox);

    waitFor(cfg, cfg.timing.onsetDelay);

    for iBlock = 1:length(allCatRep)

        % get the names of the images to display from the block type
        idx = cellfun(@(x) strcmp(x(1:2), allCatRep{iBlock}), imgNames);
        stimuli = imgNames(idx);
        stimuli = Shuffle(stimuli);

        nbStim = length(stimuli);
        if cfg.debug.do
            nbStim = 10;
        end

        % Set the target for this block
        % it will randomly pick one of these
        possibleNumberOfTargets = [0 1 2];
        nbTargets = possibleNumberOfTargets(randperm(length(possibleNumberOfTargets), 1));
        % sort randomly the stimuli in the block
        [~, idx] = sort(rand(1, nbStim));
        % select the position of the target(s)
        positionTarget = sort(idx(1:nbTargets));

        talkToMe(cfg, sprintf('\nNumber of targets in coming trial: %i\n\n', nbTargets));

        for iTrial = 1:nbStim

            %  Check for experiment abortion from operator
            checkAbort(cfg, cfg.keyboard.keyboard);

            thisTrial.isStim = logFile.isStim;
            thisTrial.fileID = logFile.fileID;
            thisTrial.extraColumns = logFile.extraColumns;

            thisTrial.block_nb = iBlock;
            thisTrial.trial_nb = iTrial;
            thisTrial.target = false;
            thisTrial.key_name = 'n/a';

            thisTrial.stim_file = [stimuli{iTrial} '.tif'];
            switch stimuli{iTrial}(1)
                case 'F'
                    trial_type = 'face';
                case 'H'
                    trial_type = 'house';
                case 'W'
                    trial_type = 'word';
            end
            thisTrial.trial_type = trial_type;
            thisTrial.texture = imgStruct.(stimuli{iTrial}).texture;

            thisTrial = playTrial(cfg, thisTrial);

            if iTrial == 1
                blockStart = thisTrial.onset;
            end

            % if this is a target
            % repeat the same stimulus
            if sum(iTrial == positionTarget) == 1

                thisTrial.target = true;
                thisTrial.trial_type = 'target';

                thisTrial = playTrial(cfg, thisTrial);

            end

            %% Collect and saves the responses
            responseEvents = getResponse('check', cfg.keyboard.responseBox, cfg);
            if isfield(responseEvents(1), 'onset') && ~isempty(responseEvents(1).onset)
                for iResp = 1:size(responseEvents, 1)
                    responseEvents(iResp).onset = ...
                        responseEvents(iResp).onset - cfg.experimentStart;
                    responseEvents(iResp).key_name = responseEvents(iResp).keyName;
                end
                responseEvents(1).isStim = false;
                responseEvents(1).fileID = logFile.fileID;
                responseEvents(1).extraColumns = logFile.extraColumns;

                saveEventsFile('save', cfg, responseEvents);
            end

        end

        blockEnd = GetSecs();
        blockDuration = (blockEnd - cfg.experimentStart) - blockStart;
        talkToMe(cfg, sprintf('\n\nTiming - Block duration: %0.3f seconds\n\n', blockDuration));

        WaitSecs(cfg.timing.IBI);

    end

    loopDuration = (GetSecs() - cfg.experimentStart);
    loopDurationMin = floor(loopDuration / 60);
    loopDurationSec = mod(loopDuration, 60);
    talkToMe(cfg, sprintf('\n\nTiming - Run lasted %i minutes %0.3f seconds\n\n', ...
                          loopDurationMin, ...
                          loopDurationSec));

    getResponse('stop', cfg.keyboard.responseBox);
    getResponse('release', cfg.keyboard.responseBox);

    saveEventsFile('close', cfg, logFile);
    createJson(cfg, cfg);

    % Pad the runtime to make sure all runs have same duraton
    % (due to random nb of targets)
    endDelay = cfg.timing.runDuration - loopDuration;
    if ~cfg.debug.do
        WaitSecs(endDelay);
    end

    cfg = getExperimentEnd(cfg);

    farewellScreen(cfg, 'Fin de l''experience :)\nMERCI !');

    cleanUp();

catch

    cleanUp();
    psychrethrow(psychlasterror);

end
