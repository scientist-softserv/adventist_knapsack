##
# The purpose of this script is to quickly assess which specs should:
#
# - be removed (e.g. duplicate in Knapsack and Hyku)
# - be reviewed (e.g. differences between Knapsack and Hyku)
# - kept outright (e.g. in Knapsack but not Hyku)
require 'fileutils'

in_knapsack_but_not_hyku = []
duplicates = []
changed_in_knapsack = []

Dir.glob("spec/**/*.rb").each do |path|
  hyku_path = File.join("hyrax-webapp", path)
  if File.exist?(hyku_path)
    results = `diff #{path} #{hyku_path}`.strip
    if results.empty?
      duplicates << path
    else
      changed_in_knapsack << path
    end
  else
    in_knapsack_but_not_hyku << path
  end
end

puts "--------------------------------------------------------"
puts "Files in Knapsack that are exact duplicates of Hyku file"
puts "They are prefixed with a `-'"
puts "--------------------------------------------------------"
duplicates.each do |path|
  puts "- #{path}"
  FileUtils.rm_f(path) if ENV['RM_DUPS']
end

puts ""

puts "----------------------------------"
puts "Files are in Knapsack but not Hyku"
puts "They are prefixed with a `+'"
puts "----------------------------------"
in_knapsack_but_not_hyku.each do |path|
  puts "+ #{path}"
end

puts ""

puts "--------------------------------------------"
puts "Files that are changed in Knapsack from Hyku"
puts "They are prefixed with a `Δ'"
puts "--------------------------------------------"
changed_in_knapsack.each do |path|
  puts "Δ #{path}"
end
