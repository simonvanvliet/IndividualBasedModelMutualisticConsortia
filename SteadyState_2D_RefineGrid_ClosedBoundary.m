function [output,muAsFunctionOfGridSize,finalGridScaling,varargout]=SteadyState_2D_RefineGrid_ClosedBoundary(settings,input)
% Grid refinement routine for SOR solver
% Calculates steady state solution for 2D model of amino acid exchange
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
% Boundary conditions: no flux on left, right, and top wall, [E]=0 on bottom wall
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 28.4.2018
% Last update: 28.4.2018

%toggle feedback
TalkToMe=0;

%% first run at base grid
settings.gridScaling=settings.gridScalingBase;

muAsFunctionOfGridSize=struct; %store growth rate as function of grid size

output=SteadyState_2D_SOR_Solver_ClosedBoundary(settings,input);

muAsFunctionOfGridSize.(['gridScale_',num2str(settings.gridScaling)])=output.mu;
if TalkToMe; fprintf('SteadyState_2D_RefineGrid_ClosedBoundary-> Increasing gridScaling to %i, check if mu has converged\n',2*settings.gridScaling); end

%% Run solver, keep refining grid untill solution converges
muConverged=0;

while ~muConverged % refine grid
    %store previous growth rate
    muOld=output.mu;
    varargout{1}=output;
    
    %increase grid size
    settings.gridScaling=settings.gridScaleFactor*settings.gridScaling;
    
    %input previous solution as new initial guess
    input=output;
    input.gridE1=imresize(output.gridE1,settings.gridScaleFactor,'nearest');
    input.gridE2=imresize(output.gridE2,settings.gridScaleFactor,'nearest');
    input.gridCellTypeScaled=imresize(output.gridCellTypeScaled,settings.gridScaleFactor,'nearest');
    
    %solve at finer grid
    output=SteadyState_2D_SOR_Solver_ClosedBoundary(settings,input);
    muAsFunctionOfGridSize.(['gridScale_',num2str(settings.gridScaling)])=output.mu;
    
    %compare absolute error between old and new mu to muTolerance
    muNew=output.mu;
    
    muError=max(max(abs(muNew-muOld)));
    if muError>settings.muTolerance
        if TalkToMe; fprintf('SteadyState_2D_RefineGrid_ClosedBoundary-> Increasing gridScaling to %i, max abs error mu=%.2g\n',2*settings.gridScaling,muError); end
        if settings.gridScaling>=settings.maxGridScaling
            muConverged=1;
            fprintf('!!! SteadyState_2D_RefineGrid_ClosedBoundary-> mu has not converged. ru=%.2g, rl=%.2g\n',settings.ru,settings.rl);
        end
    else
        muConverged=1;
        if TalkToMe; fprintf('SteadyState_2D_RefineGrid_ClosedBoundary-> mu has converged. GridScale used=%i, max abs error mu=%.2g\n',settings.gridScaling,muError);end
    end
end

finalGridScaling=settings.gridScaling;
