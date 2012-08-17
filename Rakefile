#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Lektire::Application.load_tasks

class Rake::Task
  def abandon
    @actions.clear
  end
end

namespace :db do
  Rake::Task[:reset].abandon

  desc "Drops, creates, migrates and seeds the database"
  task reset: [:drop, :create, :migrate, :seed] do
  end
end
