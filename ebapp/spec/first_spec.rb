require "spec_helper"
describe 'First', :type => :feature do
  specify do
    visit '/'
    page.should have_content 'Empfehlungsbund'
    fill_in 'search', with: "Java"
    click_on 'Suchen'

    sleep 2
    all('h3').count.should be > 5

    # click on first
    all('.list-group-item img').first.click

    click_on 'Auf die Merkliste'
    title =  find('h1').text

    click_on 'Merkliste'
    page.has_selector?('h2', text: 'Merkliste')
    page.should have_content title

    # 2.Suche
    visit '/'
    fill_in 'search', with: "Java"
    click_on 'Suchen'
    sleep 2
    click_on 'Merkliste'
    page.has_selector?('h2', text: 'Merkliste')
    page.should have_content title
  end

end
