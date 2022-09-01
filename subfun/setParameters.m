function [cfg] = setParameters()

    % Initialize the parameters and general configuration variables

    cfg = struct();

    cfg.dir.root = bids.internal.file_utils(fullfile(fileparts(mfilename('fullpath')), '..'), 'cpath');
    cfg.dir.stimuli = fullfile(cfg.dir.root, 'stimuli');
    cfg.dir.output = fullfile(cfg.dir.root, 'data');

    %% Debug mode settings

    % To test the script out of the scanner, skip PTB sync
    cfg.debug.do = true;
    % To test on a part of the screen, change to true
    cfg.debug.smallWin = false;
    % To test with trasparent full size screen
    cfg.debug.transpWin = true;

    cfg.verbose = 1;

    cfg.skipSyncTests = 0;

    %% Engine parameters
    cfg.testingDevice = 'mri'; % beh or mri
    cfg.eyeTracker.do = false;

    %% Auditory Stimulation
    cfg.audio.do = false;

    %% Task(s)

    % Instruction
    cfg.task.instruction = '\n READY TO START \n \n - Détectez les images répétées - ';
    cfg.task.name = 'VisLoc';

    cfg = setMonitor(cfg);

    % Keyboards
    cfg = setKeyboards(cfg);

    cfg.text.size = 50;

    % MRI settings
    cfg = setMRI(cfg);

    cfg.pacedByTriggers.do = false;

    %% Experiment Design

    % STIMULI SETTING
    % TODO express this as degrees of visual angle and not pixels
    cfg.stimSize = 700;
    cfg.timing.stimDuration = 0.748;
    cfg.timing.ISI = 0.25;
    cfg.timing.runDuration = 608;

    % Time between blocks
    cfg.timing.IBI = 6;

    % delay before 1rst stimulus at the start of a run
    cfg.timing.onsetDelay = 8;

    if cfg.debug.do
        cfg.timing.onsetDelay = 0;
    end

    cfg.subject.ask = {'grp', 'run'};

    % Fixation cross (in pixels)
    cfg.fixation.type = 'cross';
    cfg.fixation.color = cfg.color.black;
    cfg.fixation.width = .25;
    cfg.fixation.lineWidthPix = 3;
    cfg.fixation.xDisplacement = 0;
    cfg.fixation.yDisplacement = 0;

    cfg.extraColumns = {'stim_file', ...
                        'block_nb', ...
                        'trial_nb', ...
                        'target', ...
                        'key_name'};

end

function cfg = setKeyboards(cfg)
    cfg.keyboard.escapeKey = 'ESCAPE';
    cfg.keyboard.responseKey = {'s', 'd', 'space'};
    cfg.keyboard.keyboard = [];
    cfg.keyboard.responseBox = [];

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.keyboard.keyboard = [];
        cfg.keyboard.responseBox = [];
    end
end

function cfg = setMRI(cfg)

    % letter sent by the trigger to sync stimulation and volume acquisition
    cfg.mri.triggerKey = 's';
    cfg.mri.triggerNb = 1;

    cfg.mri.repetitionTime = 1.75;

    cfg.bids.MRI.Instruction = cfg.task.instruction;
    cfg.bids.MRI.TaskDescription = [''];
    cfg.bids.MRI.CogAtlasID = '';
    cfg.bids.MRI.CogPOID = '';

end

function cfg = setMonitor(cfg)

    % Monitor parameters for PTB
    cfg.color.white = [255 255 255];
    cfg.color.black = [0 0 0];
    cfg.color.red = [255 0 0];
    cfg.color.grey = mean([cfg.color.black; cfg.color.white]);
    cfg.color.background = cfg.color.black;
    cfg.text.color = cfg.color.white;

    % Monitor parameters
    cfg.screen.monitorWidth = 50; % in cm
    cfg.screen.monitorDistance = 40; % distance from the screen in cm

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.screen.monitorWidth = 25;
        cfg.screen.monitorDistance = 95;
    end

end
