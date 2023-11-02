require 'shellwords'
require 'fileutils'
require 'optparse'

require 'dry/cli'

module FlutterAssistant
  module CLI
    module Commands
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
