module AutoCompleteFormHelper
  [:form_for, :fields_for, :form_remote_for, :remote_form_for].each do |meth|
    src = <<-end_src
      def auto_complete_#{meth}(object_name, *args, &proc)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options.update(:builder => AutoCompleteFormBuilder)
        #{meth}(object_name, *(args << options), &proc)
      end
    end_src
    module_eval src, __FILE__, __LINE__
  end
end

class AutoCompleteFormBuilder < ActionView::Helpers::FormBuilder
  def text_field_with_auto_complete(object, method, tag_options = {}, completion_options = {})
    unique_object_name = "#{object}_#{Object.new.object_id.abs}"
    completion_options_for_original_name = { :url => { :action => "auto_complete_for_#{object}_#{method}" },
                                            :param_name => "#{object}[#{method}]"
                                          }.update(completion_options)
    @template.auto_complete_field_with_style_and_script(unique_object_name,
                                                        method,
                                                        tag_options,
                                                        completion_options_for_original_name
                                                       ) do
      text_field(method, { :id => "#{unique_object_name}_#{method}" }.update(tag_options))
    end
  end

end