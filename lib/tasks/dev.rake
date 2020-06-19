# frozen_string_literal: true

namespace :dev do
  desc 'Check code health'
  task check: :environment do
    [:brakeman, :rails_best_practices, :rubycritic].each { |tool| run_tool(tool) }
  end

  def run_tool(tool)
    puts title(tool)
    send(:"run_#{tool}")
    puts
  end

  def run_brakeman
    result = `bundle exec brakeman --quiet --format plain`

    puts build_result_output(result, 'No warnings found')
  end

  def run_rails_best_practices
    result = `rails_best_practices .`

    puts build_result_output(result, 'No warning found. Cool!')
  end

  def run_rubycritic
    result = `rubycritic app config lib`

    puts build_rubycritic_score(result.match(/Score: (?<score>\d+.\d+)/)[:score].to_d)
  end

  def title(tool)
    title = "Running #{tool.to_s.humanize.titleize}..."
    "#{title}#{' ' * (`tput cols`.to_i - title.length)}".colorize(:light_white).colorize(background: :blue)
  end

  def build_result_output(result, message)
    return result unless result.include?(message)

    "#{message} \u{1f60e}".colorize(:light_blue)
  end

  def build_rubycritic_score(score)
    case score
    when 95..100
      "Score: #{score} \u{1f60e}".colorize(:light_blue)
    when 85...95
      "Score: #{score} \u{1f914}".colorize(:light_yellow)
    else
      "Score: #{score} \u{1f922}".colorize(:light_red)
    end
  end
end
