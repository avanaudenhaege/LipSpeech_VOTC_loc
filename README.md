# LIPSPEECH EXPERIMENT: localizer

script from Stefania Mattioni - adapted by Alice Van Audenhaege and Remi Gau

Jan 2022

## RUN DESCRIPTION

Categories of stimuli = 3 (words, houses and faces); 24 exemplars per category (tot = 72).

There are 30 blocks : 10 for each condition.

This localizer should be ran only once (1 run).

## BLOCK DESCRIPTION

In each block all the 12 stimuli from a category are presented in random order.

750 msec for each image + 250 msec ISI (=central fixation cross).

In each block there are either 0, 1 or 2 (this is randomly decided) target
stimuli: a target is the repetition of the previous stimulus (N-back task).

The participant has to press when he/she sees a target.

Each block has a duration of 12, 13 or 14 s (depending if 0, 1 or 2 targets).

## TIME CALCULATION for each RUN

3 categories with 12 stimulus each;

trial duration= 750msec stimulus + 250 msec ISI = 1s;

block duration = 1 category in each block + 0/1/2 targets = 12/13/14s

1 pause of 8 s at the beginning of the run

30 pauses of 6s = 180s

30 blocks per run : minimum 360s / maximum 420s (according to 0, 1 or 2 targets)

MINIMUM DURATION = 548s (9min08sec) / MAXIMUM DURATION = 608s (10min08sec)

Fixation cross to fill the time difference to get to 488s anyway.

TWO SET OF STIMULI (order of pres. counterbalanced accross partic.) : Set A Set
B

## STIMULI

To be used with a folder named `stimuli` containing the following files stored
on OSF in `VOTC-loc_stimuli.zip`:

https://osf.io/2xtsn/?view_only=22f09bb4dc5f4a11823103141ca2f735

## ACTION and VARIABLE SETTING

The only variable you need to manually change is Cfg.device at the beginning of
the script. Put either 'PC' or 'Scanner'.

Once you will Run the script you will be asked to select some variables:

1. Group (TO DEFINE): ctrl is defined as default
2. SubID 
3. Run Number : 1st or 2nd run
4. Stimuli ID: 'setA' or 'setB' (it is important to spell correctly this
   variable because these labels are used to select the correct stimuli folder
   in the script. In case this input is not given or it is mispelled. it will
   automatically pick the set A.)
