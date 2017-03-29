puts 'Prepare candidates gems ...'

class CandidateGems
  class << self
    def list
      Bundler
        .load
        .current_dependencies
        .select { |dependency| dependency.groups.include?(:candidates) }
        .map(&:name)
    end
  end
end

CandidateGems.list.each do |gem_name|
  gem_full_path = Gem.loaded_specs[gem_name].full_gem_path

  eval <<-EVAL
    module #{gem_name.camelize}
      file_count = 0

      Dir[
        "#{gem_full_path}/lib/codebase/app/**/*.rb",
        "#{gem_full_path}/lib/codebase/lib/**/*.rb"
        ].each do |path|
          file_count += 1
          eval(File.read(path))
      end

      puts "Load gem #{gem_name.camelize}: " + file_count.to_s + " files loaded"
    end
  EVAL
end

puts 'Done!'
