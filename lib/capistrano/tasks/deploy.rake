Capistrano::DSL.stages.each do |stage|
  after stage, 'rbenv:setup'
end
