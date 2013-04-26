module ButtonsHelper
  def submit_button(string, options = {})
    button_tag string, class: "btn btn-primary", data: {"disable-with" => "Učitavanje..."}
  end

  def primary_button(string, path, options = {})
    link_to string, path, {class: "btn btn-primary"}.merge(options)
  end

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
    link_to string.prepend_icon("lock"), path, {class: "btn"}.merge(options)
  end

  def delete_profile_button(string, path, options = {})
    link_to string.prepend_icon("remove"), path, {class: "delete_profile"}.merge(options)
  end

  def edit_button(string, path, options = {})
    link_to string.prepend_icon("pencil-2"), path, {class: "edit_item btn"}.merge(options)
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
    link_to string.prepend_icon("file-minus"), path, options
  end

  def remove_button(options = {})
    content_tag :button, "×", type: "button", class: "close", data: {dismiss: options[:dismiss]}
  end

  def settings_button(string, path, options = {})
    link_to string.prepend_icon("cog"), path, options
  end

  def next_button(string, path, options = {})
    link_to string.append_icon("arrow-right"), path, {class: "action btn btn-primary"}.merge(options)
  end

  def action_button(string, path, options = {})
    link_to string, path, {class: "action btn"}.merge(options)
  end

  def buttons(options = {})
    options[:class] = "btn-toolbar #{options[:class]}"
    content_tag :div, options do
      yield
    end
  end
end
