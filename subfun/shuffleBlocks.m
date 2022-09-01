function allCatRep = shuffleBlocks(cfg)
    %
    % shuffle block types (word, house, face) by alternating subsets A and B
    %
    % starting subset type will depend on the configuration
    %

    nbRepeats = 10;
    if cfg.debug.do
        nbRepeats = 2;
    end

    % Set the repetition of 3 categories
    allCatA = {'WA', 'HA', 'FA'};
    allCatB = {'WB', 'HB', 'FB'};

    allCatRep = [];

    if strcmp(cfg.startWith, 'A')
        oddBlock = allCatA;
        evenBlock = allCatB;
    elseif strcmp(cfg.startWith, 'B')
        oddBlock = allCatB;
        evenBlock = allCatA;
    end

    for iBlock = 1:nbRepeats

        if mod(iBlock, 2) == 1
            thisBlock = oddBlock;
        else
            thisBlock = evenBlock;
        end

        allCatRep = [allCatRep Shuffle(thisBlock)];

    end

end
