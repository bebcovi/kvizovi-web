module DeleteResourceRoute
  def resources(*args, &block)
    super(*args) do
      yield if block_given?
      member do
        get "delete"
        delete "delete", action: :destroy
      end
    end
  end

  def resource(*args, &block)
    super(*args) do
      yield if block_given?
      get "delete"
      delete "delete", action: :destroy
    end
  end
end

ActionDispatch::Routing::Mapper.send(:include, DeleteResourceRoute)
