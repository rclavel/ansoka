# frozen_string_literal: true
require 'test_helper'

class MoulinetteTest < ActiveSupport::TestCase
  include Utils::CustomTestUtils

  CandidateGems.list.each do |candidate_name|
    test candidate_name do
      run_test_for candidate_name
    end
  end

  private

  def run_test_for(candidate_name)
    @candidate_name = candidate_name.camelize
    @candidate_class = "#{candidate_name.camelize}::#{TESTED_CLASS_NAME}".constantize

    log_step 'Start tests'
    run_all_tests
    log_step 'Ok ! Yeah !'
  end

  def run_test(test_method)
    log_step test_method.to_s.upcase

    send(test_method)
    log_query_count

    log_step test_method.to_s.upcase, 'OK'
  end

  def test_wrapper
    output = nil

    @last_query_analysis = analyze_queries do
      output = yield
    end

    output
  end

  def analyze_queries(&block)
    count = 0
    queries = []

    counter_f = lambda do |name, started, finished, unique_id, payload|
      return if payload[:name].in? ['CACHE', 'SCHEMA', nil]

      queries << payload[:sql]
      count += 1
    end
    ActiveSupport::Notifications.subscribed(counter_f, "sql.active_record", &block)

    { count: count, queries: queries }
  end

  def log_step(*strings)
    strings = strings.map { |string| "[#{string}]" }.join
    puts "[#{@candidate_name}]#{strings}"
  end

  def log_query_count
    puts "Queries: #{@last_query_analysis[:count]}"
  end

  def log_queries
    log_step 'QUERIES'
    @last_query_analysis[:queries].each do |query|
      puts query
    end
    log_step 'QUERIES', 'END'
  end
end
