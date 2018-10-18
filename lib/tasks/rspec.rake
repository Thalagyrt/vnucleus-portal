if defined? RSpec
  namespace :spec do
    desc 'Run all specs in spec directory (exluding features)'
    RSpec::Core::RakeTask.new(:nofeatures) do |task|
      file_list = FileList['spec/**/*_spec.rb']

      %w(features).each do |exclude|
        file_list = file_list.exclude("spec/#{exclude}/**/*_spec.rb")
      end

      task.pattern = file_list
    end
  end
end