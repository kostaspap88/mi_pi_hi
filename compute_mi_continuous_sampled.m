% MI computation with probability density function (continuous leakage variable)

function [mutual_information, conditional_entropy] = compute_mi_continuous_sampled(key_bits, no_samples)


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
    pd_true{i} = makedist('normal','mu',mu_true(i)*10,'sigma',sigma_true);
end


% sample the theoretical distribution for every key k
% samples taken from each pdf
test_set_size = no_samples;
for i=1:length(mu_true)
    test_set{i} = random(pd_true{i}, test_set_size, 1);
end


% END OF TRUE DISTRIBUTION ASSUMPTION




% COMPUTATION PART

% compute mutual information and the conditional entropy (based on formula (6))

key_entropy = key_bits;

summation = 0;
for k=key_range
    % sampled probability
    sampled_prob = 1/length(test_set{k+1});
    
    for l=(test_set{k+1})'
        
        % select the numerator pdf
        num_dist=pd_true{k+1};
        % compute Pr[l|k]
        pr_lgk = num_dist.pdf(l);
        
        % compute denominator
        denom = 0;
        for k_star = key_range
            % select the denominator pdf
            denom_dist = pd_true{k_star+1};
            denom = denom + denom_dist.pdf(l); 
        end

        summation = summation + sampled_prob  * log2( pr_lgk / denom);
    end
end

% compute Pr[k]
pk = 1/length(key_range);

summation = pk * summation;

mutual_information = key_entropy + summation;

conditional_entropy = -summation;