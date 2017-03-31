# frozen_string_literal: true
class AnsokaGenerator < Rails::Generators::Base
  CANDIDATE_PROJECTS_ROOT_PATH = './tmp/candidates'
  CANDIDATES_LIST = './candidates.txt'

  argument :candidate_name, type: :string
  argument :candidate_project_path, type: :string

  def start
    candidate_name_underscored = candidate_name.underscore

    candidate_projects_root_path = relative_to_original_destination_root(CANDIDATE_PROJECTS_ROOT_PATH)
    empty_directory candidate_projects_root_path

    candidate_gem_path = File.join(candidate_projects_root_path, candidate_name_underscored)
    candidates_list_path = relative_to_original_destination_root(CANDIDATES_LIST)

    gsub_file candidates_list_path, /^#{candidate_name_underscored}$/, ''
    remove_file candidate_gem_path

    inside candidate_projects_root_path do
      run "bundle gem --no-exe --no-coc --no-mit --test=none #{candidate_name_underscored}"
    end

    gemspec_path = File.join(candidate_gem_path, "#{candidate_name_underscored}.gemspec")
    gsub_file gemspec_path, "  spec.add_development_dependency \"none\", \"~> \"\n", ''
    gsub_file gemspec_path, /(spec.(summary|description) += ).*/, "\\1\"#{candidate_name_underscored}\""
    gsub_file gemspec_path, /(spec.homepage += ).*/, '\1"https://www.doctolib.fr"'

    inside candidate_gem_path do
      run 'bundle install'
      run 'bundle exec rake build'
    end

    candidate_project_full_path = relative_to_original_destination_root(candidate_project_path)
    codebase_path = File.join(candidate_gem_path, 'lib', 'codebase')

    remove_file codebase_path
    FileUtils.cp_r candidate_project_full_path, codebase_path, verbose: true

    append_to_file candidates_list_path, "#{candidate_name_underscored}\n"
  end
end
