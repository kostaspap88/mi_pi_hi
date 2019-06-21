% MI computation with probability mass function (discrete leakage variable)

function [mutual_information, conditional_entropy] = compute_mi_discrete_sampled(key_bits, no_samples)


key_range = 0:2^key_bits-1;


% START OF TRUE DISTRIBUTION ASSUMPTION

% To compute MI_discrete_sampled we need to know the true conditional probability
% mass function Pr(l|k)
% For example, we can assume that
% Pr(l|k) ~ Binomial distribution(N, p_true)


no_trials = 20;

% true p parameter
% create the true pmfs for every key k (Pr[l|k]) by using a different 
% true p parameters
p_true=linspace(0.1, 0.9, length(key_range));
for i=1:length(p_true)
    pd_true{i} = makedist('binomial','N',no_trials,'p',p_true(i));
end

% sample the theoretical distribution for every key k
% samples taken from each pmf
test_set_size = no_samples;
for i=1:length(p_true)
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
        
        % select the numerator pmf
        num_dist=pd_true{k+1};
        % compute Pr[l|k]
        pr_lgk = num_dist.pdf(l);
        
        % compute denominator
        denom = 0;
        for k_star = key_range
            % select the denominator pmf
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
