function thisTrial = playTrial(cfg, thisTrial, logFile)

    nbFrames = ceil(cfg.timing.stimDuration / cfg.screen.ifi);

    drawFixation(cfg);
    vbl = Screen('Flip', cfg.screen.win);

    for iFrame = 1:nbFrames

        Screen('DrawTexture', cfg.screen.win, thisTrial.texture, [], cfg.screen.stimulusRect);
        drawFixation(cfg);
        vbl = Screen('Flip', cfg.screen.win, vbl + cfg.screen.ifi / 2);

        if iFrame == 1
            onset = vbl;
        end

    end

    drawFixation(cfg);
    offset = Screen('Flip', cfg.screen.win);

    WaitSecs(cfg.timing.ISI);

    thisTrial.duration = offset - onset;
    thisTrial.onset = onset - cfg.experimentStart;

    %% Save the events to the logfile
    saveEventsFile('save', cfg, thisTrial);

end
