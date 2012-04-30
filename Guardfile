require 'guard/guard'
require 'shellwords'

module ::Guard
  class Inline < ::Guard::Guard
    def run_all
      system(['mocha tests/**/*.js'])
    end

    def run_on_change(paths)
      paths.each do |path|
        system(['mocha', path].shelljoin)
      end
    end
  end
end

guard 'inline' do
  watch(%r{tests/(.*)\.js$})
  watch(%r{src/(.+?)\.js$})  { |m| "tests/#{m[1]}.js" }
end
