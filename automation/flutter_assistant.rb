require 'fileutils'
require 'yaml'
require 'shellwords'
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

      module PubspecUtils
        class << self
          def pubspec_path
            "#{File.expand_path('.')}/pubspec.yaml"
          end

          def load_pubspec_file
            YAML.load(File.read(pubspec_path))
          end

          def increment_build_number(pubspec)
            version = pubspec["version"] || "1.0.0+1"
            
            version_name, build_number = version.split('+')
            next_build_number = build_number.to_i + 1

            updated_version = "#{version_name}+#{next_build_number}"

            pubspec.merge!({"version" => updated_version})
            pubspec
          end

          def increment_version!(pubspec)
            result = increment_build_number(pubspec)
            File.write(pubspec_path, YAML.dump(result))
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

      class ApplyLogo < Dry::CLI::Command
        desc "apply logo automatically based on `flutter_launcher_icons.yaml`"

        def call(*)
          Logger.log('Applying logo', level: 'debug')
          Commands.run('flutter pub run flutter_launcher_icons')
        end
      end

      class ExaminePubspec < Dry::CLI::Command
        desc "examine pubspec.yaml file"

        def call(*)
          pp PubspecUtils.load_pubspec_file

          socket_address = ENV['NVIM_SOCKET_REMOTE_ADDRESS'] || ""
          unless socket_address.empty?
            Commands.run("nvr --servername #{socket_address} --remote-tab pubspec.yaml")
          end
        end
      end

      module Android
        class GenerateKeystore < Dry::CLI::Command
          desc "Generate keystore file"

          argument :project_name, required: true, desc: "Current project's name"

          example [
            "FooBar   # supports PascalCase", 
            "foo_bar  # supports snake_case", 
            "fooBar   # supports camelCase"
          ]

          def call(project_name:, **)
            original_path = File.expand_path(".").to_s
            target_path = File.expand_path("./android/app").to_s
            FileUtils.cd(target_path)
            Logger.log("Moved to #{target_path}", level: "debug")

            downscored_name = project_name.downcase
            kebabcased_name = downscored_name.gsub('_', '-')
            command = Shellwords.join(['keytool', '-genkey', '-v', '-keystore', "#{kebabcased_name}-release.jks", '-alias', downscored_name, '-keyalg', 'RSA', '-keysize', '2048', '-validity', '10000'])

            Commands.run(command)

            properties = <<~KEYSTORE
              storePassword=
              keyPassword=
              keyAlias=#{downscored_name}
              storeFile=#{kebabcased_name}-release.jks
            KEYSTORE

            File.write("#{target_path}/key.properties", properties)
            Logger.log("Generating key.properties", level: "debug")

            FileUtils.cd(target_path)
          end
        end

        class Release < Dry::CLI::Command
          desc "Build flutter app in release mode"

          option :build_type, required: true, default: "apk"
          example [ 
            "--build_type=apk # blah",
            "--build_type=aab # blah"
          ]

          def call(build_type:, **)
            pubspec = PubspecUtils.load_pubspec_file
            Logger.log("Upgrading build number. (current version is #{pubspec['version']})", level: "debug")
            PubspecUtils.increment_version!(pubspec)

            pubspec = PubspecUtils.load_pubspec_file
            Logger.log("Upgraded build number. (current version is #{pubspec['version']})", level: "debug")

            Commands.run('flutter build apk --release')
          end
        end
      end

      register "apply_logo", ApplyLogo
      register "version", Version, aliases: ["v", "-v", "--version"]
      register "examine_pubspec", ExaminePubspec

      register "android" do |prefix|
        prefix.register "generate_keystore", Android::GenerateKeystore
        prefix.register "release",  Android::Release
      end
    end
  end
end

Dry::CLI.new(FlutterAssistant::CLI::Commands).call
