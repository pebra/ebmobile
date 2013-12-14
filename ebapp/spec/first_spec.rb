require "spec_helper"
describe 'First', :type => :feature do
  specify "add To Merkliste" do
    search_java_and_click_first_job
    click_on 'Auf die Merkliste'
    title =  find('h1').text

    click_on 'Merkliste'
    page.has_selector?('h2', text: 'Merkliste')
    page.should have_content title

    click_on 'Suche'

    # 2.Suche
    fill_in 'search', with: "Java"
    click_on 'Suchen'
    sleep 2
    click_on 'Merkliste'
    page.has_selector?('h2', text: 'Merkliste')
    page.should have_content title
  end

  specify 'Remove from Merkliste' do
    search_java_and_click_first_job
    title =  find('h1').text

    click_on 'Auf die Merkliste'
    click_on 'Von Merkliste entfernen'
    page.should have_content 'Auf die Merkliste'

    click_on 'Merkliste'
    page.has_selector?('h2', text: 'Merkliste')
    page.should_not have_content title
  end

  def search_java_and_click_first_job
    visit '/'
    page.should have_content 'Empfehlungsbund'
    fill_in 'search', with: "Java"
    click_on 'Suchen'

    sleep 2
    all('h3').count.should be > 5

    # click on first
    all('.list-group-item img').first.click
  end

end
