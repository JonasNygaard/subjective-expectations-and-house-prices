function out = rational_decomposition(z_matrix,rho)

    %% rational_decomposition.m
    % ########################################################################### %
    % function rational_decomposition(z_matrix,rho)
    % Purpose:  Perform variance decomposition of cash flow and discount rate
    %           using a VAR(1) model for ratioanl expectations
    %
    % Input:    z_matrix    = Tx3 matrix of cash flow, discount rate, and price ratio
    %           rho         = Scalar indicating persitence of price ratio
    %
    % Output:   A structure including
    %           CF1         = One-year cash flow component and standard error
    %           DR1         = One-year discount rate component and standard error
    %           LT          = Long-term component and standard error
    %           CF          = Full-horizon cash flow component and standard error
    %           DR          = Full-horizon discount rate component and standard error
    %           
    % Author:
    % Jeppe Bro, ATP
    % Jonas N. Eriksen, Aarhus University
    %
    % Encoding: UTF8
    % Last modified: January 2025
    % ########################################################################### %

    %% Error checking on inpu
    if size(z_matrix,2) ~= 3
        error('rational_decomposition.m: Not enough variables in z_matrix');
    end

    if (nargin < 2)
        error('rational_decomposition.m: Not enough input parameters')
    end

    if (nargin > 2)
        error('rational_decomposition.m: Too many input parameters');
    end

    %% VAR-based variande decomposition
    % ########################################################################### %
    %{
        We first compute estimates a VAR(1) model for rational expectations 
        and then perfomr a standard Campbell-Shille variance decomposition. 
    %}
    % ########################################################################### %
    
    % Estimate VAR(1) model coefficients
    res_var         = nwRegress(z_matrix(5:end,:),z_matrix(1:end-4,:),1,6);
    B               = res_var.bv(1,:)';
    A               = res_var.bv(2:end,:)';

    % Computing VAR-based rational expectations
    z_hat           = (B + A*z_matrix(1:end,:)')';

    % Computing one-year variance decomposition
    decomp_short    = nwRegress([z_hat(:,1) -z_hat(:,2) rho*z_hat(:,3)],z_matrix(1:end,3),1,6);
    
    % Outputting one-year components and standard errirs
    out.CF1         = [ decomp_short.bv(2,1) decomp_short.sbv(2,1) ];
    out.DR1         = [ decomp_short.bv(2,2) decomp_short.sbv(2,2) ];
    out.LT          = [ decomp_short.bv(2,3) decomp_short.sbv(2,3) ];

    % Constucting selection matrices
    e1              = [ 1 0 0 ];
    e2              = [ 0 1 0 ];

    % Computing cash flow and discount rate components
    CF              = z_matrix(1:end,:)*(e1*((eye(3)-rho*A)\A))';
    DR              = z_matrix(1:end,:)*(e2*((eye(3)-rho*A)\A))';

    % Computing full-horizon variance decomposition
    decomp_full     = nwRegress([CF(1:end,1) -DR(1:end,1)],z_matrix(1:end,3),1,6);

    % Oututputting full-horizon components and standard errors
    out.CF          = [decomp_full.bv(2,1) decomp_full.sbv(2,1)];
    out.DR          = [decomp_full.bv(2,2) decomp_full.sbv(2,2)];

end

% ########################################################################### %
% [EOF]
% ########################################################################### %