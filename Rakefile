require "rubygems"
require "bundler/setup"
Bundler.require :default

require "./lib/mini_d20"

desc "render PDF from HTML input"
task :render do
  MiniD20::Renderer.new("Mini D20.html").render
end
