require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    get admin_url
    @source = sources(:el_pais)
  end

  test "should get index" do
    assert_response :success
    
    assert_select "h1", text: "Admin Panel"
  end
  
  test 'be see sources' do
    assert_select ".source-card", 4
  end
  
  test 'should able to scan all sources' do
    assert_select 'a', text: 'Get articles for all sources'
  end
  
  test 'should see todays scraped articles' do
    
  end
end
