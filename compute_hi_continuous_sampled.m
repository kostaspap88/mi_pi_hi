% HI computation with probability density function (continuous leakage variable)

function [hypothetical_information, conditional_entropy] = compute_hi_continuous_sampled(key_bits, no_traces, mu_estimated, sigma_estimated)


key_range = 0:2^key_bits-1;



% create distributions from the estimated mu and estimated sigma
for i=1:length(mu_estimated)
    pd_estimated{i} = makedist('normal','mu',mu_estimated(i),'sigma',sigma_estimated(i));
end


% sample the estimated distributions
for i=1:length(mu_estimated)
    test_set{i} = random(pd_estimated{i}, no_traces, 1);
end



% COMPUTATION PART

% compute hypothetical information and the conditional entropy (based on formula (8))

key_entropy = key_bits;

summation = 0;
for k=key_range
    % sampled probability
    sampled_prob = 1/length(test_set{k+1});
    
    for l=(test_set{k+1})'
        
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

hypothetical_information = key_entropy + summation;

conditional_entropy = -summation;