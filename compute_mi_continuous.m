% MI computation with probability density function (continuous leakage variable)

function [mutual_information, conditional_entropy] = compute_mi_continuous(key_bits)


key_range = 0:2^key_bits-1;


% START OF TRUE DISTRIBUTION ASSUMPTION

% To compute MI_discrete we need to know the true conditional probability
% mass function Pr(l|k)
% For example, in this function  we assume that
% Pr(l|k) ~ Normal Distribution (mu_true, sigma_true)

% The support (nonzero values) of the normal pdf is (-Inf, Inf)
% Thus we need to integrate over this interval


% true sigma parameter
sigma_true = 1;
 
% true mu parameter
% create the true pmfs for every key k (Pr[l|k]) by using a different 
% true mu parameter
mu_true=key_range;
for i=1:length(mu_true)
    pd_true(i) = makedist('normal','mu',mu_true(i)*10,'sigma',sigma_true);
end



% % plot the true pdf
% figure;
% for i=1:length(mu_true)
%     current_dist = pd(i);
%     plot([(mu_true(i)-5*sigma_true):0.2:(mu_true(i)+5*sigma_true)],current_dist.pdf((mu_true(i)-5*sigma_true):0.2:(mu_true(i)+5*sigma_true)))
%     hold on;
% end
% hold off;

% END OF TRUE DISTRIBUTION ASSUMPTION





% COMPUTATION PART

% define the function to integrate over

probf = @(l,mypd) mypd.pdf(l);

denomf = @(l,pd) sum(arrayfun(probf, repmat(l, length(pd),1), repmat(pd',1, length(l))));

f = @(l,pd,k) probf(l,pd(k+1)) .* log2( probf(l,pd(k+1)) / denomf(l,pd)); 

% compute mutual information and the conditional entropy (based on formula (4))

key_entropy = key_bits;

summation = 0;
for k=key_range    
    % standard MATLAB integration formula uses adaptive quadrature
    % citation: "Vectorized adaptive quadrature in matlab, L.F. Shampine"
    % note: I am not particularly happy with this computation
    % not sure how Infinite bounds are handled
    % sampled version seems to perform better
    summation = summation + integral(@(l)f(l,pd_true,k), -Inf, Inf);
    % can use waypoints to (possibly) improve certain regions of the integral
    % summation = summation + integral(@(l)f(l,pd,k), -Inf, Inf, 'Waypoints', [0 10 20 30]); 
    % can specify error tolerance
    % summation = summation + integral(@(l)f(l,pd,k), -Inf, Inf, 'AbsTol', 1e-10, 'RelTol', 1e-14);
         
end

% compute Pr[k]
pk = 1/length(key_range);

summation = pk * summation;

mutual_information = key_entropy + summation;

conditional_entropy = -summation;
