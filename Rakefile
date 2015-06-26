#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/extensiontask'
require 'rake/clean'
require 'rbconfig'
require 'rspec/core/rake_task'

NAME="edn_ext"
EXT_BUNDLE = "lib/edn/#{NAME}.#{RbConfig::CONFIG['DLEXT']}"

EXT_PATH               = "ext/#{NAME}"
RAGEL_PARSER_SRC       = "edn_parser.rl"
RAGEL_PARSER_SRC_PATH  = "#{EXT_PATH}/#{RAGEL_PARSER_SRC}"
GEN_CC_PARSER_SRC      = "edn_parser.cc"
GEN_CC_PARSER_SRC_PATH = "#{EXT_PATH}/#{GEN_CC_PARSER_SRC}"

Rake::ExtensionTask.new("#{NAME}") do |extension|
  extension.lib_dir = "lib/edn"
  extension.source_pattern = "*.{cc,h}"
end

task :chmod do
  File.chmod(0775, EXT_BUNDLE)
end

CLEAN.include(["*.png", "*.gem"])

task :ragel => GEN_CC_PARSER_SRC_PATH


file GEN_CC_PARSER_SRC_PATH => RAGEL_PARSER_SRC_PATH do
  cd EXT_PATH do
    sh "ragel -G2 -o #{GEN_CC_PARSER_SRC} #{RAGEL_PARSER_SRC}"
    src = File.read(GEN_CC_PARSER_SRC).gsub(/[ \t]+$/, '')
    File.open(GEN_CC_PARSER_SRC, "w") {|f| f.print src}
  end
end


task :graph, [:machine] do |t, args|
  args.with_defaults(:machine => 'EDN_value')
  TMPFILE='/tmp/ragel_edn'
  MACHINE=args[:machine]

  # assumes graphviz is installed
  sh "ragel -Vp -S #{MACHINE} -o #{TMPFILE} #{EXT_PATH}/#{RAGEL_PARSER_SRC} && dot -Tpng #{TMPFILE} -o #{MACHINE}.png"
end

task :build => [:clean, :ragel, :compile, :chmod]


RSpec::Core::RakeTask.new(:spec)

task :default => :compile

task :irb do
  sh "irb -I lib -r edn"
  sh "reset"
end
