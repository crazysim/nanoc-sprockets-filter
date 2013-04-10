require 'nanoc'

module Nanoc
  module Filters
    class Sprockets < Nanoc::Filter
      VERSION = '0.0.2'

      type :text

      def self.environment
        # Save STDERR
        nanoc_stderr = $stderr
        $stderr = STDERR

        environment = ::Sprockets::Environment.new(File.expand_path('.')) do |env|
          # Paths where a nanoc project might have its assets for sprockets
          paths =  %w(content/assets/ lib/assets/ assets/ vendor/assets/)
          # Paths underneath a sprocketized asset folder in nanoc
          assets = %w(javascripts stylesheets images fonts)

          paths.product(assets).map do |asset, path|
            env.append_path(asset + path)
          end
        end

        # Restore STDERR
        $stderr = nanoc_stderr

        environment
      end

      def environment
        @environment ||= self.class.environment
      end

      def run(content, params = {})
        filename = File.basename(@item[:filename])

        environment.css_compressor = params[:css_compressor]
        environment.js_compressor  = params[:js_compressor]

        if asset == environment[filename]
          asset.to_s
        else
          raise "error locating #{filename} / #{@item[:filename]}"
        end
      end

    end
  end
end

