function [rep_begin_time_20khz, rep_end_time_20khz] = getSpotsRepetitions(evtTimes, frame_type)
% this works for 20khz sampling 

frame_duration = 20000;
load('spots_pattern.mat', 'FramesOrder')

if ~exist('frame_type', 'var') ||  frame_type == 'repeated'
    load('spots_pattern.mat', 'id_repeated');
    ids_of_type = id_repeated;
elseif frame_type == 'single'
    load('spots_pattern.mat', 'id_singles');
    ids_of_type = id_singles;
elseif frame_type == 'unique'
    load('spots_pattern.mat', 'id_unique');
    ids_of_type = id_unique;
else
    error("frame type not known")
end
    
rep_begin_time_20khz = cell(1, numel(ids_of_type));
rep_end_time_20khz = cell(1, numel(ids_of_type));

for i=1:numel(ids_of_type)
    id = ids_of_type(i);
    rep_begin_time_20khz{i} = evtTimes(FramesOrder(1:numel(evtTimes)) == id);
    rep_end_time_20khz{i} = rep_begin_time_20khz{i} + frame_duration;
end