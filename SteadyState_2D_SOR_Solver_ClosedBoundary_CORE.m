function [exGridE1,exGridE2,numIt,errorCode]=SteadyState_2D_SOR_Solver_ClosedBoundary_CORE...
    (exGridE1,exGridE2,extendedGridType,numGridPoint1D,dx,...
    ru1,ru2,rl1,rl2,D1,D2,Iconst1,Iconst2,alpha,...
    tolerance,omega)
% Core solver, called from all other codes that solve 2D steady state problem
% Calculates steady state solution for 2D model of amino acid exchange
%
% two cell types:
%   type 0 produces AA1, growth limited by AA2
%   type 1 produces AA2, growth limited by AA1
%   type 0 produces pro, growth limited by try: Delta try on left
%   type 1 produces try, growth limited by pro: Delta pro on right
% internal concentration of produced AA is set to Iconst
% AA uptake is linear with [E], leakage is passive diffusion
% uptake, leakage, and diffusion rates can be assymetric between AA
% effective diffusion constant = (1-p)/(1+p/2), where p is density
% time scaled with growth rate (1h doubling time)
% space scaled with cell size (settings.cellSpacing um)
% concentrations scaled with Km of growth for each AA
%
% Boundary conditions: no flux on left, right, and top wall, [E]=0 on bottom wall
%
% Solved with iterative finite difference scheme using successive over-relaxation (SOR) method
%
% Written by Simon van Vliet & Alma Dal Co
% Eawag & ETH Zurich
%
% Initial development: 10.5.2018
% Last update: 10.5.2018

%% Run SOR
isNotConverged=1;
numIt=0;
errorCode=0;

while isNotConverged
    
    %update grids
    prevGridE1=exGridE1;
    prevGridE2=exGridE2;
    numIt=numIt+1;
    
    exGridE1(1,2:end-1)=exGridE1(3,2:end-1); %zero flux at top boundary
    exGridE1(end,2:end-1)=exGridE1(end-2,2:end-1); %zero flux at bottom boundary

    exGridE1(2:end-1,1)=exGridE1(2:end-1,3); %zero flux at left boundary
    exGridE1(2:end-1,end)=exGridE1(2:end-1,end-2); %zero flux at right boundary
    
    exGridE2(1,2:end-1)=exGridE2(3,2:end-1); %zero flux at top boundary
    exGridE2(end,2:end-1)=exGridE2(end-2,2:end-1); %zero flux at bottom boundary
    exGridE2(2:end-1,1)=exGridE2(2:end-1,3); %zero flux at left boundary
    exGridE2(2:end-1,end)=exGridE2(2:end-1,end-2); %zero flux at right boundary
    
    localConvergence=1;
    localDivergence=0;
    
    %loop over grid
    for xx=2:numGridPoint1D+1 %loop over interior, note: grid is extended by 2 pixels for boundary conditions
        for yy=2:numGridPoint1D+1
            %approximate Nabda E
            dDif1=exGridE1(yy-1,xx) + exGridE1(yy+1,xx) + exGridE1(yy,xx-1) + exGridE1(yy,xx+1);
            dDif2=exGridE2(yy-1,xx) + exGridE2(yy+1,xx) + exGridE2(yy,xx-1) + exGridE2(yy,xx+1);
            
            E1=exGridE1(yy,xx);
            if E1<0, E1=0; end
            
            E2=exGridE2(yy,xx);
            if E2<0, E2=0; end
            
            type=extendedGridType(yy,xx);
                        
            I1ofE1=(E1*(ru1+rl1)-rl1)/(2+2*rl1)...
                + sqrt( (ru1+rl1)^2*E1^2 + 2*(rl1+2)*(ru1+rl1)*E1 + rl1^2 ) / (2+2*rl1);
            
            I2ofE2=(E2*(ru2+rl2)-rl2)/(2+2*rl2)...
                + sqrt( (ru2+rl2)^2*E2^2 + 2*(rl2+2)*(ru2+rl2)*E2 + rl2^2 ) / (2+2*rl2);
            
            sourceE1=alpha*E1*(ru1+rl1)/D1 -    alpha*Iconst1*(1-type)*rl1/D1 - alpha* I1ofE1*type*rl1/D1;
            sourceE2=alpha*E2*(ru2+rl2)/D2 -    alpha* I2ofE2*(1-type)*rl2/D2 - alpha*Iconst2*type*rl2/D2;
            
            %update grid point, SOR algorithm
            exGridE1(yy,xx)=(1-omega)*exGridE1(yy,xx) + omega*( dDif1 - dx^2*sourceE1)/4;
            exGridE2(yy,xx)=(1-omega)*exGridE2(yy,xx) + omega*( dDif2 - dx^2*sourceE2)/4;
            
            errorE1=abs((prevGridE1(yy,xx)-exGridE1(yy,xx))/exGridE1(yy,xx));
            errorE2=abs((prevGridE2(yy,xx)-exGridE2(yy,xx))/exGridE2(yy,xx));
            
            if errorE1>tolerance
                localConvergence=0;
            end
            if errorE2>tolerance
                localConvergence=0;
            end
            
            if errorE1>1e6 || errorE2>1e6
                localDivergence=1;
            end
        end
    end
    
    if localConvergence==1
        isNotConverged=0; %solved
    end
    
    if localDivergence==1
        isNotConverged=0; %no convergence
        errorCode=1;
    end
    
end



