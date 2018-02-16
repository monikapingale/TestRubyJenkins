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

module TestRail

  class TestSection

    attr_reader :id, :name

    def initialize(id:, name:, test_suite:)
      raise(ArgumentError, 'section id nil') if id.nil?
      raise(ArgumentError, 'section name nil') if name.nil?
      @id = id
      @name = name
      @test_suite = test_suite
    end

    def get_or_create_test_case(name)
      @test_suite.get_or_create_test_case(section_id: @id, name: name)
    end

  end

end