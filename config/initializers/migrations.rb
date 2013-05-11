class ActiveRecord::Migration
  def handle_single_table_inheritance(*ar_classes, &block)
    ar_classes.each do |ar_class|
      ar_class.update_all("type = '#{self.class.name}::' || type")
    end

    yield

    ar_classes.each do |ar_class|
      ar_class.update_all("type = substring(type from #{self.class.name.length + 3})")
    end
  end
end
