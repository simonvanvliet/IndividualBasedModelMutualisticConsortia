function [output,muAsFunctionOfGridSize,finalGridScaling,varargout]  =  SteadyState_3D_RefineGrid(settings,input)
% Grid refinement routine for SOR solver
% Calculates steady state solution for 3D model of amino acid exchange
% Grid size is refined iterativaly until the solution converges
%
%% settings: model parameters
%% input: initial guess of solution
%% output: steady state solution,  
%% muAsFunctionOfGridSize: structure with growth profile for each grid size
%% finalGridScaling: scale factor for first grid at which solution is converged
%
% type 0 produces pro, growth limited by try
% type 1 produces try, growth limited by pro
% Boundary conditions: no flux on left, right, and top wall, [E] = 0 on bottom wall
%
% Written by Simon van Vliet[1] & Alma Dal Co[2]
% [1] UBC Vancouver, [2] Harvard University
%
% Initial development: 06.02.2020
% Last update: 06.02.2020


%toggle feedback
TalkToMe = 0;

%% first run at base grid
settings.gridScaling = settings.gridScalingBase;

muAsFunctionOfGridSize = struct; %store growth rate as function of grid size

output = SteadyState_3D_SOR_Solver(settings,input);

muAsFunctionOfGridSize.(['gridScale_',num2str(settings.gridScaling)]) = output.mu;
if TalkToMe; fprintf('SteadyState_3D_RefineGrid-> Increasing gridScaling to %i, check if mu has converged\n',2*settings.gridScaling); end

%% Run solver, keep refining grid untill solution converges
muConverged = 0;

while ~muConverged % refine grid
    %store previous growth rate
    muOld = output.mu;
    varargout{1} = output;
    
    %increase grid size
    settings.gridScaling = settings.gridScaleFactor*settings.gridScaling;
    
    %input previous solution as new initial guess
    input = output;
    
    %calculate output
    if settings.gridSize(3) == 1 %2D
        input.gridE1 = imresize(output.gridE1,settings.gridScaleFactor,'nearest');
        input.gridE2 = imresize(output.gridE2,settings.gridScaleFactor,'nearest');
        input.gridCellTypeScaled = imresize(output.gridCellTypeScaled,settings.gridScaleFactor,'nearest');
    else %3D
        input.gridE1 = imresize3(output.gridE1,settings.gridScaleFactor,'nearest');
        input.gridE2 = imresize3(output.gridE2,settings.gridScaleFactor,'nearest');
        input.gridCellTypeScaled = imresize3(output.gridCellTypeScaled,settings.gridScaleFactor,'nearest');
    end    
    
    %solve at finer grid
    output = SteadyState_3D_SOR_Solver(settings,input);
    muAsFunctionOfGridSize.(['gridScale_',num2str(settings.gridScaling)]) = output.mu;
     
    %compare absolute error between old and new mu to muTolerance
    muNew = output.mu;
    
    muError = max(max(abs(muNew-muOld)));
    if muError>settings.muTolerance
        if TalkToMe; fprintf('SteadyState_3D_RefineGrid-> Increasing gridScaling to %i, max abs error mu = %.2g\n',2*settings.gridScaling,muError); end
        if settings.gridScaling >= settings.maxGridScaling
            muConverged = 1;
            fprintf('!!! SteadyState_3D_RefineGrid-> mu has not converged. ru = %.2g, rl = %.2g\n',settings.ru,settings.rl);
        end
    else
        muConverged = 1;
        if TalkToMe; fprintf('SteadyState_3D_RefineGrid-> mu has converged. GridScale used = %i, max abs error mu = %.2g\n',settings.gridScaling,muError);end
    end
end

finalGridScaling = settings.gridScaling;
