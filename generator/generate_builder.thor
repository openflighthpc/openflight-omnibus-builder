# coding: utf-8
class GenerateBuilder < Thor::Group
  include Thor::Actions

  # Define arguments and options
  argument :executable
  argument :repo_name
  argument :friendly_name

  def self.source_root
    File.dirname(__FILE__)
  end

  def boilerplate
    @boilerplate ||= File.read(template("files/BOILERPLATE.txt.tt", "#{repo_name}/BOILERPLATE.txt")).chomp
  end

  def create_root
    [
      'README.md',
      'Gemfile',
      'omnibus.rb'
    ].each do |f|
      template("files/#{f}.tt", "#{repo_name}/#{f}")
    end

    [
      'LICENSE.txt'
    ].each do |f|
      copy_file("files/#{f}", "#{repo_name}/#{f}")
    end

    copy_file("files/bundle_config", "#{repo_name}/.bundle/config")
    copy_file("files/gitignore", "#{repo_name}/.gitignore")
  end

  def create_config
    template(
      "files/config/projects/project.rb.tt",
      "#{repo_name}/config/projects/#{repo_name}.rb"
    )

    [
      'enforce-flight-runway.rb',
    ].each do |f|
      template(
        "files/config/software/#{f}.tt",
        "#{repo_name}/config/software/#{f}"
      )
    end

    template(
      "files/config/software/project.rb.tt",
      "#{repo_name}/config/software/#{repo_name}.rb"
    )
  end

  def create_opt
    template(
      "files/opt/flight/libexec/commands/executable.rb.tt",
      "#{repo_name}/opt/flight/libexec/commands/#{executable}.rb"
    )
  end

  def create_resources
    [
      'deb/control.erb',
      'rpm/spec.erb'
    ].each do |f|
      copy_file(
        File.join("files/resources/project", f),
        File.join(repo_name, "resources", repo_name, f)
      )
    end
  end

  def clean_boilerplate
    remove_file("#{repo_name}/BOILERPLATE.txt")
  end
end
