function createPanel(obj, index, equal)
%CREATEPANEL  Create a new panel and every elements needed to display an axis
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - index : the index at which the panel handle will be saved in the
%       MainFrame
%       - equal : defines if the axis created must have the "equal"
%       parameter -> Values :
%                   - 1 : on
%                   - 2 : off
%   Outputs : none


% co = [0.3255    0.4275    0.7961; %6
%       0.8627    0.2392    0.1961; %16
%       0.3059    0.6471    0.1961; %2
%       0.8824    0.3804    0.0784; %3
%       0.4941    0.3686    0.8235; %25
%       0.8000    0.6196    0.2000; %9
%       0.8235    0.3373    0.7686; %7
%       0.6902    0.3569    0.2118; %1
%       0.2863    0.7569    0.8353; %14
%       0.8980    0.8667    0.2275; %18
%       0.6549    0.2157    0.1255; %23
%       0.3647    0.8196    0.2941; %19
%       0.8392    0.4549    0.6588; %21
%       0.9059    0.2157    0.4275; %15
%       0.2157    0.2902    0.4824; %5
%       0.7765    0.5961    0.7098; %8
%       0.1843    0.5686    0.5725; %10
%       0.5137    0.3098    0.5294; %11
%       0.3412    0.4627    0.1569; %12
%       0.9529    0.7176    0.1922; %13
%       0.9059    0.2745    0.6314; %17
%       0.3804    0.5059    0.7020; %20
%       0.7490    0.6157    0.8510; %22
%       0.8745    0.3922    0.3922; %24
%       0.6549    0.4196    0.9451];%4
co = [255,28,27;
254,30,29;
254,33,30;
253,36,32;
252,38,33;
251,41,35;
251,44,37;
250,46,38;
249,49,40;
249,51,41;
248,54,43;
247,57,44;
247,59,46;
246,62,48;
245,64,49;
244,67,51;
244,70,52;
243,72,54;
242,75,55;
242,78,57;
241,80,59;
240,83,60;
240,85,62;
239,88,63;
238,91,65;
237,93,66;
237,96,68;
236,99,70;
235,101,71;
235,104,73;
234,106,74;
233,109,76;
233,112,77;
232,114,79;
231,117,81;
230,119,82;
230,122,84;
229,125,85;
228,127,87;
228,130,89;
227,133,90;
226,135,92;
225,138,93;
225,140,95;
224,143,96;
223,146,98;
223,148,100;
222,151,101;
221,153,103;
221,156,104;
220,159,106;
219,161,107;
218,164,109;
218,167,111;
217,169,112;
216,172,114;
216,174,115;
215,177,117;
214,180,118;
214,182,120;
213,185,122;
212,188,123;
211,190,125;
211,193,126;
210,195,128;
209,196,128;
207,196,128;
206,197,128;
205,197,128;
203,198,128;
202,199,128;
201,199,128;
200,200,128;
198,201,128;
197,201,128;
196,202,128;
194,202,128;
193,203,128;
192,204,128;
191,204,128;
189,205,128;
188,206,128;
187,206,128;
185,207,128;
184,207,128;
183,208,128;
182,209,128;
180,209,128;
179,210,128;
178,211,128;
176,211,128;
175,212,128;
174,213,128;
173,213,128;
171,214,128;
170,214,128;
169,215,128;
167,216,128;
166,216,128;
165,217,128;
164,218,128;
162,218,128;
161,219,128;
160,219,128;
158,220,128;
157,221,128;
156,221,128;
155,222,128;
153,223,128;
152,223,128;
151,224,128;
149,225,128;
148,225,128;
147,226,128;
146,226,128;
144,227,128;
143,228,128;
142,228,128;
140,229,128;
139,230,128;
138,230,128;
137,231,128;
135,231,128;
134,232,128;
133,233,128;
131,233,128;
130,234,128;
129,235,128;
128,235,128;
128,234,130;
128,233,131;
128,233,132;
128,232,134;
128,232,135;
128,231,136;
128,231,138;
128,230,139;
128,229,141;
128,229,142;
128,228,143;
128,228,145;
128,227,146;
128,227,147;
128,226,149;
128,226,150;
128,225,151;
128,224,153;
128,224,154;
128,223,156;
128,223,157;
128,222,158;
128,222,160;
128,221,161;
128,220,162;
128,220,164;
128,219,165;
128,219,167;
128,218,168;
128,218,169;
128,217,171;
128,216,172;
128,216,173;
128,215,175;
128,215,176;
128,214,177;
128,214,179;
128,213,180;
128,212,182;
128,212,183;
128,211,184;
128,211,186;
128,210,187;
128,210,188;
128,209,190;
128,208,191;
128,208,193;
128,207,194;
128,207,195;
128,206,197;
128,206,198;
128,205,199;
128,204,201;
128,204,202;
128,203,204;
128,203,205;
128,202,206;
128,202,208;
128,201,209;
128,200,210;
128,200,212;
128,199,213;
128,199,214;
126,197,215;
125,194,216;
123,191,217;
122,189,217;
120,186,218;
118,183,219;
117,180,219;
115,178,220;
114,175,220;
112,172,221;
111,170,222;
109,167,222;
107,164,223;
106,162,224;
104,159,224;
103,156,225;
101,154,226;
100,151,226;
98,148,227;
96,145,228;
95,143,228;
93,140,229;
92,137,229;
90,135,230;
89,132,231;
87,129,231;
85,127,232;
84,124,233;
82,121,233;
81,119,234;
79,116,235;
77,113,235;
76,110,236;
74,108,237;
73,105,237;
71,102,238;
70,100,238;
68,97,239;
66,94,240;
65,92,240;
63,89,241;
62,86,242;
60,84,242;
59,81,243;
57,78,244;
55,75,244;
54,73,245;
52,70,245;
51,67,246;
49,65,247;
48,62,247;
46,59,248;
44,57,249;
43,54,249;
41,51,250;
40,49,251;
38,46,251;
37,43,252;
35,40,253;
33,38,253;
32,35,254;
30,32,254;
29,30,255;
27,27,255];
    
    co = co/255;
    
    myPanel = uipanel('parent', obj.handles.tabs, 'bordertype', 'none');
    myAxe = axes('parent', myPanel, 'ButtonDownFcn', @reset, 'colororder', co);
%     set(myAxe, 'colororder', hsv);
    
    if equal == 1
        axis equal;
    end

    obj.handles.lines{index} = cell(length(obj.model.nameList), 1);
    obj.handles.panels{index} = myPanel;
    obj.handles.axes{index} = myAxe;

    set(obj.handles.tabs, 'selection', index, ...
                'SelectionChangedFcn', @select);

    function reset(~,~)
        modifiers = get(obj.handles.figure,'currentModifier');
        ctrlIsPressed = ismember('control',modifiers);
        if ~ctrlIsPressed
            obj.model.selectedPolygons = {};
            set(obj.handles.list, 'value', []);
            updateSelectedPolygonsDisplay(obj);
        end
    end

    function select(~,~)
        updateSelectedPolygonsDisplay(obj);
        set(obj.handles.submenus{4}{3}, 'checked', get(obj.handles.axes{obj.handles.tabs.Selection}, 'xgrid'));
    end
end

function colors = distinguishable_colors(n_colors,bg,func)
% DISTINGUISHABLE_COLORS: pick colors that are maximally perceptually distinct
%
% When plotting a set of lines, you may want to distinguish them by color.
% By default, Matlab chooses a small set of colors and cycles among them,
% and so if you have more than a few lines there will be confusion about
% which line is which. To fix this problem, one would want to be able to
% pick a much larger set of distinct colors, where the number of colors
% equals or exceeds the number of lines you want to plot. Because our
% ability to distinguish among colors has limits, one should choose these
% colors to be "maximally perceptually distinguishable."
%
% This function generates a set of colors which are distinguishable
% by reference to the "Lab" color space, which more closely matches
% human color perception than RGB. Given an initial large list of possible
% colors, it iteratively chooses the entry in the list that is farthest (in
% Lab space) from all previously-chosen entries. While this "greedy"
% algorithm does not yield a global maximum, it is simple and efficient.
% Moreover, the sequence of colors is consistent no matter how many you
% request, which facilitates the users' ability to learn the color order
% and avoids major changes in the appearance of plots when adding or
% removing lines.
%
% Syntax:
%   colors = distinguishable_colors(n_colors)
% Specify the number of colors you want as a scalar, n_colors. This will
% generate an n_colors-by-3 matrix, each row representing an RGB
% color triple. If you don't precisely know how many you will need in
% advance, there is no harm (other than execution time) in specifying
% slightly more than you think you will need.
%
%   colors = distinguishable_colors(n_colors,bg)
% This syntax allows you to specify the background color, to make sure that
% your colors are also distinguishable from the background. Default value
% is white. bg may be specified as an RGB triple or as one of the standard
% "ColorSpec" strings. You can even specify multiple colors:
%     bg = {'w','k'}
% or
%     bg = [1 1 1; 0 0 0]
% will only produce colors that are distinguishable from both white and
% black.
%
%   colors = distinguishable_colors(n_colors,bg,rgb2labfunc)
% By default, distinguishable_colors uses the image processing toolbox's
% color conversion functions makecform and applycform. Alternatively, you
% can supply your own color conversion function.
%
% Example:
%   c = distinguishable_colors(25);
%   figure
%   image(reshape(c,[1 size(c)]))
%
% Example using the file exchange's 'colorspace':
%   func = @(x) colorspace('RGB->Lab',x);
%   c = distinguishable_colors(25,'w',func);

% Copyright 2010-2011 by Timothy E. Holy

  % Parse the inputs
  if (nargin < 2)
    bg = [1 1 1];  % default white background
  else
    if iscell(bg)
      % User specified a list of colors as a cell aray
      bgc = bg;
      for i = 1:length(bgc)
	bgc{i} = parsecolor(bgc{i});
      end
      bg = cat(1,bgc{:});
    else
      % User specified a numeric array of colors (n-by-3)
      bg = parsecolor(bg);
    end
  end
  
  % Generate a sizable number of RGB triples. This represents our space of
  % possible choices. By starting in RGB space, we ensure that all of the
  % colors can be generated by the monitor.
  n_grid = 30;  % number of grid divisions along each axis in RGB space
  x = linspace(0,1,n_grid);
  [R,G,B] = ndgrid(x,x,x);
  rgb = [R(:) G(:) B(:)];
  if (n_colors > size(rgb,1)/3)
    error('You can''t readily distinguish that many colors');
  end
  
  % Convert to Lab color space, which more closely represents human
  % perception
  if (nargin > 2)
    lab = func(rgb);
    bglab = func(bg);
  else
    C = makecform('srgb2lab');
    lab = applycform(rgb,C);
    bglab = applycform(bg,C);
  end

  % If the user specified multiple background colors, compute distances
  % from the candidate colors to the background colors
  mindist2 = inf(size(rgb,1),1);
  for i = 1:size(bglab,1)-1
    dX = bsxfun(@minus,lab,bglab(i,:)); % displacement all colors from bg
    dist2 = sum(dX.^2,2);  % square distance
    mindist2 = min(dist2,mindist2);  % dist2 to closest previously-chosen color
  end
  
  % Iteratively pick the color that maximizes the distance to the nearest
  % already-picked color
  colors = zeros(n_colors,3);
  lastlab = bglab(end,:);   % initialize by making the "previous" color equal to background
  for i = 1:n_colors
    dX = bsxfun(@minus,lab,lastlab); % displacement of last from all colors on list
    dist2 = sum(dX.^2,2);  % square distance
    mindist2 = min(dist2,mindist2);  % dist2 to closest previously-chosen color
    [~,index] = max(mindist2);  % find the entry farthest from all previously-chosen colors
    colors(i,:) = rgb(index,:);  % save for output
    lastlab = lab(index,:);  % prepare for next iteration
  end
end

function c = parsecolor(s)
  if ischar(s)
    c = colorstr2rgb(s);
  elseif isnumeric(s) && size(s,2) == 3
    c = s;
  else
    error('MATLAB:InvalidColorSpec','Color specification cannot be parsed.');
  end
end

function c = colorstr2rgb(c)
  % Convert a color string to an RGB value.
  % This is cribbed from Matlab's whitebg function.
  % Why don't they make this a stand-alone function?
  rgbspec = [1 0 0;0 1 0;0 0 1;1 1 1;0 1 1;1 0 1;1 1 0;0 0 0];
  cspec = 'rgbwcmyk';
  k = find(cspec==c(1));
  if isempty(k)
    error('MATLAB:InvalidColorString','Unknown color string.');
  end
  if k~=3 || length(c)==1,
    c = rgbspec(k,:);
  elseif length(c)>2,
    if strcmpi(c(1:3),'bla')
      c = [0 0 0];
    elseif strcmpi(c(1:3),'blu')
      c = [0 0 1];
    else
      error('MATLAB:UnknownColorString', 'Unknown color string.');
    end
  end
end
