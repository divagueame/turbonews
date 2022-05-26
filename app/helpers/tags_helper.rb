module TagsHelper

  def show_active_state(tag)
    content = ''
    if controller_name == 'tags' && action_name == 'show'
        html = "
        <strong>Active:</strong>
        #{tag.active} <p class='font-bold mr-3 text-md'>"
      content << html
    end
    content.html_safe
  end
  
end
