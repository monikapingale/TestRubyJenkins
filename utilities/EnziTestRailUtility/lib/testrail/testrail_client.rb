# Copyright 2016 Findly Inc. NZ
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'testrail/test_suite'

module TestRail

  class TestRailClient

    def initialize(testrail_http_client)
      @testrail_http_client = testrail_http_client
    end

    def get_suite(project_id:, suite_id:)
      TestSuite.new(
        project_id: project_id,
        suite_id: suite_id,
        testrail_client: self)
    end

    def start_test_run(project_id:, suite_id:)
      @testrail_http_client.send_post("add_run/#{project_id}",
                                      suite_id: suite_id)
    end

    def close_test_run(run_id)
      @testrail_http_client.send_post("close_run/#{run_id}", {})
    end

    def create_test_case(section_id:, name:)
      @testrail_http_client.send_post("add_case/#{section_id}",
                                      title: name)
    end

    def create_section(project_id:, suite_id:, section_name:)
      @testrail_http_client.send_post("add_section/#{project_id}",
                                      suite_id: suite_id,
                                      name: section_name)
    end

    def get_sections(project_id:, suite_id:)
      @testrail_http_client.send_get("get_sections/#{project_id}\&suite_id=#{suite_id}")
    end

    def get_test_cases(project_id:, suite_id:)
      @testrail_http_client.send_get("get_cases/#{project_id}&suite_id=#{suite_id}")
    end

    def submit_test_result(run_id:, test_case_id:, status_id:, comment: nil)
      @testrail_http_client.send_post("add_result_for_case/#{run_id}/#{test_case_id}",
                                      status_id: status_id,
                                      comment: comment)
    end

    def submit_test_results(run_id:, results:)
      @testrail_http_client.send_post("add_results_for_cases/#{run_id}", { results: results })
    end

  end

end
