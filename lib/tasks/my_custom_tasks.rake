desc "Greet a person"
task :howdy do
  puts "Howdy!"
end

desc "Farewell to a person"
task :bye do
  puts "Goodbye!"
end

desc "Introduce"
task :intro => :environment do
  puts "My name is #{User.first.name}"
end
