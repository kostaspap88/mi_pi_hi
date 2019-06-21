% HI computation with probability mass function (discrete leakage variable)

function [hypothetical_information, conditional_entropy] = compute_hi_discrete(key_bits, p_estimated, no_trials)


key_range = 0:2^key_bits-1;

l_range = 0:no_trials;

% create distributions for estimated parameters
for i=1:length(p_estimated)
    pd_estimated{i} = makedist('binomial','N',no_trials,'p',p_estimated(i));
end



% COMPUTATION PART

% compute hypothetical information and the conditional entropy (based on formula (7))

key_entropy = key_bits;

summation = 0;
for k=key_range
    for l=l_range
        
        % select the numerator pmf
        num_dist=pd_estimated{k+1};
        % compute Pr[l|k]
        pr_lgk = num_dist.pdf(l);
        
        % compute denominator
        denom = 0;
        for k_star = key_range
            % select the denominator pmf
            denom_dist = pd_estimated{k_star+1};
            denom = denom + denom_dist.pdf(l); 
        end
    
        summation = summation + pr_lgk * log2( pr_lgk / denom);
    end
end

% compute Pr[k]
pk = 1/length(key_range);

summation = pk * summation;

hypothetical_information = key_entropy + summation;

conditional_entropy = -summation;
