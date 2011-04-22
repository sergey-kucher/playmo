module PlaymoHelper
  attr_accessor :page_title

  def flash_messages
    return unless flash.any?

    items = []
    flash.each do |name, msg|
      items << content_tag(:li, msg, :id => "flash-#{name}")
    end

    content_tag :div, :id => 'flash-messages' do
      content_tag :ul, raw(items.join)
    end
  end

  # Set page title. Use this method in your views
  def title(page_title)
    @page_title = page_title
  end

  # This prints page title. Call this helper
  # inside title tag of your layout
  def page_title(default_title = '')
    @page_title || default_title
  end

  # Print heading (h1 by default) and set page title
  # at the same time. Use this method in your views
  def heading_with_title(heading, tag=:h1)
    title(heading)
    content_tag tag, heading
  end

  def admin_area(&block)
    if user_signed_in?
      content = with_output_buffer(&block)
      content_tag(:div, content, :class => 'admin')
    end
  end

  def link_to_section(name, options = {}, html_options = {}, &block)
    url_string = url_for(options)

    if "/#{request.path.split('/')[1]}" == url_string
      html_options[:class] = "#{html_options[:class]} current"
    end

    link_to(name, options, html_options, &block)
  end

  def page_id
    name = 'page-' + request.path_parameters[:controller] + '-' + request.path_parameters[:action]
    name.gsub!(/_+/, '-')
    name
  end

  def link_to_website(url, html_options = {})
    return nil if url.blank?
    
    url = "http://#{url}" unless url =~ /^(ht|f)tps?:\/\//i
    html_options[:href] = url
    content_tag(:a, url, html_options)
  end

  # Create a named haml tag to wrap IE conditional around a block
  # http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither
  def ie_tag(name=:body, attrs={}, &block)
    attrs.symbolize_keys!
    result  = "<!--[if lt IE 7 ]> #{ tag(name, add_class('ie6', attrs), true) } <![endif]-->\n".html_safe
    result += "<!--[if IE 7 ]>    #{ tag(name, add_class('ie7', attrs), true) } <![endif]-->\n".html_safe
    result += "<!--[if IE 8 ]>    #{ tag(name, add_class('ie8', attrs), true) } <![endif]-->\n".html_safe
    result += "<!--[if IE 9 ]>    #{ tag(name, add_class('ie9', attrs), true) } <![endif]-->\n".html_safe
    result += "<!--[if (gte IE 9)|!(IE)]><!-->".html_safe
    
    result += content_tag name, attrs do
      "<!--<![endif]-->\n".html_safe + with_output_buffer(&block)
    end
    
    result
  end

  def ie_html(attrs={}, &block)
    ie_tag(:html, attrs, &block)
  end

  def ie_body(attrs={}, &block)
    ie_tag(:body, attrs, &block)
  end

  def google_account_id
    ENV['GOOGLE_ACCOUNT_ID'] || google_config(:google_account_id)
  end

  def google_api_key
    ENV['GOOGLE_API_KEY'] || google_config(:google_api_key)
  end

private

  def add_class(name, attrs)
    classes = attrs[:class] || ''
    classes.strip!
    classes = ' ' + classes if !classes.blank?
    classes = name + classes
    attrs.merge(:class => classes)
  end

  def google_config(key)
    configs = YAML.load_file(File.join(Rails.root, 'config', 'google.yml'))[Rails.env.to_sym] rescue {}
    configs[key]
  end
end
