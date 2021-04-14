function [e_val, e_vec, sv, soi] = preAllocate(n, k, m_ovr)

    e_val.raw = zeros(ceil((n-m_ovr)/m_ovr),k);
    e_val.weak = zeros(ceil((n-m_ovr)/m_ovr),k);
    e_val.strong = zeros(ceil((n-m_ovr)/m_ovr),k);

    e_vec.raw = zeros(ceil((n-m_ovr)/m_ovr),k,k);
    e_vec.weak = zeros(ceil((n-m_ovr)/m_ovr),k,k);
    e_vec.strong = zeros(ceil((n-m_ovr)/m_ovr),k,k);

    sv.raw = zeros(ceil((n-m_ovr)/m_ovr),k);
    sv.weak = zeros(ceil((n-m_ovr)/m_ovr),k);
    sv.strong = zeros(ceil((n-m_ovr)/m_ovr),k);

    soi.lse = zeros(n,1);
    soi.raw = zeros(n,1);
    soi.weak = zeros(n,1);
    soi.strong = zeros(n,1);
    
end
