include DreddHooks::Methods

stash = {}

before "Sessions > sessions#destroy" do |transaction|
  transaction['skip'] = true
end

after "Sessions > sessions#create" do |transaction|
  parsed_body = JSON.parse transaction['real']['body']
  stash['token'] = parsed_body['token']
end

before_each do |transaction|
  unless stash['token'].nil?
    transaction['request']['headers']['Authorization'] = stash['token']
  end
end
