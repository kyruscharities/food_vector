# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  config.wrappers :bootstrap, :tag => 'div', :class => 'form-group', :error_class => 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label'
    b.use :input
    b.use :error, :wrap_with => {:tag => 'span', :class => 'help-block'}
    b.use :hint, :wrap_with => {:tag => 'p', :class => 'help-block'}
  end

  config.wrappers :checkbox, :tag => 'div', :class => 'checkbox', :error_class => 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label'
    b.use :input
    b.use :error, :wrap_with => {:tag => 'span', :class => 'help-block'}
    b.use :hint, :wrap_with => {:tag => 'p', :class => 'help-block'}
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap

  config.button_class = 'btn btn-primary'
end

%w(StringInput RangeInput CollectionSelectInput GroupedCollectionSelectInput PasswordInput TextInput NumericInput).each do |class_name|
  old_class = "SimpleForm::Inputs::#{class_name}".constantize
  new_class = Class.new(old_class) do
    def input_html_classes
      super.push('form-control')
    end
  end
  Object.const_set(class_name, new_class)
end