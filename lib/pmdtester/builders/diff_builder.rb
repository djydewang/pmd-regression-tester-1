# frozen_string_literal: true

require 'nokogiri'

module PmdTester
  # Building difference between two pmd xml files
  class DiffBuilder
    # The schema of pmd xml report refers to
    # http://pmd.sourceforge.net/report_2_0_0.xsd
    def build(base_report_filename, patch_report_filename, base_info, patch_info, filter_set = nil)
      report_diffs = ReportDiff.new
      base_details, patch_details = report_diffs.calculate_details(base_info, patch_info)
      base_violations, base_errors = parse_pmd_report(base_report_filename, 'base',
                                                      base_details.working_dir, filter_set)
      patch_violations, patch_errors = parse_pmd_report(patch_report_filename, 'patch',
                                                        patch_details.working_dir)
      report_diffs.calculate_violations(base_violations, patch_violations)
      report_diffs.calculate_errors(base_errors, patch_errors)

      report_diffs
    end

    def parse_pmd_report(report_filename, branch, working_dir, filter_set = nil)
      doc = PmdReportDocument.new(branch, working_dir, filter_set)
      parser = Nokogiri::XML::SAX::Parser.new(doc)
      parser.parse_file(report_filename) unless report_filename.nil?
      [doc.violations, doc.errors]
    end
  end
end
