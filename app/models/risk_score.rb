class RiskScore

  def coerce(score)
    if score > 100
      return 100
    end
    if score < 0
      return 0
    end
    return score.round
  end

  def usda_approximate_risk_score(poverty_rate, miles_to_healthy_source, miles_to_unhealthy_source)
    if poverty_rate > 0.20 and miles_to_healthy_source > 1
      return 100
    else
      return 0
    end
  end

  def simple_risk_score(poverty_rate, miles_to_healthy_source, miles_to_unhealthy_source)
    # WolframAlpha: Plot[Min[333*p+33.4*d, 100], {p, 0,0.5}, {d, 0, 3}]
    score = 333 * poverty_rate + 33.4 * miles_to_healthy_source
    return coerce(score)
  end

end