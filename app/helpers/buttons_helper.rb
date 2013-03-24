module ButtonsHelper
  def back_button(string, path, options = {})
    link_to string.prepend_icon("arrow-left"), path, {class: "go_back"}.merge(options)
  end

  def cancel_button(string, path, options = {})
    link_to string, path, {class: "btn cancel"}.merge(options)
  end

  def logout_button(string, path, options = {})
    link_to string.prepend_icon("exit"), path, options
  end

  def change_password_button(string, path, options = {})
    link_to string.prepend_icon("locked"), path, {class: "btn"}.merge(options)
  end

  def delete_profile_button(string, path, options = {})
    link_to string.prepend_icon("remove"), path, {class: "delete_profile"}.merge(options)
  end

  def edit_button(string, path, options = {})
    link_to string.prepend_icon("pencil"), path, {class: "edit_item btn"}.merge(options)
  end

  def delete_button(string, path, options = {})
    link_to string.prepend_icon("remove"), path, {class: "delete_item btn btn-danger"}.merge(options)
  end

  def add_button(string, path, options = {})
    link_to string.prepend_icon("plus"), path, {class: "add_item btn btn-primary"}.merge(options)
  end

  def copy_button(string, path, options = {})
    link_to string.prepend_icon("copy"), path, options
  end

  def download_button(string, path, options = {})
    link_to string.prepend_icon("file-download"), path, options
  end

  def view_button(string, path, options = {})
    link_to string.prepend_icon("file"), path, options
  end

  def add_file_button(string, path, options = {})
    link_to string.prepend_icon("file-add"), path, options
  end

  def remove_file_button(string, path, options = {})
    link_to string.prepend_icon("file-remove"), path, options
  end

  def remove_button(options = {})
    content_tag :button, "×", type: "button", class: "close", data: {dismiss: options[:dismiss]}
  end

  def settings_button(string, path, options = {})
    link_to string.prepend_icon("cog"), path, options
  end

  def buttons(form_builder)
    content_tag :div, class: "btn-toolbar" do
      yield ButtonBuilder.new(form_builder, self)
    end
  end

  class ButtonBuilder
    def initialize(form_builder, template)
      @form_builder = form_builder
      @template = template
    end

    def cancel_button(*args)
      options = args.extract_options!.dup
      options.reverse_merge!(class: "btn cancel")
      args << options
      @template.link_to *args
    end

    def action_button(*args)
      options = args.extract_options!.dup
      options.reverse_merge!(class: "action btn btn-primary")
      args << options
      @template.link_to *args
    end

    def submit_button(*args)
      options = args.extract_options!.dup
      options.reverse_merge!(class: "btn btn-primary", data: {"disable-with" => "Učitavanje..."})
      args << options
      @form_builder.button :button, *args
    end
  end
end
