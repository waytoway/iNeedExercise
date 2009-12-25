# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def error_messages_for(*params)   
    #add by glchengang   
    key_hash = {}   
    if params.first.is_a?(Hash)   
      key_hash =  params.first   
      params.delete_at(0)   
    end   
    #add end   
  
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}   
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact   
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }   
    unless count.zero?   
      html = {}   
      [:id, :class].each do |key|   
        if options.include?(key)   
          value = options[key]   
          html[key] = value unless value.blank?   
        else  
          html[key] = 'errorExplanation'  
        end   
      end   
      # change by glchengang   
      header_message = "有#{count}个错误"  
#       header_message = "#{pluralize(count, 'error')} prohibited this #{(options[:object_name] || params.first).to_s.gsub('_', ' ')} from being saved"  
         
      #add by glchengang   
      error_messages = objects.map do |object|   
        temp = []   
        object.errors.each do |attr, msg|   
          temp << content_tag(:li, (key_hash[attr] || attr) + msg) 
          puts "ttttttttttttttttt"
          puts msg
        end   
        temp   
      end   
      #add end   
  
#        error_messages = objects.map {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }   
      content_tag(:div,   
        content_tag(options[:header_tag] || :h2, header_message) <<   
#           content_tag(:p, 'There were problems with the following fields:') <<   
          content_tag(:ul, error_messages),   
        html   
      )   
    else  
      ''  
    end   
  end  

end
