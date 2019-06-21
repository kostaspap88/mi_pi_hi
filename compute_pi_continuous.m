% PI computation with probability density function (continuous leakage variable)

function [perceived_information, conditional_entropy] = compute_pi_continuous(key_bits, mu_estimated, sigma_estimated)


key_range = 0:2^key_bits-1;


% START OF TRUE DISTRIBUTION ASSUMPTION

% true sigma parameter
sigma_true = 1;
 
% true mu parameter
% create the true pmfs for every key k (Pr[l|k]) by using a different 
% true mu parameter
mu_true=key_range;
for i=1:length(mu_true)
    pd_true(i) = makedist('normal','mu',mu_true(i)*10,'sigma',sigma_true);
end

% END OF TRUE DISTRIBUTION ASSUMPTION

% create distributions for the estimated parameters
for i=1:length(mu_estimated)
    pd_estimated(i) = makedist('normal','mu',mu_estimated(i),'sigma',sigma_estimated(i));
end



% COMPUTATION PART

% define the function to integrate over

probf = @(l,mypd) mypd.pdf(l);

denomf = @(l,pd_estimated) sum(arrayfun(probf, repmat(l, length(pd_estimated),1), repmat(pd_estimated',1, length(l))));

f = @(l,pd_true,pd_estimated,k) probf(l,pd_true(k+1)) .* log2( probf(l,pd_estimated(k+1)) / denomf(l,pd_estimated)); 

% compute mutual information and the conditional entropy (based on formula (10))

key_entropy = key_bits;

summation = 0;
for k=key_range    
    % standard MATLAB integration formula uses adaptive quadrature
    % citation: "Vectorized adaptive quadrature in matlab, L.F. Shampine"
    % note: I am not particularly happy with this computation
    % not sure how Infinite bounds are handled
    % sampled version seems to perform better
    summation = summation + integral(@(l)f(l,pd_true,pd_estimated,k), -Inf, Inf);
    % can use waypoints to (possibly) improve certain regions of the integral
    % summation = summation + integral(@(l)f(l,pd,k), -Inf, Inf, 'Waypoints', [0 10 20 30]); 
    % can specify error tolerance
    % summation = summation + integral(@(l)f(l,pd,k), -Inf, Inf, 'AbsTol', 1e-10, 'RelTol', 1e-14);
         
end

% compute Pr[k]
pk = 1/length(key_range);

summation = pk * summation;

perceived_information = key_entropy + summation;

conditional_entropy = -summation;
