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

  def jake_and_chris_unscientific_risk_score(poverty_rate, miles_to_healthy_source, miles_to_unhealthy_source)
    # (poverty_rate * 100) + (((miles_to_healthy_source - miles_to_unhealthy_source) / [miles_to_healthy_source, miles_to_unhealthy_source].max) * 50)
    puts "poverty_rate: #{poverty_rate * 100}"
    puts "distance difference: #{((miles_to_healthy_source - miles_to_unhealthy_source)) * 50}"
    (poverty_rate * 100) + (((miles_to_healthy_source - miles_to_unhealthy_source)) * 50)
  end

  def weighted_risk_score(poverty_rate, miles_to_healthy_source, miles_to_unhealthy_source)
    distance_max = 5

    pr_weight = 0.50
    h_weight = 0.35
    u_weight = 0.15

    healthy = miles_to_healthy_source > distance_max ? distance_max : miles_to_healthy_source
    unhealthy = miles_to_unhealthy_source > distance_max ? distance_max : miles_to_unhealthy_source

    puts "poverty_rate contribution: #{poverty_rate * pr_weight}"
    puts "healthy contribution: #{miles_to_healthy_source * h_weight}"
    puts "unhealthy contribution: #{miles_to_unhealthy_source * u_weight}"

    ((poverty_rate * pr_weight) + (miles_to_healthy_source * h_weight) + (miles_to_unhealthy_source * u_weight)) * 100
  end

  def game_theory_risk_score(individuals_below_poverty_line, miles_to_healthy_source, miles_to_unhealthy_source)
    if miles_to_healthy_source > 3 || miles_to_healthy_source > miles_to_unhealthy_source * 1.3
      individuals_below_poverty_line
    else
      0
    end
  end
end