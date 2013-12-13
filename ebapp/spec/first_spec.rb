require "spec_helper"
describe 'First', :type => :feature do
  specify do
    visit '/'
    fill_in 'search', with: "Java\n"
    page.should have_content 'Empfehlungsbund'
  end

end
