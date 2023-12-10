# frozen_string_literal: true

require_relative 'bungee_gum/version'
require_relative 'bungee_gum/ruby_build'

module BungeeGum
  class Error < StandardError; end

  def build_ruby
    BungeeGum::RubyBuild.new.run
  end
end
