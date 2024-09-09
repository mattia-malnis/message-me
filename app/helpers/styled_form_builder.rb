class StyledFormBuilder < ActionView::Helpers::FormBuilder
  INPUT_TYPES = [:text_field, :email_field, :password_field, :number_field, :date_field, :text_area]

  INPUT_TYPES.each do |input_type|
    define_method(input_type) do |method, options = {}|
      element_with_default_class(method, options) { super(method, options) }
    end
  end

  def label(method, options = {})
    default_class = "mb-2 block text-sm font-medium text-gray-700"
    element_with_default_class(method, options, default_class) { super(method, options) }
  end

  def submit(value = nil, options = {})
    default_class = "inline-flex items-center justify-center rounded-full py-2 px-4 text-sm font-semibold bg-blue-600 text-white hover:text-slate-100 hover:bg-blue-500 w-full"
    element_with_default_class(value, options, default_class) { super(value, options) }
  end

  private

  def element_with_default_class(method, options, default_class = "block w-full appearance-none rounded-md border border-gray-200 bg-gray-50 px-3 py-2 text-gray-900 placeholder-gray-400 focus:border-blue-500 focus:bg-white focus:outline-none focus:ring-blue-500 sm:text-sm")
    options[:class] = options[:class] || default_class
    yield
  end
end
