% PI computation with probability mass function (discrete leakage variable)

function [perceived_information, conditional_entropy] = compute_pi_discrete_sampled(key_bits,  p_estimated, no_trials, traces)


key_range = 0:2^key_bits-1;




% create distributions for estimated parameters
for i=1:length(p_estimated)
    pd_estimated{i} = makedist('binomial','N',no_trials,'p',p_estimated(i));
end



% COMPUTATION PART

% compute perceived information and the conditional entropy (based on formula (11))

key_entropy = key_bits;

summation = 0;
for k=key_range
    % sampled probability
    sampled_prob = 1/length(traces{k+1});
    
    for l=(traces{k+1})'
        
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

        summation = summation + sampled_prob  * log2( pr_lgk / denom);
    end
end

% compute Pr[k]
pk = 1/length(key_range);

summation = pk * summation;

perceived_information = key_entropy + summation;

conditional_entropy = -summation;
