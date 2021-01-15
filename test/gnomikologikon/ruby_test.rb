# frozen_string_literal: true

require_relative "../test_helper"

module Gnomika
  class RubyTest < Minitest::Test
    def test_version_number_exists
      refute_nil ::Gnomika::Ruby::VERSION
    end
  end
end
