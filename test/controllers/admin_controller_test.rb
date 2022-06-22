require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    get admin_url
  end

  test "should get index" do
    assert_response :success
    
    assert_select "h1", text: "Admin Panel"
  end
  
  test 'be see sources' do
    assert_select ".source-card", 2
  end

  test 'be able to scan one sources' do
    
  end

  test 'should able to scan all sources' do
    
  end

  test 'should see todays scraped articles' do
    
  end
end
