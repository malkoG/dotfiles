require 'shellwords'
require 'fileutils'
require 'optparse'

def generate_keystore_file(project_name)
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

options = {}
OptionParser.new do |opt|
  opt.on('-p', '--project_name PROJECT_NAME', 'project_name') { |o| options[:project_name] = o }
end.parse!

generate_keystore_file(options[:project_name])
