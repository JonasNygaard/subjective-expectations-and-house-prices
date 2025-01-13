function brewedColors = colorBrewer(numColor)

    %% colorBrewer.m
    % ########################################################################### %
    % function  brewedColors = colorBrewer(numColor)
    % Purpose:  Create a vector of RGB colors for plotting purposes
    %
    % Input:    numColor    = Scalar indicating color to be used
    %
    % Output:   brewedColor = Matrix of RGB codes for colors for plots
    %               
    % Authors:
    % Jeppe Bro, ATP
    % Jonas N. Eriksen, Aarhus University
    %
    % Encoding: UTF8
    % Last modified: January 2025
    % ########################################################################### %

    %% Error checking on input
    if (nargin > 1)
        error('colorBrewer.m: Too many input arguments');
    end

    if (nargin < 1)
        error('colorBrewer.m: Not enough input arguments');
    end

    if ~ismember(numColor,1:7)
        error('colorBrewer.m: A most seven colors are currently supported');
    end

    %% Setting RGB values for color palette
    % ########################################################################### %
    %{
        Setting RGB values for the color palette used throughout plots. 
    %}
    % ########################################################################### %

    rgbValues = [
        57      119     175     % Blue
        239     133     54      % Orange
        82      156     62      % Green
        197     57      50      % Red
        141     107     184     % Purple
        133     88      78      % Brown
        150     150     150     % Gray
    ]./255;

    % Setting output
    brewedColors  = rgbValues(numColor,:);

end

% ########################################################################### %
% [EOF]
% ########################################################################### %