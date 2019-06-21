% MI computation with probability mass function (discrete leakage variable)

function [mutual_information, conditional_entropy] = compute_mi_discrete(key_bits)


key_range = 0:2^key_bits-1;





% START OF TRUE DISTRIBUTION ASSUMPTION

% N of binomial 
no_trials = 20;

% The support (nonzero values) of the binomial pmf is {0,1,2,3,...,N_true}
% These are the leakage values that have nonzero probability
l_range = 0:no_trials;

% true p parameter
% create the true pmfs for every key k (Pr[l|k]) by using a different 
% true p parameters
p_true=linspace(0.1, 0.9, length(key_range));
for i=1:length(p_true)
    pd_true{i} = makedist('binomial','N',no_trials,'p',p_true(i));
end

% END OF TRUE DISTRIBUTION ASSUMPTION



% COMPUTATION PART

% compute mutual information and the conditional entropy (based on formula (2))

key_entropy = key_bits;

summation = 0;
for k=key_range
    for l=l_range
        
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
    
        summation = summation + pr_lgk * log2( pr_lgk / denom);
    end
end

% compute Pr[k]
pk = 1/length(key_range);

summation = pk * summation;

mutual_information = key_entropy + summation;

conditional_entropy = -summation;
