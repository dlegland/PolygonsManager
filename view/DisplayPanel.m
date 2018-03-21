classdef DisplayPanel < handle
%DISPLAYPANEL Abstract class that displays one (or more) axis
%
%   Class DisplayPanel
%
%   Example
%   DisplayPanel
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-03-20,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % the instance of PolygonsManagerMainFrame that contains this panel
    frame;
    
    % the type of panel (to be removed)
    type;
    
end % end properties


%% Constructor
methods
    function this = DisplayPanel(varargin)
    % Constructor for DisplayPanel class
    
        if isempty(varargin)
            error('Requires at least one input');
        end
        
        if isa(varargin{1}, 'PolygonsManagerMainFrame')
            this.frame = varargin{1};
        else
            error('Unable to understand input argument');
        end
    end

end % end constructor methods

%% Abstract Methods
methods (Abstract)
    % refresh the whole display of this panel
    refreshDisplay(this)
    
    % update the display of selected polygons
    updateSelectionDisplay(this);
    
end % end abstract methods

end % end classdef

