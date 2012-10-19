module ActionDispatch::Routing::Mapper::Resources
  class Resource
    alias standard_default_actions default_actions
    def default_actions
      standard_default_actions + [:delete]
    end

    def member_scope
      "#{path}/#{@options[:member_identifier] || ":id"}"
    end
  end

  class SingletonResource
    alias standard_default_actions default_actions
    def default_actions
      standard_default_actions + [:delete]
    end
  end
end

module DeleteResourceRoute
  def resources(*args, &block)
    super(*args) do
      yield if block_given?

      member do
        get "delete" if parent_resource.actions.include?(:delete)
      end
    end
  end

  def resource(*args, &block)
    super(*args) do
      yield if block_given?

      get "delete" if parent_resource.actions.include?(:delete)
    end
  end
end

ActionDispatch::Routing::Mapper.send(:include, DeleteResourceRoute)
