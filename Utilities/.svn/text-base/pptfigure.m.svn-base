function pptfigure(varargin)
% pptfigure
%   Creates a new figure with a PowerPoint Export button on the toolbar.
%
% pptfigure(AX)
%   Exports figure with handle AX to PowerPoint.
%   Converts Matlab objects to PowerPoint objects and deletes back panels.
%   Aligns and anchors all text boxes such that the figure can be resized
%      and fonts changed without misaligning the labels.
%   If AX does not exist, creates a new figure with a PowerPoint export
%      button on the toolbar.
%
%  pptfigure works on any 2D plots, including figures with multiple
%      subplots.
%
% WARNING: program may run slowly the first time in each Matlab session.
%
% by Dmitriy Aronov, 2007
% modified for compatibility with Matlab 7.9.0 and PowerPoint 2007 in 2010

if isempty(varargin) || ~ishandle(varargin{1})
    % Create new figure
    fig = figure;
    tb = findall(fig,'Type','uitoolbar');
    uipushtool(tb,'CData',get_ppt_image,'Separator','on',...
        'HandleVisibility','off','ToolTipString', ...
        'PowerPoint Export','ClickedCallback', ...
        ['pptfigure(' num2str(fig) ')']);
else
    fig = varargin{1};
    
    % Generate dummy figure containing text alignment info
    axs = findobj('type','axes','parent',fig);
    xticklabs = cell(1,length(axs));
    yticklabs = cell(1,length(axs));
    titles = cell(1,length(axs));
    xlabs = cell(1,length(axs));
    ylabs = cell(1,length(axs));
    for c = 1:length(axs)
        subplot(axs(c));
        
        h = get(gca,'xlabel');
        xlabs{c} = get(h,'string');
        if ~isempty(xlabs{c})
            set(h,'string','@@ct');
        end
        
        h = get(gca,'ylabel');
        ylabs{c} = get(h,'string');
        if ~isempty(ylabs{c})
            set(h,'string','@@cb');
        end
        
        h = get(gca,'title');
        titles{c} = get(h,'string');
        if ~isempty(titles{c})
            set(h,'string','@@cb');
        end
        
        dm = get(gca,'xticklabel');
        set(gca,'xticklabel',repmat('@@ct',size(dm,1),1));
        if ~iscell(dm)
            for d = 1:size(dm,1)
                xticklabs{c}{d} = deblank(dm(d,:));
            end
        else
            xticklabs{c} = dm;
        end
        
        dm = get(gca,'yticklabel');
        set(gca,'yticklabel',repmat('@@rm',size(dm,1),1));
        if ~iscell(dm)
            for d = 1:size(dm,1)
                yticklabs{c}{d} = deblank(dm(d,:));
            end
        else
            yticklabs{c} = dm;
        end
    end
    f = findobj('type','text');
    txtbox = cell(1,length(f));
    for c = 1:length(f)
        txtbox{c} = get(f(c),'string');
        ha = get(f(c),'horizontalalignment');
        va = get(f(c),'verticalalignment');
        set(f(c),'string',['@@' ha(1) va(1)]);
    end
    
    % Connect to PowerPoint
    ppt = actxserver('PowerPoint.Application');
    
    % Open current presentation
    if get(ppt.Presentations,'Count')==0
        op = invoke(ppt.Presentations,'Add');
    else
        op = get(ppt,'ActivePresentation');
    end
    
    % Set slide object to be the active pane
    panes = get(get(ppt,'ActiveWindow'),'Panes');
    slide_pane = invoke(panes,'Item',2);
    invoke(slide_pane,'Activate');
    
    % Add new slide
    slide_count = get(op.Slides,'Count');
    slide_count = int32(double(slide_count)+1);
    slide = invoke(op.Slides,'Add',slide_count,11);
    invoke(slide,'Select');
    
    % Copy and paste the dummy figure
    set(fig,'PaperPositionMode','manual','Renderer','painters')
    print('-dmeta',['-f' num2str(fig)])
    pic = invoke(slide.Shapes,'PasteSpecial',2);
    
    % Ungroup the image
    ug = invoke(pic,'Ungroup');
    invoke(ug,'Ungroup');
    invoke(ppt.ActiveWindow.Selection,'Unselect');
    
    % Determine text box identities
    iden = cell(1,get(slide.Shape,'Count'));
    for c = 1:length(iden)
        obj = slide.Shape.Item(c);
        if strcmp(get(obj,'HasTextFrame'),'msoTrue') ...
                && ~isempty(get(obj.TextFrame.TextRange,'Text'))
            txt = get(obj.TextFrame.TextRange,'Text');
            if length(txt)>3 && strcmp(txt(1:2),'@@')
                iden{c} = txt(3:4);
            else
                iden{c} = 'cm';
            end
        else
            iden{c} = '';
        end
    end
    isem = cellfun(@(x)isempty(x),iden);
    iden(isem==1) = [];
    
    % Delete dummy slide
    invoke(slide,'Delete');
    
    % Return text box values to normal
    for c = 1:length(axs)
        subplot(axs(c));
        
        h = get(gca,'xlabel');
        set(h,'string',xlabs{c});
        
        h = get(gca,'ylabel');
        set(h,'string',ylabs{c});
        
        h = get(gca,'title');
        set(h,'string',titles{c});
        
        set(gca,'xticklabel',xticklabs{c});
        
        set(gca,'yticklabel',yticklabs{c});
    end
    f = findobj('type','text');
    for c = 1:length(f)
        set(f(c),'string',txtbox{c});
    end
    
    % Add new slide
    slide_count = get(op.Slides,'Count');
    slide_count = int32(double(slide_count)+1);
    slide = invoke(op.Slides,'Add',slide_count,11);
    invoke(slide,'Select');
    invoke(slide.Shapes.Range,'Delete');
    
    % Copy and paste the actual figure
    set(fig,'PaperPositionMode','manual','Renderer','painters')
    print('-dmeta',['-f' num2str(fig)])
    pic = invoke(slide.Shapes,'PasteSpecial',2);
    
    % Ungroup the image
    ug = invoke(pic,'Ungroup');
    invoke(ug,'Ungroup');
    invoke(ppt.ActiveWindow.Selection,'Unselect');
    
    % Format text boxes;
    cnt = 1;
    for c = 1:get(slide.Shape,'Count')
        obj = slide.Shape.Item(c);
        if strcmp(get(obj,'HasTextFrame'),'msoTrue') ...
                && ~isempty(get(obj.TextFrame.TextRange,'Text'))
            
            set(obj.TextFrame,'AutoSize','ppAutoSizeShapeToFitText');
            wd = get(obj,'Width');
            lf = get(obj,'Left');
            switch iden{cnt}(1) % Horizontal alignment
                case 'c'
                    set(obj.TextFrame.TextRange.ParagraphFormat, ...
                        'Alignment','ppAlignCenter');
                case 'l'
                    set(obj.TextFrame.TextRange.ParagraphFormat, ...
                        'Alignment','ppAlignLeft');
                case 'r'
                    set(obj.TextFrame.TextRange.ParagraphFormat, ...
                        'Alignment','ppAlignRight');
            end
            
            switch iden{cnt}(2) % vertical alignment
                case {'t','c'}
                    set(obj.TextFrame,'VerticalAnchor','msoAnchorTop');
                case 'm'
                    set(obj.TextFrame,'VerticalAnchor','msoAnchorMiddle');
                case 'b'
                    set(obj.TextFrame,'VerticalAnchor','msoAnchorBottom');
            end
            
            set(obj,'Width',wd);
            set(obj,'Left',lf);
            
            cnt = cnt + 1;
        end
    end
    
    % Delete back panel
    invoke(invoke(slide.Shapes,'Item',1),'Delete')
    invoke(invoke(slide.Shapes,'Item',1),'Delete')
    
    % Group objects
    grp = invoke(slide.Shapes.Range,'group');
    
    % Center figure
    slide_h = op.PageSetup.SlideHeight;
    slide_w = op.PageSetup.SlideWidth;
    pic_h = get(grp,'Height');
    pic_w = get(grp,'Width');
    set(grp,'Top',(slide_h-pic_h)/2);
    set(grp,'Left',(slide_w-pic_w)/2); 
end

function img = get_ppt_image
% Image for the PowerPoint toolbar button

img = [
 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
 0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 1
 0 1 1 0 1 0 1 1 0 1 0 1 0 1 0 1
 0 1 1 0 1 0 1 1 0 1 1 1 0 1 1 1
 0 1 1 0 1 0 1 1 0 1 1 1 0 1 1 1
 0 0 0 1 1 0 0 0 1 1 1 1 0 1 1 1
 0 1 1 1 1 0 1 1 1 1 1 1 0 1 1 1
 0 1 1 1 1 0 1 1 1 1 1 1 0 1 1 1
 0 1 1 1 1 0 1 1 1 1 1 1 0 1 1 0
 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
 ];

img = cat(3,img,img,img);