import Config

# if File.exists?("./config/#{Mix.env()}.exs") do
#   import_config "#{Mix.env()}.exs"
# end

if File.exists?("./config/secret}.exs") do
  import_config "secret.exs"
end
