require "kvizovi/mediators/quizzes"

module Kvizovi
  class App
    plugin :header_matchers

    route "quizzes" do |r|
      auth = {header: "HTTP_AUTHORIZATION"}

      r.get true, auth do
        Mediators::Quizzes.new(current_user).all
      end

      r.get true do
        Mediators::Quizzes.search(params)
      end

      r.post true, auth do
        Mediators::Quizzes.new(current_user).create(resource(:quiz))
      end

      r.is ":id" do |id|
        r.get auth do
          Mediators::Quizzes.new(current_user).find(id)
        end

        r.get do
          Mediators::Quizzes.find(id)
        end

        r.patch auth do
          Mediators::Quizzes.new(current_user).update(id, resource(:quiz))
        end

        r.delete auth do
          Mediators::Quizzes.new(current_user).destroy(id)
        end
      end
    end
  end
end
