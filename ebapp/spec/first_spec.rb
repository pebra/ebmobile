require "spec_helper"
describe 'First', :type => :feature do
  specify do
    visit '/'
    fill_in 'search', with: "Java\n"

    binding.pry
    b = page.evaluate_script <<-CODE
    a = null
    App.Job.store.findAll('job').then(function(jobs) { return a=jobs.get('length') } )
    return a
    CODE
    binding.pry
    page.should have_content 'Empfehlungsbund'
  end

end
