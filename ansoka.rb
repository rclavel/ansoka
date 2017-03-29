require 'pry'

unless ARGV[1]
  puts "Usage: ruby #{$0} candidate_name candidate_project_path"
  exit
end

class Ansoka
  CANDIDATE_PROJECTS_ROOT_PATH = './tmp/candidates'

  def initialize(candidate_name, candidate_project_path)
    @candidate_name = underscore(candidate_name)

    candidate_projects_root_path = File.expand_path(CANDIDATE_PROJECTS_ROOT_PATH)
    FileUtils.mkdir_p candidate_projects_root_path, verbose: true

    @candidate_project_path = File.expand_path(candidate_project_path)
    @candidate_gem_path = File.join(candidate_projects_root_path, @candidate_name)
  end

  STEPS = %i(
    delete_candidate_gem_if_exists
    init_candidate_gem
    update_gemspec
    build_candidate_gem
    copy_candidate_project_to_candidate_gem
  )
  def setup
    STEPS.each do |step|
      puts "> #{step}"
      send(step)
      puts "\n"
    end
  end

  protected

  def delete_candidate_gem_if_exists
    FileUtils.rm_rf @candidate_gem_path, verbose: true
  end

  def init_candidate_gem
    Dir.chdir(CANDIDATE_PROJECTS_ROOT_PATH)
    puts `bundle gem --no-exe --no-coc --no-mit --test=none #{@candidate_name}`
  end

  def update_gemspec
    gemspec_path = File.join(@candidate_gem_path, "#{@candidate_name}.gemspec")
    gemspec_file =
      File
        .read(gemspec_path)
        .sub("  spec.add_development_dependency \"none\", \"~> \"\n", '')
        .gsub(/(spec.(summary|description) += ).*/, "\\1\"#{@candidate_name}\"")
        .sub(/(spec.homepage += ).*/, '\1"https://www.doctolib.fr"')

    File.write(gemspec_path, gemspec_file)
  end

  def build_candidate_gem
    Dir.chdir(@candidate_gem_path)
    puts `bundle install`
    puts `bundle exec rake build`
  end

  def copy_candidate_project_to_candidate_gem
    FileUtils.cp_r @candidate_project_path, File.join(@candidate_gem_path, 'lib', 'codebase'), verbose: true
  end

  private

  # Extracted from ActiveSupport
  def underscore(str)
    str
      .gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .tr("-", "_")
      .downcase
  end
end

Ansoka.new(ARGV[0], ARGV[1]).setup
