require 'shellwords'
require 'fileutils'
require 'optparse'

require 'dry/cli'

module FlutterAssistant
  module CLI
    module Commands
      def self.run(line, level: "info")
        Logger.log("Running `#{line}`", level:)

        `#{line}`
      end

      module Logger
        class << self
          def log(line, level:)
            color = 
              case level
              when "info" then :white
              when "error" then :red
              when "debug" then :bright_cyan
              else
                ""
              end

            puts "[#{level}] #{colorize(line, color)}"
          end

          def colorize(line, color)
            ansi_code = 
              case color
              when :black then "\e[30m"
              when :red then "\e[31m"
              when :blue then "\e[34m"
              when :white then "\e[37m"
              when :bright_cyan then "\e[1m\e[36m"
              else
                ""
              end

            return line if ansi_code.empty?

            reset_character = "\e[0m"
            ansi_code + line + reset_character
          end
        end
      end

      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*)
          puts "0.1.0"
        end
      end

      module Android
        class GenerateKeystore < Dry::CLI::Command
          desc "Generate keystore file"

          argument :project_name, required: true, desc: "Current project's name"

          example ["FooBar", "foo_bar", "fooBar"]

          def call(project_name:, **)
            original_path = File.expand_path(".").to_s
            target_path = File.expand_path("./android/app").to_s
            FileUtils.cd(target_path)
            downscored_name = project_name.downcase
            kebabcased_name = downscored_name.gsub('_', '-')
            command = Shellwords.join(['keytool', '-genkey', '-v', '-keystore', "#{kebabcased_name}-release.jks", '-alias', downscored_name, '-keyalg', 'RSA', '-keysize', '2048', '-validity', '10000'])
            `#{command}`

            properties = <<~KEYSTORE
              storePassword=
              keyPassword=
              keyAlias=#{downscored_name}
              storeFile=#{kebabcased_name}-release.jks
            KEYSTORE

            File.write("#{target_path}/key.properties", properties)
            FileUtils.cd(target_path)
          end
        end
      end

      register "version", Version, aliases: ["v", "-v", "--version"]

      register "android" do |prefix|
        prefix.register "generate_keystore", Android::GenerateKeystore
      end
    end
  end
end

Dry::CLI.new(FlutterAssistant::CLI::Commands).call
