function out = subjective_decomposition(discount_rate,cash_flow,price_ratio,kappa,rho,phi_h,coeff_h,se_coeff_h)

    %% subjective_decomposition.m
    % ########################################################################### %
    % function subjective_decomposition(discount_rate,cash_flow,price_ratio,...
    %           kappa,rho,phi_h,coeff_h,se_coeff_h)
    % Purpose:  Perform variance decomposition of cash flow and discount rate
    %           using a sunjective survey expectations
    %
    % Input:    discount_rate   = Tx1 vecntor of discount rate expectations
    %           cash flow       = Tx1 vecntor of cash flow expectations
    %           price_ration    = Tx1 vecntor of price ratio observations
    %           kappa           = Scalar value of intercept in log-linear model
    %           rho             = Scalar indicating persitence of price ratio
    %           phi_h           = Scalar indicating decay model parameter
    %           coeff_h         = Scalar indicating persitence of price ratio
    %           se_coeff_h      = Scalar indicating persitence of price ratio
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
    if size(discount_rate,1) ~= size(cash_flow,1) || size(discount_rate,1) ~= size(price_ratio,1)
        error('subjective_decomposition.m: Unequal number of observations in input series');
    end

    if (nargin < 8)
        error('subjective_decomposition.m: Not enough input parameters')
    end

    if (nargin > 8)
        error('subjective_decomposition.m: Too many input parameters');
    end

    %% Subjective-based variance decomposition
    % ########################################################################### %
    %{
        We first compute estimates one-year cash flow and discount rate components
        and then perfomr a full-horizon variance decomposition using a decay model.
    %}
    % ########################################################################### %

    long_term       = (price_ratio - kappa + discount_rate - cash_flow)/rho;
    decomp_short    = nwRegress([cash_flow -discount_rate rho.*long_term],price_ratio,1,6);

    out.CF1         = [ decomp_short.bv(2,1) decomp_short.sbv(2,1) ];
    out.DR1         = [ decomp_short.bv(2,2) decomp_short.sbv(2,2) ];
    out.LT          = [ decomp_short.bv(2,3) decomp_short.sbv(2,3) ];
    out.DR          = [ out.DR1(1)/(1 - rho*phi_h) sqrt(se_coeff_h^2*out.DR1(1)^2 + out.DR1(2)^2*coeff_h^2 ) + se_coeff_h^2*out.DR1(2)^2 ];
    out.CF          = [ 1-out.DR(1) out.DR(2) ];

end

% ########################################################################### %
% [EOF]
% ########################################################################### %


