require 'spec_helper'

describe HomeController do
  it "renders the layout" do
    get :index
  end
end
