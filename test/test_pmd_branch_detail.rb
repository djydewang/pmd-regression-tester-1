# frozen_string_literal: true

require 'test_helper'

# Unit test class for PmdTester::PmdBranchDetail
class TestPmdBranchDetail < Test::Unit::TestCase
  def test_save_and_load
    details = PmdTester::PmdBranchDetail.new('test_branch')
    details.branch_last_message = 'test message'
    details.branch_last_sha = 'test sha'
    details.execution_time = 'test time'

    dir = 'target/reports/test_branch'
    FileUtils.mkdir(dir) unless File.directory?(dir)
    details.save
    hash = details.load

    assert_equal('test_branch', hash['branch_name'])
    assert_equal('test message', hash['branch_last_message'])
    assert_equal('test sha', hash['branch_last_sha'])
    assert_equal('test time', hash['execution_time'])
  end

  def test_get_path
    details = PmdTester::PmdBranchDetail.new('test/branch')
    expected_path = 'target/reports/test_branch/branch_info.json'
    assert_equal(expected_path, details.branch_details_path)
    expected_path = 'target/reports/test_branch/config.xml'
    assert_equal(expected_path, details.target_branch_config_path)
  end
end
