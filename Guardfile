# encoding: utf-8

guard :rspec, cmd: "bundle exec rspec" do

  watch(%r{^spec/tests/.+_spec\.rb$})

  watch(%r{^lib/hexx-entities/(.+)\.rb}) do |m|
    "spec/tests/#{ m[1] }_spec.rb"
  end

  watch("lib/hexx-entities.rb") { "spec" }
  watch("spec/spec_helper.rb")  { "spec" }

end # guard :rspec
