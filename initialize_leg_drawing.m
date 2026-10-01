%Creates a set of plotting objects to keep track of each link drawing
%each vertex drawing, and the crank drawing
%INPUTS:
%leg_params: a struct containing the parameters that describe the linkage
%OUTPUTS:
%leg_drawing: a struct containing all the plotting objects for the linkage
%       leg_drawing.linkages is a cell array, where each element corresponds
%       to a plot of a single link (excluding the crank)
%       leg_drawing.crank is a plot of the crank link
%       leg_drawing.vertices is a cell array, where each element corresponds
%       to a plot of one of the vertices in the linkage
%       leg_drawing.foot_path is the path traced by the foot vertex
function leg_drawing = initialize_leg_drawing(leg_params)
    fig1 = figure(1);
    axis equal;
    axis([-150 100 -150 100]);
    grid on;
    hold on;

    leg_drawing = struct();
    leg_drawing.fig = fig1;
    leg_drawing.linkages = cell(leg_params.num_linkages,1);
    
    for linkage_index = 1:leg_params.num_linkages
        leg_drawing.linkages{linkage_index} = line([0,0],[0,0],'color','k','linewidth',2);
    end
    
    leg_drawing.crank = line([0,0],[0,0],'color','k','linewidth',1.5);
    
    leg_drawing.vertices = cell(leg_params.num_vertices,1);
    for vertex_index = 1:leg_params.num_vertices
        leg_drawing.vertices{vertex_index} = line(0,0,'marker',...
          'o','markerfacecolor','r','markeredgecolor','r','markersize',8);
    end
    
    leg_drawing.foot_path = plot(NaN, NaN, 'b-', 'LineWidth', 1.5);

    set(fig1, 'units', 'pixels', 'position', [0 0 3840 2160])
    ax = gca;
    ax.FontSize = 30;
    title("Strandbeest Leg Animation", "Interpreter", "latex")
    xlabel("X Position (-)", "Interpreter", "latex")
    ylabel("Y Position (-)", "Interpreter", "latex")
end