module CalendarHelper

  def calendar_include_tag
    content = stylesheet_link_tag "simple_calendar/calendar"
    content += javascript_include_tag "simple_calendar/calendar"
    return content
  end

  def initialize_render_calendar
    content = render(:partial => 'common/popup_calendar')
    content += javascript_tag "Calendar.initCalendar();"
    return content
  end

  def calendar_input_tag(object_name, method, options = {})
    input_id = options[:id] || "#{object_name}_#{method}"

    options.merge!({:autocomplete => :off, :id => input_id})
    content = content_tag(:div, :class => "calendar", :onclick => "Calendar.popup(this, #{input_id})")  do
      if (f = options[:form])
        options.delete(:form)
        inner_content = f.text_field method.to_sym, options
      else
        inner_content = text_field object_name, method, options
      end
      inner_content += image_tag('simple_calendar/calendar.gif')
      inner_content
    end
    content += content_tag(:div, "", :style => "float: left")

    return content
  end
end