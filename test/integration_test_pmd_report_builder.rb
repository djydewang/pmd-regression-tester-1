# frozen_string_literal: true

require 'test_helper'

# Integration test for PmdTester::PmdReportBuilder
class IntegrationTestPmdReportBuilder < Test::Unit::TestCase
  include PmdTester
  def setup
    `rake clean`
  end

  def test_build
    Process.fork do
      logger.level = Logger::INFO
      projects = ProjectsParser.new.parse('test/resources/project-test.xml')
      builder = PmdReportBuilder.new('config/all-java.xml', projects,
                                     'target/repositories/pmd', 'pmd_releases/6.7.0')
      builder.build
    end
    Process.wait

    assert_equal(0, $CHILD_STATUS.exitstatus)
  end
end
